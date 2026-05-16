<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="user_management.DBConnection" %>
<%
    // Security Check
    String loggedUser = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("userRole");

    if (loggedUser == null) {
        response.sendRedirect("../user_ui/login.jsp?error=login_first");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Drama Reviews | EventTix</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/site.css">
    <script src="https://unpkg.com/feather-icons"></script>
    <script defer src="${pageContext.request.contextPath}/assets/js/site.js"></script>
    <style>
        body {
            background: linear-gradient(rgba(26, 26, 46, 0.8), rgba(22, 33, 62, 0.9)), url('../images/stage_bg.jpg') no-repeat center center fixed;
            background-size: cover;
            color: white;
            min-height: 100vh;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        /* ලස්සන Glassmorphism Card එක */
        .glass-card {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 1.5rem;
            padding: 2rem;
            margin-bottom: 20px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.4);
        }

        .custom-input {
            background: rgba(255, 255, 255, 0.08) !important;
            color: white !important;
            border: 1px solid rgba(255, 255, 255, 0.2) !important;
            border-radius: 0.8rem;
            padding: 10px 15px;
        }

        .custom-input:focus {
            background: rgba(255, 255, 255, 0.12) !important;
            border-color: #00c6ff !important;
            box-shadow: 0 0 15px rgba(0, 198, 255, 0.4) !important;
        }

        .custom-input option { background: #1a1a2e; color: white; }
        .custom-input::placeholder { color: rgba(255, 255, 255, 0.5) !important; }

        .star-rating { color: #ffd700; font-size: 1.2rem; letter-spacing: 2px; }

        .btn-glow {
            background: linear-gradient(135deg, #00c6ff, #0072ff);
            color: white;
            border: none;
            border-radius: 50px;
            padding: 12px;
            font-size: 1.1rem;
            font-weight: bold;
            transition: all 0.3s ease;
            box-shadow: 0 8px 20px rgba(0, 114, 255, 0.4);
        }

        .btn-glow:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 25px rgba(0, 114, 255, 0.6);
            color: white;
        }

        .input-label { color: #e2e8f0; font-weight: 600; margin-bottom: 8px; font-size: 0.9rem;}
    </style>
</head>
<body>

<!-- Navigation Bar -->
<nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm w-100 mb-4">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold" href="../event_ui/view_dramas.jsp"><i data-feather="film"></i> EventTix</a>
        <div class="navbar-nav ms-auto align-items-center">
            <a class="nav-link" href="../event_ui/view_dramas.jsp">Home</a>
            <a class="nav-link" href="../booking_ui/book_ticket.jsp">Book Tickets</a>
            <a class="nav-link text-info fw-bold" href="#">Reviews</a>
            <a class="nav-link btn btn-outline-danger btn-sm ms-lg-3 px-3" href="../user_ui/logout.jsp" style="border-radius: 20px;">Logout</a>
        </div>
    </div>
</nav>

<div class="container">
    <div class="row">
        <!-- Review එක දාන ෆෝම් එක -->
        <div class="col-md-5 mb-4">
            <div class="glass-card">
                <h3 class="mb-4 text-center">
                    <i data-feather="star" class="text-warning me-2" style="width: 28px; height: 28px;"></i>
                    <span style="background: linear-gradient(135deg, #00c6ff, #0072ff); -webkit-background-clip: text; -webkit-text-fill-color: transparent; font-weight: 800;">Add a Review</span>
                </h3>

                <!-- Success/Error මැසේජ් -->
                <% if("success".equals(request.getParameter("msg"))) { %>
                    <div class="alert alert-success py-2 border-0" style="background: rgba(16, 185, 129, 0.2); color: #10b981;"><i data-feather="check-circle" class="me-2" style="width: 16px;"></i>Thank you for your feedback!</div>
                <% } else if("updated".equals(request.getParameter("msg"))) { %>
                    <div class="alert alert-info py-2 border-0" style="background: rgba(0, 198, 255, 0.2); color: #00c6ff;"><i data-feather="check-circle" class="me-2" style="width: 16px;"></i>Review Updated Successfully!</div>
                <% } else if("deleted".equals(request.getParameter("msg"))) { %>
                    <div class="alert alert-warning py-2 border-0" style="background: rgba(245, 158, 11, 0.2); color: #f59e0b;"><i data-feather="trash-2" class="me-2" style="width: 16px;"></i>Review Deleted Successfully!</div>
                <% } else if("access_denied".equals(request.getParameter("error"))) { %>
                    <div class="alert alert-danger py-2 border-0" style="background: rgba(239, 68, 68, 0.2); color: #ef4444;"><i data-feather="alert-circle" class="me-2" style="width: 16px;"></i>You can only edit your own reviews!</div>
                <% } %>

                <form action="../ReviewServlet" method="POST">
                    <div class="mb-3">
                        <label class="form-label input-label"><i data-feather="film" class="me-2 text-info" style="width: 16px;"></i> Drama Name</label>
                        <input type="text" name="drama_name" class="form-control custom-input" placeholder="E.g: Mama Newe Wena Kenek" required>
                    </div>
                    <div class="mb-3">
                        <label class="form-label input-label"><i data-feather="award" class="me-2 text-info" style="width: 16px;"></i> Rating</label>
                        <select name="rating" class="form-select custom-input">
                            <option value="5">⭐⭐⭐⭐⭐ - Excellent</option>
                            <option value="4">⭐⭐⭐⭐ - Good</option>
                            <option value="3">⭐⭐⭐ - Average</option>
                            <option value="2">⭐⭐ - Poor</option>
                            <option value="1">⭐ - Very Poor</option>
                        </select>
                    </div>
                    <div class="mb-4">
                        <label class="form-label input-label"><i data-feather="message-square" class="me-2 text-info" style="width: 16px;"></i> Your Comment</label>
                        <textarea name="comment" rows="3" class="form-control custom-input" placeholder="Share your experience..." required></textarea>
                    </div>
                    <button type="submit" class="btn btn-glow w-100"><i data-feather="send" class="me-2" style="width: 18px;"></i> Submit Review</button>
                </form>
            </div>
        </div>

        <!-- දාලා තියෙන Reviews බලන තැන -->
        <div class="col-md-7">
            <h3 class="mb-4 fw-bold" style="color: #e2e8f0;">Recent Community Reviews</h3>
            <%
                try (Connection con = DBConnection.getConnection()) {
                    // 🌟 👇 මෙන්න මෙතන තමයි වෙනස් කළේ (u.username වෙනුවට u.email දැම්මා) 👇 🌟
                    String query = "SELECT r.*, u.first_name, u.last_name FROM reviews r LEFT JOIN users u ON r.user_email = u.email ORDER BY r.review_date DESC";
                    PreparedStatement pst = con.prepareStatement(query);
                    ResultSet rs = pst.executeQuery();

                    boolean hasReviews = false;
                    while(rs.next()) {
                        hasReviews = true;
                        int stars = rs.getInt("rating");
                        String reviewId = rs.getString("id");
                        String reviewOwner = rs.getString("user_email");

                        // First Name එකයි Last Name එකයි ගන්නවා (නැත්නම් Email එක පෙන්වනවා)
                        String fName = rs.getString("first_name");
                        String lName = rs.getString("last_name");
                        String displayName = (fName != null && lName != null) ? (fName + " " + lName) : reviewOwner;

                        boolean canManage = "Admin".equals(role) || loggedUser.equals(reviewOwner);
            %>
                        <div class="glass-card" style="padding: 1.5rem;">
                            <div class="d-flex justify-content-between align-items-start">
                                <div>
                                    <h5 class="text-info fw-bold mb-1"><i data-feather="film" class="me-2" style="width: 16px;"></i><%= rs.getString("drama_name") %></h5>
                                    <div class="star-rating mb-3">
                                        <% for(int i=0; i<stars; i++) { out.print("★"); } %>
                                        <% for(int i=stars; i<5; i++) { out.print("<span style='color: rgba(255,255,255,0.2);'>★</span>"); } %>
                                    </div>
                                </div>
                                <span class="badge" style="background: rgba(255,255,255,0.1); border: 1px solid rgba(255,255,255,0.2);"><%= rs.getDate("review_date") %></span>
                            </div>

                            <p class="mb-3" style="font-size: 1.05rem; color: #e2e8f0; line-height: 1.6;"><%= rs.getString("comment") %></p>

                            <div class="d-flex justify-content-between align-items-center border-top pt-3" style="border-color: rgba(255,255,255,0.1) !important;">
                                <div class="d-flex align-items-center">
                                    <div class="bg-primary rounded-circle d-flex justify-content-center align-items-center fw-bold me-2" style="width: 35px; height: 35px; color: white;">
                                        <%= displayName.substring(0, 1).toUpperCase() %>
                                    </div>
                                    <small class="text-light fw-bold"><%= displayName %></small>
                                </div>

                                <!-- Action බොත්තම් -->
                                <% if(canManage) { %>
                                    <div class="d-flex gap-2">
                                        <a href="edit_review.jsp?id=<%= reviewId %>" class="btn btn-outline-warning btn-sm" style="border-radius: 20px; padding: 5px 15px;">
                                            <i data-feather="edit-2" style="width: 14px; margin-bottom: 2px;"></i> Edit
                                        </a>
                                        <a href="../DeleteReviewServlet?id=<%= reviewId %>" class="btn btn-outline-danger btn-sm" style="border-radius: 20px; padding: 5px 15px;" onclick="return confirm('Are you sure you want to delete this review?');">
                                            <i data-feather="trash-2" style="width: 14px; margin-bottom: 2px;"></i> Delete
                                        </a>
                                    </div>
                                <% } %>
                            </div>
                        </div>
            <%
                    }
                    if(!hasReviews) {
                        out.print("<div class='glass-card text-center text-muted py-5'><i data-feather='message-circle' style='width: 48px; height: 48px; margin-bottom: 10px; opacity: 0.5;'></i><br>No reviews yet. Be the first to share your experience!</div>");
                    }
                } catch(Exception e) {
                    out.print("<div class='alert alert-danger'>Error loading reviews.</div>");
                    e.printStackTrace();
                }
            %>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>feather.replace();</script>
</body>
</html>