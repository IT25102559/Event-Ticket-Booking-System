<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="user_management.DBConnection" %>
<%

    String role = (String) session.getAttribute("userRole");
    if (!"Admin".equals(role)) {
        response.sendRedirect("../user_ui/login.jsp?error=access_denied");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>All Bookings | Admin Panel</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/site.css">
    <script src="https://unpkg.com/feather-icons"></script>
    <script defer src="${pageContext.request.contextPath}/assets/js/site.js"></script>
    <style>
        body {
            min-height: 100vh;
        
            background: linear-gradient(rgba(26, 26, 46, 0.5), rgba(22, 33, 62, 0.7)), url('../images/Admin.png') no-repeat center center fixed;
            background-size: cover;

            display: flex;
            flex-direction: column;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: white;
            overflow-x: hidden;
        }

        ::-webkit-scrollbar { display: none; }

        .admin-card {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 1.5rem;
            padding: 2.5rem;
            width: 100%;
            max-width: 1200px;
            margin: 30px auto;
            box-shadow: 0 25px 45px rgba(0,0,0,0.5);
            animation: slideFade 0.6s ease-out;
        }

        @keyframes slideFade { 0% { opacity: 0; transform: translateY(30px); } 100% { opacity: 1; transform: translateY(0); } }

        .glass-table { width: 100%; border-collapse: separate; border-spacing: 0 10px; }

        .glass-table th {
            background: transparent;
            color: #00c6ff;
            padding: 15px;
            border: none;
            text-transform: uppercase;
            font-size: 0.85rem;
            letter-spacing: 1px;
        }

        .glass-table td {
            background: rgba(255, 255, 255, 0.07);
            padding: 18px 15px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            border-bottom: 1px solid rgba(255, 255, 255, 0.1);
            color: #e2e8f0;
            vertical-align: middle;
            transition: all 0.3s;
        }

        .glass-table td:first-child { border-left: 1px solid rgba(255, 255, 255, 0.1); border-top-left-radius: 12px; border-bottom-left-radius: 12px; }
        .glass-table td:last-child { border-right: 1px solid rgba(255, 255, 255, 0.1); border-top-right-radius: 12px; border-bottom-right-radius: 12px; }

        .glass-table tbody tr:hover td { background: rgba(255, 255, 255, 0.12); transform: scale(1.01); border-color: rgba(0, 198, 255, 0.4); }

        
        .status-paid { display: inline-flex; align-items: center; gap: 5px; background: rgba(16, 185, 129, 0.2); color: #10b981; padding: 6px 14px; border-radius: 50px; font-weight: bold; font-size: 0.8rem; border: 1px solid rgba(16, 185, 129, 0.4); }
        .status-pending { display: inline-flex; align-items: center; gap: 5px; background: rgba(245, 158, 11, 0.2); color: #f59e0b; padding: 6px 14px; border-radius: 50px; font-weight: bold; font-size: 0.8rem; border: 1px solid rgba(245, 158, 11, 0.4); }

        .btn-delete { background: rgba(239, 68, 68, 0.1); color: #ef4444; border: 1px solid rgba(239, 68, 68, 0.4); border-radius: 50px; padding: 6px 15px; font-size: 0.85rem; font-weight: bold; transition: all 0.3s; text-decoration: none; }
        .btn-delete:hover { background: #ef4444; color: white; transform: translateY(-2px); }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm w-100">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold text-warning" href="#"><i data-feather="settings"></i> Admin Panel</a>
        <div class="navbar-nav ms-auto align-items-center">
            <a class="nav-link" href="../event_ui/view_dramas.jsp">User View</a>
            <a class="nav-link" href="manage_dramas.jsp">Manage Dramas</a>
            <a class="nav-link text-white fw-bold" href="view_all_bookings.jsp">All Bookings</a>
            <a class="nav-link btn btn-outline-danger btn-sm ms-lg-3 px-3" href="../user_ui/login.jsp" style="border-radius: 20px;">Logout</a>
        </div>
    </div>
</nav>

<div class="container flex-grow-1 d-flex justify-content-center">
    <div class="admin-card">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="mb-0 text-info fw-bold"><i data-feather="users" class="me-2" style="width: 28px; height: 28px;"></i> System Bookings & Payments</h3>
        </div>

        <% if("deleted".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-success text-center py-2 border-0" style="background: rgba(16, 185, 129, 0.2); color: #10b981; border-radius: 10px;">Booking deleted successfully!</div>
        <% } %>

        <div class="table-responsive">
            <table class="glass-table text-center mb-0">
                <thead>
                    <tr>
                        <th>Booking ID</th>
                        <th>Customer Name</th>
                        <th>Drama Name</th>
                        <th>Total Amount</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        try (Connection con = DBConnection.getConnection()) {
                            String query = "SELECT * FROM bookings ORDER BY id DESC";
                            PreparedStatement pst = con.prepareStatement(query);
                            ResultSet rs = pst.executeQuery();

                            boolean hasData = false;
                            while(rs.next()) {
                                hasData = true;
                                String pStatus = rs.getString("payment_status");
                                if(pStatus == null) pStatus = "Pending";
                    %>
                        <tr>
                            <td class="fw-bold text-warning"><%= rs.getString("booking_id") %></td>
                            <td class="fw-bold text-white"><%= rs.getString("customer_name") %></td>
                            <td style="color: #cbd5e1;"><%= rs.getString("drama_name") %></td>
                            <td class="fw-bold" style="color: #4ade80;">Rs. <%= rs.getDouble("total_amount") %></td>
                            <td>
                                <% if("Paid".equals(pStatus)) { %>
                                    <span class="status-paid"><i data-feather="check-circle" style="width: 14px;"></i> Paid</span>
                                <% } else { %>
                                    <span class="status-pending"><i data-feather="clock" style="width: 14px;"></i> Pending</span>
                                <% } %>
                            </td>
                            <td>
                                <a href="../DeleteBookingServlet?id=<%= rs.getString("booking_id") %>&fromAdmin=true"
                                   class="btn-delete"
                                   onclick="return confirm('Are you sure you want to delete this booking?');">
                                    <i data-feather="trash-2" style="width: 14px; margin-bottom: 2px;"></i> Delete
                                </a>
                            </td>
                        </tr>
                    <%
                            }
                            if(!hasData) {
                    %>
                            <tr><td colspan="6" class="text-warning py-5 fw-bold">No bookings found in the database.</td></tr>
                    <%
                            }
                        } catch(Exception e) {
                            out.println("<tr><td colspan='6' class='text-danger py-5 fw-bold'>Error loading database data.</td></tr>");
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>feather.replace();</script>
</body>
</html>