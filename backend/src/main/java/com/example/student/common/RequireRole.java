package com.example.student.common;

import java.lang.annotation.*;

/**
 * 方法级角色权限注解，配合 {@link com.example.student.interceptor.RoleInterceptor} 使用。
 *
 * <p>标注在 Controller 类或方法上，声明允许访问的角色列表。
 * 方法上的注解优先级高于类上的注解。未标注的接口仅要求已登录
 * （认证由 JwtInterceptor 保证），不做角色限制。</p>
 *
 * <pre>
 * 示例：
 * &#64;RequireRole({"admin", "teacher"})        // 类级别：管理员和教师
 * &#64;RequireRole("student")                    // 方法级别：仅学生
 * </pre>
 */
@Target({ElementType.METHOD, ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface RequireRole {

    /**
     * 允许访问的角色列表，例如 {"admin"}、{"admin", "teacher"}、{"student"}
     */
    String[] value();
}
