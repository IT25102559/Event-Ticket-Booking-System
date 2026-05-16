<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login | EventTix</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/site.css">
    <script src="https://unpkg.com/feather-icons"></script>
    <script defer src="${pageContext.request.contextPath}/assets/js/site.js"></script>

    <style>
        body {
            min-height: 100vh;
            background: linear-gradient(rgba(26, 26, 46, 0.8), rgba(22, 33, 62, 0.9)), url('../images/Register.jpg') no-repeat center center fixed;
            background-size: cover;
            display: flex;
            flex-direction: column;
            margin: 0;
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
            max-width: 420px;
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

        /* 🌟 ‍  Auto-fill       ‍  🌟 */
        .custom-input:-webkit-autofill,
        .custom-input:-webkit-autofill:hover,
        .custom-input:-webkit-autofill:focus,
        .custom-input:-webkit-autofill:active {
            -webkit-text-fill-color: white !important;
            transition: background-color 5000s ease-in-out 0s;
            caret-color: white;
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
        .input-label { color: #e2e8f0; font-weight: 600; letter-spacing: 0.5px; margin-bottom: 8px; }

        /* Floating Toast CSS */
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

<nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold" href="../event_ui/view_dramas.jsp"><i data-feather="film"></i> EventTix</a>
        <div class="navbar-nav ms-auto align-items-center">
            <a class="nav-link" href="../event_ui/view_dramas.jsp">Home</a>
            <a class="nav-link" href="../booking_ui/book_ticket.jsp">Book Tickets</a>
            <a class="nav-link" href="../booking_ui/view_bookings.jsp">My Bookings</a>
            <a class="nav-link text-warning fw-bold" href="../payment_ui/payment_form.jsp">Make Payment</a>
        </div>
    </div>
</nav>

<%
    String error = request.getParameter("error");
    String msg = request.getParameter("msg");
%>

<% if ("registered".equals(msg)) { %>
    <div class="custom-toast" id="successToast" style="border: 1px solid rgba(16, 185, 129, 0.5); box-shadow: 0 10px 30px rgba(16, 185, 129, 0.3);">
        <div class="toast-icon" style="background: rgba(16, 185, 129, 0.2); color: #10b981;">
            <i data-feather="check-circle" style="width: 24px;"></i>
        </div>
        <div>
            <strong style="color: #10b981; font-size: 1.1rem;">Registration Successful!</strong>
            <span class="d-block text-light" style="font-size: 0.9rem;">You can now login with your account.</span>
        </div>
        <button type="button" class="btn-close btn-close-white ms-3" onclick="closeToast('successToast')"></button>
    </div>
<% } %>

<% if (error != null) { %>
    <div class="custom-toast" id="errorToast" style="border: 1px solid rgba(239, 68, 68, 0.5); box-shadow: 0 10px 30px rgba(239, 68, 68, 0.3);">
        <div class="toast-icon" style="background: rgba(239, 68, 68, 0.2); color: #ef4444;">
            <i data-feather="alert-circle" style="width: 24px;"></i>
        </div>
        <div>
            <strong style="color: #ef4444; font-size: 1.1rem;"><%= "login_first".equals(error) ? "Access Denied!" : "Login Failed!" %></strong>
            <span class="d-block text-light" style="font-size: 0.9rem;">
                <%= "login_first".equals(error) ? "Please login to access this page." : "Invalid username or password." %>
            </span>
        </div>
        <button type="button" class="btn-close btn-close-white ms-3" onclick="closeToast('errorToast')"></button>
    </div>
<% } %>

<script>
    function closeToast(toastId) {
        let toast = document.getElementById(toastId);
        if(toast) {
            toast.style.animation = 'slideUpToast 0.5s forwards';
            setTimeout(() => toast.remove(), 500);
        }
    }

    setTimeout(() => closeToast('successToast'), 6000);
    setTimeout(() => closeToast('errorToast'), 6000);
</script>

<div class="login-wrapper">
    <div class="login-card">
        <h2 class="text-center mb-4">
            <i data-feather="log-in" class="me-2 text-info" style="width: 28px; height: 28px;"></i>
            <span class="gradient-text">Welcome Back</span>
        </h2>

        <form action="../LoginServlet" method="POST">
            <div class="mb-4">
                <label class="form-label input-label"><i data-feather="mail" class="me-2 text-info" style="width:16px;"></i> Email Address</label>
                <input type="email" name="email" class="form-control custom-input" placeholder="you@example.com" required>
            </div>

            <div class="mb-5">
                <label class="form-label input-label"><i data-feather="lock" class="me-2 text-info" style="width:16px;"></i> Password</label>
                <input type="password" name="password" class="form-control custom-input" placeholder="........" required>
            </div>

            <button type="submit" class="btn btn-glow w-100 mb-4">
                <i data-feather="arrow-right-circle" class="me-2"></i> Login
            </button>
        </form>

        <div class="text-center">
            <span style="color: #cbd5e1;">New user? </span>
            <a href="register.jsp" style="color: #00c6ff; text-decoration: none; font-weight: bold;">Register here</a>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>feather.replace();</script>
</body>
</html>