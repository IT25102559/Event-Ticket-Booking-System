<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="ticket_booking.BookingManager" %>
<%@ page import="ticket_booking.Ticket" %>
<%@ page import="java.util.List" %>
<%@ page import="java.sql.*" %>
<%@ page import="user_management.DBConnection" %>
<%

    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    response.setHeader("Pragma", "no-cache");
    response.setDateHeader("Expires", 0);

    String loggedUser = (String) session.getAttribute("username");
    if (loggedUser == null) {
        response.sendRedirect("../user_ui/login.jsp?msg=login_first");
        return;
    }

    BookingManager manager = new BookingManager();
    List<Ticket> bookingList = manager.getUserBookings(loggedUser);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Bookings | EventTix</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/site.css">
    <script src="https://unpkg.com/feather-icons"></script>
    <script defer src="${pageContext.request.contextPath}/assets/js/site.js"></script>
    <style>
        body {
            background: linear-gradient(rgba(26, 26, 46, 0.5), rgba(22, 33, 62, 0.7)), url('../images/1234.jpg') no-repeat center center fixed;
            background-size: cover;
            color: white;
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            display: flex;
            flex-direction: column;
            overflow-x: hidden;
        }

        ::-webkit-scrollbar { display: none; }

        .bookings-card {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(15px);
            -webkit-backdrop-filter: blur(15px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 1.5rem;
            padding: 2.5rem;
            width: 100%;
            max-width: 1200px;
            margin: 20px auto;
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

        .glass-table {
            width: 100%;
            border-collapse: separate;
            border-spacing: 0 15px;
        }

        .glass-table th {
            background: transparent;
            color: #00c6ff;
            padding: 10px 10px;
            border: none;
            text-transform: uppercase;
            font-size: 0.85rem;
            letter-spacing: 1px;
        }

        .glass-table td {
            background: rgba(255, 255, 255, 0.08);
            padding: 18px 10px;
            border-top: 1px solid rgba(255, 255, 255, 0.15);
            border-bottom: 1px solid rgba(255, 255, 255, 0.15);
            color: #e2e8f0;
            vertical-align: middle;
            transition: all 0.3s;
            white-space: nowrap;
        }

        .glass-table td:first-child {
            border-left: 1px solid rgba(255, 255, 255, 0.15);
            border-top-left-radius: 12px;
            border-bottom-left-radius: 12px;
            padding-left: 15px;
        }

        .glass-table td:last-child {
            border-right: 1px solid rgba(255, 255, 255, 0.15);
            border-top-right-radius: 12px;
            border-bottom-right-radius: 12px;
            padding-right: 15px;
        }

        .glass-table tbody tr:hover td {
            background: rgba(255, 255, 255, 0.15);
            transform: scale(1.01);
            border-color: rgba(0, 198, 255, 0.4);
        }

        .badge-price { display: inline-block; background: rgba(0, 198, 255, 0.2); color: #00c6ff; padding: 6px 15px; border-radius: 8px; font-weight: bold; border: 1px solid rgba(0, 198, 255, 0.4); }
        .badge-seats { display: inline-block; background: rgba(255, 193, 7, 0.2); color: #ffc107; padding: 6px 15px; border-radius: 8px; font-weight: bold; border: 1px solid rgba(255, 193, 7, 0.4); }


        .status-icon-paid {
            display: inline-flex; align-items: center; justify-content: center;
            width: 38px; height: 38px; border-radius: 50%;
            background: rgba(16, 185, 129, 0.2); color: #10b981;
            border: 1px solid rgba(16, 185, 129, 0.5); box-shadow: 0 4px 10px rgba(16, 185, 129, 0.3);
            cursor: help;
        }
        .status-icon-pending {
            display: inline-flex; align-items: center; justify-content: center;
            width: 38px; height: 38px; border-radius: 50%;
            background: rgba(245, 158, 11, 0.2); color: #f59e0b;
            border: 1px solid rgba(245, 158, 11, 0.5); box-shadow: 0 4px 10px rgba(245, 158, 11, 0.3);
            cursor: help;
        }

        .btn-glow {
            background: linear-gradient(135deg, #00c6ff, #0072ff);
            color: white;
            border: none;
            border-radius: 50px;
            padding: 12px 30px;
            font-size: 1.1rem;
            font-weight: bold;
            transition: all 0.3s ease;
            box-shadow: 0 8px 20px rgba(0, 114, 255, 0.4);
            text-decoration: none;
            display: inline-block;
        }

        .btn-glow:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 25px rgba(0, 114, 255, 0.6);
            color: white;
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm w-100">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold" href="../event_ui/view_dramas.jsp"><i data-feather="film"></i> EventTix</a>
        <div class="navbar-nav ms-auto align-items-center">
            <a class="nav-link" href="../event_ui/view_dramas.jsp">Home</a>
            <a class="nav-link" href="book_ticket.jsp">Book Tickets</a>
            <a class="nav-link text-warning fw-bold" href="view_bookings.jsp">My Bookings</a>
            <a class="nav-link" href="../payment_ui/payment_form.jsp">Make Payment</a>

            <% String userRole = (String) session.getAttribute("userRole");
               if ("Admin".equals(userRole)) { %>
                <a class="nav-link text-info fw-bold ms-lg-3" href="../admin_ui/manage_dramas.jsp">
                    <i data-feather="settings" style="width: 16px; margin-bottom: 2px;"></i> Admin Panel
                </a>
            <% } %>

            <a class="nav-link btn btn-outline-danger btn-sm ms-lg-3 px-3" href="../user_ui/login.jsp" style="border-radius: 20px;">Logout</a>
        </div>
    </div>
</nav>

<div class="container my-5 flex-grow-1 d-flex justify-content-center">
    <div class="bookings-card">
        <h3 class="text-center mb-4">
            <i data-feather="list" class="me-2 text-info" style="width: 28px; height: 28px;"></i>
            <span class="gradient-text">My Ticket Bookings</span>
        </h3>

        <!-- Success/Error Messages -->
        <div class="d-flex justify-content-center mb-3">
            <% if("deleted".equals(request.getParameter("msg"))) { %>
                <div class="alert alert-success text-center py-2 w-100" style="max-width: 450px; border-radius: 10px; background: rgba(40, 167, 69, 0.2); color: #4ade80; border: 1px solid rgba(40, 167, 69, 0.3); margin-bottom: 0;">
                    Ticket deleted successfully!
                </div>
            <% } else if("delete_failed".equals(request.getParameter("error"))) { %>
                <div class="alert alert-danger text-center py-2 w-100" style="max-width: 450px; border-radius: 10px; background: rgba(220, 53, 69, 0.2); color: #ff6b6b; border: 1px solid rgba(220, 53, 69, 0.3); margin-bottom: 0;">
                    Failed to delete the ticket. Please try again.
                </div>
            <% } else if("updated".equals(request.getParameter("msg"))) { %>
                <div class="alert alert-success text-center py-2 w-100" style="max-width: 450px; border-radius: 10px; background: rgba(40, 167, 69, 0.2); color: #4ade80; border: 1px solid rgba(40, 167, 69, 0.3); margin-bottom: 0;">
                    Booking updated successfully!
                </div>
            <% } %>
        </div>

        <div class="table-responsive">
            <table class="glass-table text-center mb-0">
                <thead>
                    <tr>
                        <th>Booking ID</th>
                        <th>Customer Name</th>
                        <th>Drama Name</th>
                        <th>Category Price</th>
                        <th>Seats</th>
                        <th>Total Amount</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (bookingList != null && !bookingList.isEmpty()) {
                           for (Ticket ticket : bookingList) {

                               // Payment    
                               boolean isPaid = false;
                               try (Connection con = DBConnection.getConnection();
                                    PreparedStatement pst = con.prepareStatement("SELECT id FROM payments WHERE booking_id = ?")) {
                                   pst.setString(1, ticket.getBookingId());
                                   ResultSet rs = pst.executeQuery();
                                   if (rs.next()) {
                                       isPaid = true;
                                   }
                               } catch (Exception e) {
                                   e.printStackTrace();
                               }
                    %>
                        <tr>
                            <td class="fw-bold" style="color: #94a3b8;"><%= ticket.getBookingId() %></td>
                            <td class="fw-bold"><%= ticket.getCustomerName() %></td>
                            <td style="color: #cbd5e1;"><%= ticket.getDramaName() %></td>

                            <td><span class="badge-price">Rs. <%= ticket.getPrice() %></span></td>
                            <td><span class="badge-seats"><%= ticket.getSeats() %></span></td>

                            <td class="fw-bold" style="color: #4ade80; font-size: 1.1rem;">Rs. <%= ticket.getSeats() * ticket.getPrice() %></td>

                            <!-- 👇    Status  👇 -->
                            <td>
                                <% if(isPaid) { %>
                                    <span class="status-icon-paid" title="Paid">
                                        <i data-feather="check" style="width: 20px; height: 20px;"></i>
                                    </span>
                                <% } else { %>
                                    <span class="status-icon-pending" title="Pending">
                                        <i data-feather="clock" style="width: 20px; height: 20px;"></i>
                                    </span>
                                <% } %>
                            </td>

                            <!-- Action  -->
                            <td>
                                <div class="d-flex justify-content-center gap-2">
                                    <a href="edit_booking.jsp?id=<%= ticket.getBookingId() %>"
                                       class="btn btn-warning"
                                       style="width: 38px; height: 38px; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; padding: 0; box-shadow: 0 4px 10px rgba(255, 193, 7, 0.4); color: #1a1a2e; transition: all 0.3s;"
                                       title="Edit Booking"
                                       onmouseover="this.style.transform='scale(1.1)'"
                                       onmouseout="this.style.transform='scale(1)'">
                                       <i data-feather="edit-2" style="width: 16px; height: 16px;"></i>
                                    </a>

                                    <a href="../DeleteBookingServlet?id=<%= ticket.getBookingId() %>"
                                       class="btn btn-danger"
                                       style="width: 38px; height: 38px; border-radius: 50%; display: inline-flex; align-items: center; justify-content: center; padding: 0; box-shadow: 0 4px 10px rgba(220, 53, 69, 0.4); transition: all 0.3s;"
                                       onclick="return confirm('Are you sure you want to delete this ticket?');"
                                       title="Delete Booking"
                                       onmouseover="this.style.transform='scale(1.1)'"
                                       onmouseout="this.style.transform='scale(1)'">
                                       <i data-feather="trash-2" style="width: 16px; height: 16px;"></i>
                                    </a>
                                </div>
                            </td>
                        </tr>
                    <%   }
                       } else { %>
                        <tr>
                            <td colspan="8" class="text-warning fw-bold py-4">No bookings found! Book a ticket to see it here.</td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>

        <div class="text-center mt-5">
            <a href="book_ticket.jsp" class="btn-glow">
                <i data-feather="plus-circle" class="me-2"></i> Book Another Ticket
            </a>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    feather.replace();
</script>
</body>
</html>