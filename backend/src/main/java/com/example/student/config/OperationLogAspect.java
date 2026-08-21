package com.example.student.config;

import com.alibaba.fastjson.JSON;
import com.example.student.entity.OperationLog;
import com.example.student.entity.Student;
import com.example.student.entity.User;
import com.example.student.service.OperationLogService;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import java.lang.reflect.Method;
import java.util.concurrent.*;

@Aspect
@Component
public class OperationLogAspect {

    @Autowired
    private OperationLogService operationLogService;

    private static final ExecutorService logExecutor = new ThreadPoolExecutor(
            2, 4, 60L, TimeUnit.SECONDS,
            new LinkedBlockingQueue<>(1000),
            new ThreadFactory() {
                private int count = 0;
                @Override
                public Thread newThread(Runnable r) {
                    Thread thread = new Thread(r);
                    thread.setName("log-async-" + count++);
                    thread.setDaemon(true);
                    return thread;
                }
            },
            new ThreadPoolExecutor.CallerRunsPolicy()
    );

    @Around("execution(* com.example.student.controller.*.*(..)) && !execution(* com.example.student.controller.OperationLogController.*(..))")
    public Object around(ProceedingJoinPoint point) throws Throwable {
        long startTime = System.currentTimeMillis();
        
        ServletRequestAttributes attributes = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        if (attributes == null) {
            return point.proceed();
        }
        HttpServletRequest request = attributes.getRequest();
        
        // 从 JwtInterceptor 写入的 request attribute 中取当前登录用户
        // （此前错误地从请求头 X-Username 取值，导致日志用户名始终为 anonymous）
        String username = (String) request.getAttribute("username");
        if (username == null || username.isEmpty()) {
            username = "anonymous";
        }
        String realName = resolveRealName(request, username);
        Integer userId = (Integer) request.getAttribute("userId");
        
        MethodSignature signature = (MethodSignature) point.getSignature();
        Method method = signature.getMethod();
        String className = point.getTarget().getClass().getSimpleName();
        String methodName = method.getName();
        
        String operationDesc = buildOperationDesc(className, methodName);
        String operationModule = getOperationModule(className);
        String operationType = getOperationType(request.getMethod());
        
        String requestParams = getRequestParams(point.getArgs());
        
        OperationLog log = new OperationLog();
        log.setUserId(userId);
        log.setUsername(username);
        log.setRealName(realName);
        log.setOperationType(operationType);
        log.setOperationModule(operationModule);
        log.setOperationDesc(operationDesc);
        log.setRequestMethod(request.getMethod());
        log.setRequestUrl(request.getRequestURI());
        log.setRequestParams(requestParams);
        log.setIpAddress(getClientIp(request));
        log.setUserAgent(request.getHeader("User-Agent"));
        
        Object result = null;
        try {
            result = point.proceed();
            log.setStatus(1);
            log.setResponseData(truncateString(JSON.toJSONString(result), 2000));
        } catch (Exception e) {
            log.setStatus(0);
            log.setErrorMsg(truncateString(e.getMessage(), 500));
            throw e;
        } finally {
            long executionTime = System.currentTimeMillis() - startTime;
            log.setExecutionTime((int) executionTime);
            
            logExecutor.submit(() -> {
                try {
                    operationLogService.saveLog(log);
                } catch (Exception e) {
                    System.err.println("保存操作日志失败: " + e.getMessage());
                }
            });
        }
        
        return result;
    }
    
    /**
     * 从 JwtInterceptor 注入的 user 对象中解析真实姓名（用户表取 realName，学生表取 name）
     */
    private String resolveRealName(HttpServletRequest request, String fallback) {
        Object user = request.getAttribute("user");
        if (user instanceof User) {
            String realName = ((User) user).getRealName();
            if (realName != null && !realName.isEmpty()) {
                return realName;
            }
        } else if (user instanceof Student) {
            String name = ((Student) user).getName();
            if (name != null && !name.isEmpty()) {
                return name;
            }
        }
        return fallback;
    }

    private String buildOperationDesc(String className, String methodName) {
        String module = getModuleName(className);
        String action = getActionName(methodName);
        return action + module;
    }
    
    private String getModuleName(String className) {
        if (className.contains("Student")) return "学生信息";
        if (className.contains("Course")) return "课程信息";
        if (className.contains("Score")) return "成绩信息";
        if (className.contains("Class")) return "班级信息";
        if (className.contains("User")) return "用户信息";
        if (className.contains("Attendance")) return "考勤记录";
        if (className.contains("Warning")) return "预警记录";
        if (className.contains("Export")) return "数据导出";
        if (className.contains("Scholarship")) return "奖学金";
        if (className.contains("Schedule")) return "课程安排";
        return "系统数据";
    }
    
    private String getActionName(String methodName) {
        if (methodName.startsWith("add") || methodName.startsWith("create") || methodName.startsWith("insert")) return "新增";
        if (methodName.startsWith("update") || methodName.startsWith("edit") || methodName.startsWith("modify")) return "修改";
        if (methodName.startsWith("delete") || methodName.startsWith("remove")) return "删除";
        if (methodName.startsWith("get") || methodName.startsWith("list") || methodName.startsWith("find") || methodName.startsWith("query")) return "查询";
        if (methodName.startsWith("export")) return "导出";
        if (methodName.startsWith("import")) return "导入";
        if (methodName.startsWith("login")) return "登录";
        if (methodName.startsWith("logout")) return "登出";
        return "操作";
    }
    
    private String getOperationModule(String className) {
        if (className.contains("Student")) return "STUDENT";
        if (className.contains("Course")) return "COURSE";
        if (className.contains("Score")) return "SCORE";
        if (className.contains("Class")) return "CLASS";
        if (className.contains("User")) return "USER";
        if (className.contains("Attendance")) return "ATTENDANCE";
        if (className.contains("Warning")) return "WARNING";
        if (className.contains("Export")) return "EXPORT";
        if (className.contains("Auth")) return "AUTH";
        if (className.contains("Scholarship")) return "SCHOLARSHIP";
        if (className.contains("Schedule")) return "SCHEDULE";
        return "SYSTEM";
    }
    
    private String getOperationType(String httpMethod) {
        switch (httpMethod.toUpperCase()) {
            case "GET": return "QUERY";
            case "POST": return "INSERT";
            case "PUT": return "UPDATE";
            case "DELETE": return "DELETE";
            default: return "OTHER";
        }
    }
    
    private String getRequestParams(Object[] args) {
        if (args == null || args.length == 0) {
            return "";
        }
        try {
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i < args.length; i++) {
                if (args[i] != null && !(args[i] instanceof HttpServletRequest)) {
                    sb.append(JSON.toJSONString(args[i]));
                    if (i < args.length - 1) {
                        sb.append(", ");
                    }
                }
            }
            return truncateString(sb.toString(), 1000);
        } catch (Exception e) {
            return "";
        }
    }
    
    private String getClientIp(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getHeader("WL-Proxy-Client-IP");
        }
        if (ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
            ip = request.getRemoteAddr();
        }
        return ip != null ? ip.split(",")[0].trim() : "";
    }
    
    private String truncateString(String str, int maxLength) {
        if (str == null) return "";
        return str.length() > maxLength ? str.substring(0, maxLength) + "..." : str;
    }
}
