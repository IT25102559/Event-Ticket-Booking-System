<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Register | EventTix</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/site.css">
    <script src="https://unpkg.com/feather-icons"></script>
    <script defer src="${pageContext.request.contextPath}/assets/js/site.js"></script>

    <style>
        body {
            /*  Background  */
            background: linear-gradient(rgba(26, 26, 46, 0.8), rgba(22, 33, 62, 0.9)), url('../images/Register.jpg') no-repeat center center fixed;
            background-size: cover;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            color: white;
        }

        .login-wrapper {
            flex-grow: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        /*  Glassmorphism Card  */
        .login-card {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 1.5rem;
            padding: 2.5rem;
            width: 100%;
            max-width: 450px;
            box-shadow: 0 25px 45px rgba(0,0,0,0.5);
            color: white;
        }

        .gradient-text {
            background: linear-gradient(135deg, #00c6ff 0%, #0072ff 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            font-weight: 800;
            letter-spacing: 1px;
        }

        .custom-input {
            background: rgba(255, 255, 255, 0.08) !important;
            border: 1px solid rgba(255, 255, 255, 0.2) !important;
            color: white !important;
            border-radius: 0.8rem;
            padding: 12px 15px;
            transition: all 0.3s ease;
        }

        .custom-input:focus {
            background: rgba(255, 255, 255, 0.12) !important;
            border-color: #00c6ff !important;
            box-shadow: 0 0 15px rgba(0, 198, 255, 0.4) !important;
        }

        .custom-input::placeholder { color: rgba(255, 255, 255, 0.5) !important; }

        .btn-glow {
            background: linear-gradient(135deg, #00c6ff, #0072ff);
            color: white;
            border: none;
            border-radius: 50px;
            padding: 12px;
            font-size: 1.1rem;
            font-weight: bold;
            letter-spacing: 1px;
            transition: all 0.3s ease;
            box-shadow: 0 8px 20px rgba(0, 114, 255, 0.4);
        }

        .btn-glow:hover { transform: translateY(-3px); box-shadow: 0 12px 25px rgba(0, 114, 255, 0.6); color: white; }
        .input-label { color: #e2e8f0; font-weight: 600; letter-spacing: 0.5px; margin-bottom: 8px; font-size: 0.9rem;}

        /* 👇 Floating Toast CSS 👇 */
        .custom-toast {
            position: fixed; top: 30px; left: 50%; transform: translateX(-50%);
            background: rgba(15, 23, 42, 0.9); backdrop-filter: blur(15px); -webkit-backdrop-filter: blur(15px);
            padding: 15px 25px; border-radius: 12px; z-index: 9999; display: flex; align-items: center; gap: 15px;
            animation: slideDownToast 0.5s forwards;
        }
        .toast-icon { width: 40px; height: 40px; border-radius: 50%; display: flex; justify-content: center; align-items: center; }
        @keyframes slideDownToast { 0% { top: -100px; opacity: 0; } 100% { top: 30px; opacity: 1; } }
        @keyframes slideUpToast { 0% { top: 30px; opacity: 1; } 100% { top: -100px; opacity: 0; } }
    </style>
</head>
<body>

<!-- Navigation Bar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm w-100">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold" href="../event_ui/view_dramas.jsp"><i data-feather="film"></i> EventTix</a>
        <div class="navbar-nav ms-auto align-items-center">
            <a class="nav-link" href="../event_ui/view_dramas.jsp">Home</a>
            <a class="nav-link btn btn-outline-info btn-sm ms-lg-3 px-3" href="login.jsp" style="border-radius: 20px;">Login</a>
        </div>
    </div>
</nav>

<!-- 👇 Register Error Message (   ) 👇 -->
<% String error = request.getParameter("error"); %>
<% if (error != null) { %>
    <div class="custom-toast" id="errorToast" style="border: 1px solid rgba(239, 68, 68, 0.5); box-shadow: 0 10px 30px rgba(239, 68, 68, 0.3);">
        <div class="toast-icon" style="background: rgba(239, 68, 68, 0.2); color: #ef4444;">
            <i data-feather="alert-circle" style="width: 24px;"></i>
        </div>
        <div>
            <strong style="color: #ef4444; font-size: 1.1rem;">Registration Failed!</strong>
            <span class="d-block text-light" style="font-size: 0.9rem;">
                <%= "exception".equals(error) ? "This Email is already registered. Please login." : "Something went wrong. Try again." %>
            </span>
        </div>
        <button type="button" class="btn-close btn-close-white ms-3" onclick="closeToast()"></button>
    </div>
    <script>
        function closeToast() {
            let toast = document.getElementById('errorToast');
            if(toast) { toast.style.animation = 'slideUpToast 0.5s forwards'; setTimeout(() => toast.remove(), 500); }
        }
        setTimeout(closeToast, 6000); //  6 
    </script>
<% } %>
<!-- 👆 ---------------------- 👆 -->

<div class="login-wrapper">
    <div class="login-card">
        <h3 class="text-center mb-4">
            <i data-feather="user-plus" class="me-2 text-info" style="width: 28px; height: 28px;"></i>
            <span class="gradient-text">Create Account</span>
        </h3>

        <form action="../RegisterServlet" method="POST">

            <!-- First Name  Last Name   -->
            <div class="row mb-3">
                <div class="col-6">
                    <label class="form-label input-label"><i data-feather="user" class="me-2 text-info" style="width:16px;"></i> First Name</label>
                    <input type="text" name="firstName" class="form-control custom-input" placeholder="e.g. Kamal" required>
                </div>
                <div class="col-6">
                    <label class="form-label input-label"><i data-feather="user" class="me-2 text-info" style="width:16px;"></i> Last Name</label>
                    <input type="text" name="lastName" class="form-control custom-input" placeholder="e.g. Perera" required>
                </div>
            </div>

            <!-- Phone Number ( 10   ) -->
            <div class="mb-3">
                <label class="form-label input-label"><i data-feather="phone" class="me-2 text-info" style="width:16px;"></i> Phone Number</label>
                <input type="text" name="phone" class="form-control custom-input" placeholder="07XXXXXXXX"
                       maxlength="10"
                       pattern="[0-9]{10}"
                       title="Please enter a valid 10-digit phone number"
                       oninput="this.value = this.value.replace(/[^0-9]/g, '')"
                       required>
            </div>

            <!-- Email Address (  Login   ) -->
            <div class="mb-3">
                <label class="form-label input-label"><i data-feather="mail" class="me-2 text-info" style="width:16px;"></i> Email Address</label>
                <input type="email" name="email" class="form-control custom-input" placeholder="you@example.com" required>
            </div>

            <!-- Password -->
            <div class="mb-4">
                <label class="form-label input-label"><i data-feather="lock" class="me-2 text-info" style="width:16px;"></i> Create Password</label>
                <input type="password" name="password" class="form-control custom-input" placeholder="........" required>
            </div>

            <button type="submit" class="btn btn-glow w-100 mb-3">
                <i data-feather="check-circle" class="me-2"></i> Register Now
            </button>
        </form>

        <div class="text-center mt-2">
            <span style="color: #cbd5e1; font-size: 0.9rem;">Already have an account? </span>
            <a href="login.jsp" style="color: #00c6ff; text-decoration: none; font-weight: bold; font-size: 0.9rem;">Login here</a>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>feather.replace();</script>
</body>
</html>