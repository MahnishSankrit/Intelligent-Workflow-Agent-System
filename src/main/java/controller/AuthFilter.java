package controller;

import java.io.IOException;
import java.util.List;
import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.*;

@WebFilter("/*")
public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // optional
    }

    @Override
    public void destroy() {
        // optional
    }

    @SuppressWarnings("unchecked")
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);

        String path = req.getRequestURI();

        // Allow login page
        if (path.contains("login.jsp") || path.contains("login")) {
            chain.doFilter(request, response);
            return;
        }

        // Not logged in
        if (session == null || session.getAttribute("user") == null) {
            res.sendRedirect("login.jsp");
            return;
        }

        List<String> perms = (List<String>) session.getAttribute("permissions");

        // Protect delete user
        if (path.contains("deleteUser") &&
                (perms == null || !perms.contains("DELETE_USER"))) {
            res.sendRedirect("accessDenied.jsp");
            return;
        }

        chain.doFilter(request, response);
    }
}