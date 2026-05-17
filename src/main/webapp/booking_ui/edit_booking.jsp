<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="user_management.DBConnection" %>
<%
    String loggedUser = (String) session.getAttribute("username");
    if (loggedUser == null) {
        response.sendRedirect("../user_ui/login.jsp?msg=login_first");
        return;
    }

    String id = request.getParameter("id");
    String customerName = "", dramaName = "";
    int seats = 1;
    double price = 0;

    if (id != null) {
        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement pst = con.prepareStatement("SELECT * FROM bookings WHERE booking_id=?");
            pst.setString(1, id);
            ResultSet rs = pst.executeQuery();
            if(rs.next()){
                customerName = rs.getString("customer_name");
                dramaName = rs.getString("drama_name");
                seats = rs.getInt("seats");
                price = rs.getDouble("category_price");
            }
        } catch(Exception e) { e.printStackTrace(); }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Booking | EventTix</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/site.css">
    <script src="https://unpkg.com/feather-icons"></script>
    <script defer src="${pageContext.request.contextPath}/assets/js/site.js"></script>
    <style>
        body {
            
            background: linear-gradient(rgba(15, 15, 30, 0.8), rgba(10, 10, 20, 0.9)), url('../images/stage_bg.jpg') no-repeat center center fixed;
            background-size: cover;
            color: white;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .card-custom {
            
            background: rgba(15, 20, 40, 0.75);
            backdrop-filter: blur(15px);
            -webkit-backdrop-filter: blur(15px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 1.5rem;
            padding: 2.5rem;
            width: 100%;
            max-width: 450px;
            box-shadow: 0 25px 45px rgba(0,0,0,0.7);
        }
        .custom-input { background: rgba(255, 255, 255, 0.08) !important; border: 1px solid rgba(255, 255, 255, 0.2) !important; color: white !important; border-radius: 0.8rem;}
        .custom-input:focus { border-color: #00c6ff !important; box-shadow: 0 0 15px rgba(0, 198, 255, 0.4) !important;}
    </style>
</head>
<body>

<div class="container d-flex justify-content-center">
    <div class="card-custom">
        <h4 class="mb-4 text-warning text-center fw-bold">
            <i data-feather="edit-3" class="me-2"></i>Edit Booking
        </h4>

        <form action="../UpdateBookingServlet" method="POST">

            <input type="hidden" name="booking_id" value="<%= id %>">
            <input type="hidden" name="price" value="<%= price %>">

            <div class="mb-3">
                <label class="form-label text-light fw-bold">Customer Name</label>
                <input type="text" name="customerName" class="form-control custom-input" value="<%= customerName %>" required>
            </div>

            <div class="mb-3">
                <label class="form-label text-light fw-bold">Drama Name</label>
                <input type="text" class="form-control custom-input" value="<%= dramaName %>" readonly>
            </div>

            <div class="mb-4">
                <label class="form-label text-light fw-bold">Number of Seats</label>
                <input type="number" name="seats" class="form-control custom-input" value="<%= seats %>" min="1" max="20" required>
            </div>

            <div class="d-flex gap-2 mt-4">
                <a href="view_bookings.jsp" class="btn btn-outline-secondary w-50 fw-bold" style="border-radius: 50px;">Cancel</a>
                <button type="submit" class="btn btn-info w-50 fw-bold" style="border-radius: 50px;">Update</button>
            </div>
        </form>
    </div>
</div>

<script>feather.replace();</script>
</body>
</html>