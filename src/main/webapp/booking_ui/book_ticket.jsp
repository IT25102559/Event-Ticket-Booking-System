<%@ page import="ticket_booking.BookingManager" %>
<%
    // 1.        (Security Check)
    String loggedUser = (String) session.getAttribute("username");

    if (loggedUser == null) {
        //     Login   
        response.sendRedirect("../user_ui/login.jsp?msg=login_first");
        return;
    }

    // 2.        
    String selectedDrama = request.getParameter("drama");
    if (selectedDrama == null) selectedDrama = "";

    BookingManager bm = new BookingManager();
    int maxSeats = 20;
    int standardAvail = maxSeats - bm.getBookedSeats(selectedDrama, 1000.0);
    int silverAvail   = maxSeats - bm.getBookedSeats(selectedDrama, 1500.0);
    int goldAvail     = maxSeats - bm.getBookedSeats(selectedDrama, 2000.0);
    int vipAvail      = maxSeats - bm.getBookedSeats(selectedDrama, 2500.0);
%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Book Ticket | EventTix</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/site.css">
    <script src="https://unpkg.com/feather-icons"></script>
    <script defer src="${pageContext.request.contextPath}/assets/js/site.js"></script>
    <style>
        body {
            background: linear-gradient(rgba(26, 26, 46, 0.5), rgba(22, 33, 62, 0.7)), url('../images/Ticket.jpg') no-repeat center center fixed;
            background-size: cover;
            color: white;
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .booking-card {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 1.5rem;
            padding: 2.5rem;
            width: 100%;
            box-shadow: 0 25px 45px rgba(0,0,0,0.5);
            animation: slideFade 0.6s ease-out;
        }

        @keyframes slideFade {
            0%   { opacity: 0; transform: translateY(30px); }
            100% { opacity: 1; transform: translateY(0); }
        }

        .gradient-text {
            background: linear-gradient(135deg, #00c6ff 0%, #0072ff 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            font-weight: 800;
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
        .custom-input option { background: #1a1a2e; color: white; }

        .input-label { color: #e2e8f0; font-weight: 600; letter-spacing: 0.5px; margin-bottom: 8px; }

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

        .btn-glow:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 25px rgba(0, 114, 255, 0.6);
            color: white;
        }

        .btn-outline-glass {
            border: 1px solid #00c6ff;
            color: #00c6ff;
            border-radius: 50px;
            padding: 10px;
            font-weight: bold;
            transition: all 0.3s;
            text-decoration: none;
            display: block;
            text-align: center;
        }

        .btn-outline-glass:hover {
            background: rgba(0, 198, 255, 0.1);
            color: #00c6ff;
            transform: translateY(-2px);
        }

        .custom-toast {
            position: fixed;
            top: 30px;
            left: 50%;
            transform: translateX(-50%);
            background: rgba(15, 23, 42, 0.9);
            backdrop-filter: blur(15px);
            -webkit-backdrop-filter: blur(15px);
            border: 1px solid rgba(16, 185, 129, 0.5);
            padding: 15px 25px;
            border-radius: 12px;
            z-index: 9999;
            display: flex;
            align-items: center;
            gap: 15px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.6), 0 0 20px rgba(16, 185, 129, 0.2);
            animation: slideDownToast 0.6s cubic-bezier(0.175, 0.885, 0.32, 1.275) forwards;
        }

        .toast-icon {
            background: rgba(16, 185, 129, 0.2);
            color: #10b981;
            width: 45px;
            height: 45px;
            border-radius: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .toast-content strong {
            color: #10b981;
            font-size: 1.15rem;
            letter-spacing: 0.5px;
        }

        @keyframes slideDownToast {
            0% { top: -100px; opacity: 0; transform: translate(-50%, -20px) scale(0.9); }
            100% { top: 30px; opacity: 1; transform: translate(-50%, 0) scale(1); }
        }

        @keyframes slideUpToast {
            0% { top: 30px; opacity: 1; transform: translate(-50%, 0) scale(1); }
            100% { top: -100px; opacity: 0; transform: translate(-50%, -20px) scale(0.9); }
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm w-100">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold" href="../event_ui/view_dramas.jsp"><i data-feather="film"></i> EventTix</a>
        <div class="navbar-nav ms-auto align-items-center">
            <a class="nav-link" href="../event_ui/view_dramas.jsp">Home</a>
            <a class="nav-link text-info fw-bold" href="../booking_ui/book_ticket.jsp">Book Tickets</a>
            <a class="nav-link" href="../booking_ui/view_bookings.jsp">My Bookings</a>
            <a class="nav-link text-warning fw-bold" href="../payment_ui/payment_form.jsp">Make Payment</a>
            <a class="nav-link btn btn-outline-danger btn-sm ms-lg-3 px-3" href="../user_ui/login.jsp" style="border-radius: 20px;">Logout</a>
        </div>
    </div>
</nav>

<!-- 👇 Floating Success/Error Messages 👇 -->
<%
    String success = request.getParameter("success");
    String error   = request.getParameter("error");
    String price   = request.getParameter("price");
    String bkg_id  = request.getParameter("bkg_id");
%>

<% if ("true".equals(success)) { %>
    <div class="custom-toast" id="myToast">
        <div class="toast-icon">
            <i data-feather="check-circle" style="width: 24px; height: 24px;"></i>
        </div>
        <div class="toast-content">
            <strong>Booking Successful!</strong>
            <span class="d-block text-light mt-1" style="font-size: 0.9rem;">Total Amount: <b class="text-warning">Rs. <%= (price != null ? price : "0.00") %></b></span>
            <% if(bkg_id != null) { %>
                <span class="d-block text-light" style="font-size: 0.85rem;">Booking ID: <%= bkg_id %></span>
            <% } %>
        </div>
        <button type="button" class="btn-close btn-close-white ms-3" onclick="closeToast()"></button>
    </div>
<% } else if ("true".equals(error)) { %>
    <div class="custom-toast" id="myToast" style="border-color: rgba(239, 68, 68, 0.5); box-shadow: 0 20px 40px rgba(0,0,0,0.6), 0 0 20px rgba(239, 68, 68, 0.2);">
        <div class="toast-icon" style="background: rgba(239, 68, 68, 0.2); color: #ef4444;">
            <i data-feather="alert-circle" style="width: 24px; height: 24px;"></i>
        </div>
        <div class="toast-content">
            <strong style="color: #ef4444;">Booking Failed!</strong>
            <span class="d-block text-light mt-1" style="font-size: 0.9rem;">Please try again or check your details.</span>
        </div>
        <button type="button" class="btn-close btn-close-white ms-3" onclick="closeToast()"></button>
    </div>
<% } %>

<script>
    function closeToast() {
        let toast = document.getElementById('myToast');
        if(toast) {
            toast.style.animation = 'slideUpToast 0.5s forwards';
            setTimeout(() => toast.remove(), 500);
        }
    }
    //    6   
    if(document.getElementById('myToast')) {
        setTimeout(closeToast, 6000);
    }
</script>

<div class="container my-5 d-flex justify-content-center flex-grow-1">
    <div class="booking-card" style="max-width: 550px;">
        <h3 class="text-center mb-4">
            <i data-feather="ticket" class="me-2 text-info" style="width: 28px; height: 28px;"></i>
            <span class="gradient-text">Book Your Ticket</span>
        </h3>

        <!-- 👇  form  autocomplete="off"  👇 -->
        <form action="../BookTicketServlet" method="POST" autocomplete="off">
            <div class="mb-3">
                <label class="form-label input-label"><i data-feather="user" class="me-2 text-info" style="width:16px;"></i> Customer Name</label>
                <!-- 👇  input  autocomplete="off"  👇 -->
                <input type="text" name="customerName" class="form-control custom-input" placeholder="e.g. Kamal Perera" autocomplete="off" required>
            </div>

            <div class="mb-3">
                <label class="form-label input-label"><i data-feather="film" class="me-2 text-info" style="width:16px;"></i> Drama Name</label>
                <!-- 👇  input  autocomplete="off"  👇 -->
                <input type="text" name="dramaName" class="form-control custom-input" value="<%= selectedDrama %>" placeholder="e.g. Maname" autocomplete="off" required>
            </div>

            <div class="mb-3">
                <label class="form-label input-label"><i data-feather="layers" class="me-2 text-info" style="width:16px;"></i> Select Ticket Category</label>
                <select name="ticketCategory" class="form-select custom-input" required>
                    <option value="1000" <%= standardAvail <= 0 ? "disabled" : "" %>>Standard – Rs. 1000 (Available: <%= standardAvail %>/<%= maxSeats %>)</option>
                    <option value="1500" <%= silverAvail <= 0 ? "disabled" : "" %>>Silver – Rs. 1500 (Available: <%= silverAvail %>/<%= maxSeats %>)</option>
                    <option value="2000" <%= goldAvail <= 0 ? "disabled" : "" %>>Gold – Rs. 2000 (Available: <%= goldAvail %>/<%= maxSeats %>)</option>
                    <option value="2500" <%= vipAvail <= 0 ? "disabled" : "" %>>VIP – Rs. 2500 (Available: <%= vipAvail %>/<%= maxSeats %>)</option>
                </select>
            </div>

            <div class="mb-4">
                <label class="form-label input-label"><i data-feather="users" class="me-2 text-info" style="width:16px;"></i> Number of Seats</label>
                <input type="number" name="numberOfSeats" class="form-control custom-input" min="1" max="20" value="1" required>
            </div>

            <button type="submit" class="btn btn-glow w-100 mb-3">
                <i data-feather="check-circle" class="me-2"></i> Confirm Booking
            </button>

            <a href="view_bookings.jsp" class="btn-outline-glass w-100 mt-2">
                <i data-feather="eye" class="me-2" style="width: 18px;"></i> View All Bookings
            </a>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    feather.replace();
</script>
</body>
</html>