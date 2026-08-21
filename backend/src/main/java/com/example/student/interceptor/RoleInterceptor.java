package com.example.student.interceptor;

import com.example.student.common.RequireRole;
import com.example.student.common.Result;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.stereotype.Component;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.servlet.HandlerInterceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Arrays;

/**
 * 方法级角色鉴权拦截器。
 *
 * <p>在 {@link JwtInterceptor} 之后执行：JwtInterceptor 负责认证（校验 token 并把
 * username/role/userId/user 写入 request attribute），本拦截器负责授权——
 * 校验当前用户角色是否在接口声明的 {@link RequireRole} 角色列表中。</p>
 *
 * <ul>
 *   <li>方法上的 @RequireRole 优先于类上的 @RequireRole</li>
 *   <li>未标注 @RequireRole 的接口放行（仅要求已登录）</li>
 *   <li>OPTIONS 预检请求直接放行</li>
 * </ul>
 */
@Component
public class RoleInterceptor implements HandlerInterceptor {

    private static final ObjectMapper OBJECT_MAPPER = new ObjectMapper();

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        // 放行 CORS 预检请求
        if ("OPTIONS".equalsIgnoreCase(request.getMethod())) {
            return true;
        }

        if (!(handler instanceof HandlerMethod)) {
            return true;
        }

        HandlerMethod handlerMethod = (HandlerMethod) handler;
        RequireRole requireRole = handlerMethod.getMethodAnnotation(RequireRole.class);
        if (requireRole == null) {
            requireRole = handlerMethod.getBeanType().getAnnotation(RequireRole.class);
        }
        // 未声明角色要求：JwtInterceptor 已保证登录，直接放行
        if (requireRole == null) {
            return true;
        }

        String role = (String) request.getAttribute("role");
        if (role == null) {
            writeJson(response, 401, Result.error(401, "未登录或token无效"));
            return false;
        }

        if (Arrays.asList(requireRole.value()).contains(role)) {
            return true;
        }

        writeJson(response, 403, Result.error(403, "没有权限执行此操作"));
        return false;
    }

    private void writeJson(HttpServletResponse response, int status, Result<?> result) throws Exception {
        response.setStatus(status);
        response.setContentType("application/json;charset=UTF-8");
        response.getWriter().write(OBJECT_MAPPER.writeValueAsString(result));
    }
}
