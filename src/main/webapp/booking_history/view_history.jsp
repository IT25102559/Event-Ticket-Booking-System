<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, ticket_booking.Ticket, booking_history.BookingHistoryManager" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Booking Report | Admin</title>
    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/site.css">
    <!-- Feather icons (lightweight) -->
    <script src="https://unpkg.com/feather-icons"></script>
    <script defer src="${pageContext.request.contextPath}/assets/js/site.js"></script>
    <style>
        /* 1️⃣ Same dark gradient used across the whole app */
        body {
            min-height: 100vh;
            background: linear-gradient(135deg, #1a1a2e, #16213e);
            display: flex;
            flex-direction: column;
            font-family: system-ui, sans-serif;
        }
        /* 2️⃣ Card slide‑fade animation */
        @keyframes slideFade {
            0%   { opacity: 0; transform: translateY(30px); }
            100% { opacity: 1; transform: translateY(0); }
        }
        .report-card {
            animation: slideFade 0.8s ease-out;
            border-radius: 1rem;
        }
        /* 3️⃣ Hover lift for buttons */
        .btn-primary, .btn-outline-primary {
            transition: transform .2s, box-shadow .2s;
        }
        .btn-primary:hover, .btn-outline-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 15px rgba(0,0,0,.2);
        }
        /* 4️⃣ Toast container (optional messages) */
        .toast-container {
            position: fixed;
            top: 1rem;
            right: 1rem;
            z-index: 1055;
        }
    </style>
</head>
<body>
<nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm w-100">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold text-info" href="#">
            <i data-feather="bar-chart-2"></i> Booking Reports
        </a>
        <div class="navbar-nav ms-auto">
            <a class="nav-link" href="../admin_ui/manage_dramas.jsp">Admin Home</a>
            <a class="nav-link active" href="view_history.jsp">Booking History</a>
            <a class="nav-link text-danger" href="../user_ui/login.jsp">Logout</a>
        </div>
    </div>
</nav>
<div class="container my-4 flex-grow-1 d-flex justify-content-center">
    <div class="report-card shadow-lg bg-white p-4" style="max-width: 1000px;">
        <h3 class="text-center fw-bold mb-4">
            <i data-feather="file-text"></i> Comprehensive Booking Report
        </h3>
        <!-- Optional toast for messages (e.g., ?msg=deleted) -->
        <div class="toast-container">
            <% String msg = request.getParameter("msg");
               if ("deleted".equals(msg)) { %>
            <div class="toast align-items-center text-bg-danger border-0 show" role="alert">
                <div class="d-flex">
                    <div class="toast-body">Report entry removed successfully.</div>
                    <button type="button" class="btn-close btn-close-white me-2 m-auto"
                            data-bs-dismiss="toast"></button>
                </div>
            </div>
            <% } %>
        </div>
        <%
            BookingHistoryManager manager = new BookingHistoryManager();
            List<Ticket> list = manager.getAllBookings();
            double totalRevenue = 0;
        %>
        <div class="table-responsive">
            <table class="table table-striped align-middle">
                <thead class="table-info">
                    <tr>
                        <th>Booking ID</th>
                        <th>Customer Name</th>
                        <th>Drama Name</th>
                        <th>Seats</th>
                        <th class="text-end">Income (Rs.)</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Ticket t : list) {
                           double income = t.getSeats() * 1000.0; // each seat = Rs.1000
                           totalRevenue += income;
                    %>
                    <tr>
                        <td><small class="text-muted"><%= t.getBookingId() %></small></td>
                        <td class="fw-bold"><%= t.getCustomerName() %></td>
                        <td><%= t.getDramaName() %></td>
                        <td class="text-center"><%= t.getSeats() %></td>
                        <td class="text-end fw-bold"><%= String.format("%.2f", income) %></td>
                    </tr>
                    <% } %>
                </tbody>
                <tfoot>
                    <tr class="table-dark">
                        <td colspan="4" class="text-end fw-bold fs-5">Total Revenue:</td>
                        <td class="text-end fw-bold fs-5 text-warning">
                            Rs. <%= String.format("%.2f", totalRevenue) %>
                        </td>
                    </tr>
                </tfoot>
            </table>
        </div>
    </div>
</div>
<!-- Bootstrap bundle (includes Popper) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Render feather icons
    feather.replace();
    // Auto‑dismiss any toast after 4 seconds
    const toastEls = document.querySelectorAll('.toast');
    toastEls.forEach(el => new bootstrap.Toast(el, { delay: 4000 }).show());
</script>
</body>
</html>