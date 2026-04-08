<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>IWAS — Login</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>

<div class="login-wrapper">
    <div class="login-card">
        <div class="login-header">
            <div class="login-logo">&#x1F916;</div>
            <h2>IWAS</h2>
            <p>Intelligent Workflow Agent System</p>
        </div>

        <%
        String error = request.getParameter("error");
        if (error != null) {
        %>
            <div class="error-msg">&#x26A0; Invalid email or password. Please try again.</div>
        <%
        }
        %>

        <form action="login" method="post" id="loginForm">
            <div class="form-group">
                <label for="email">Email Address</label>
                <input type="email" id="email" name="email" placeholder="Enter your email" required>
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" placeholder="Enter your password" required>
            </div>

            <button type="submit" class="btn btn-primary btn-lg" id="loginBtn">
                &#x1F512; Sign In
            </button>
        </form>
    </div>
</div>

</body>
</html>