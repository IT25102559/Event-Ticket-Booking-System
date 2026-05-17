<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Payment Successful | EventTix</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/site.css">
    <script src="https://unpkg.com/feather-icons"></script>
    <script defer src="${pageContext.request.contextPath}/assets/js/site.js"></script>
    <style>
        
        body {
            min-height: 100vh;
            background: linear-gradient(135deg, #1a1a2e, #16213e);
            display: flex;
            flex-direction: column;
            font-family: system-ui, sans-serif;
        }
    
        @keyframes slideFade {
            0%   { opacity: 0; transform: translateY(30px); }
            100% { opacity: 1; transform: translateY(0); }
        }
        .success-card {
            animation: slideFade 0.8s ease-out;
            border-radius: 1rem;
        }
        
        .btn-success {
            transition: transform .2s, box-shadow .2s;
        }
        .btn-success:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 15px rgba(0,0,0,.2);
        }
        
        .success-icon {
            color: #198754;
            width: 70px;
            height: 70px;
            margin-bottom: 1rem;
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm w-100">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold" href="../event_ui/view_dramas.jsp">
            <i data-feather="film"></i> EventTix
        </a>
        <div class="navbar-nav ms-auto">
            <a class="nav-link" href="../event_ui/view_dramas.jsp">Home</a>
            <a class="nav-link" href="../booking_ui/book_ticket.jsp">Book Tickets</a>
            <a class="nav-link" href="../booking_ui/view_bookings.jsp">My Bookings</a>
            <a class="nav-link" href="../payment_ui/payment_form.jsp">Make Payment</a>
            <a class="nav-link btn btn-outline-danger btn-sm ms-lg-3" href="../user_ui/login.jsp">Logout</a>
        </div>
    </div>
</nav>

<div class="container my-5 d-flex justify-content-center align-items-center flex-grow-1">
    <div class="success-card shadow-lg bg-white p-5 text-center" style="max-width: 500px; width: 100%;">

        <i data-feather="check-circle" class="success-icon"></i>

        <h2 class="fw-bold text-dark mb-3">Payment Successful!</h2>
        <p class="text-muted mb-4">Your payment has been processed successfully. Thank you for using EventTix!</p>

        <div class="bg-light p-3 rounded-3 mb-4 shadow-sm border">
            <span class="text-muted d-block mb-1 fs-6">Payment ID</span>
            <span class="fw-bold text-success fs-4 tracking-wider">
                <%= request.getParameter("payId") != null ? request.getParameter("payId") : "PAY-123456" %>
            </span>
        </div>

        <a href="../event_ui/view_dramas.jsp" class="btn btn-success w-100 fw-bold py-2 fs-5 shadow-sm">
            <i data-feather="home" class="me-2"></i> Back to Home
        </a>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    
    feather.replace();
</script>
</body>
</html>