<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="user_management.DBConnection" %>
<%
    // 1. Security Check:    
    String loggedUser = (String) session.getAttribute("username");
    if (loggedUser == null) {
        response.sendRedirect("login.jsp?error=login_first");
        return;
    }

    String firstName = "";
    String lastName = "";
    String phone = "";

    // 🌟 CRUD - Read (R) : Database    🌟
    try (Connection con = DBConnection.getConnection()) {
        String query = "SELECT first_name, last_name, phone FROM users WHERE email = ?";
        PreparedStatement pst = con.prepareStatement(query);
        pst.setString(1, loggedUser);
        ResultSet rs = pst.executeQuery();

        if (rs.next()) {
            firstName = rs.getString("first_name") != null ? rs.getString("first_name") : "";
            lastName = rs.getString("last_name") != null ? rs.getString("last_name") : "";
            phone = rs.getString("phone") != null ? rs.getString("phone") : "";
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>My Profile | EventTix</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/site.css">
    <script src="https://unpkg.com/feather-icons"></script>
    <script defer src="${pageContext.request.contextPath}/assets/js/site.js"></script>
    <style>
        body {
            background: linear-gradient(rgba(26, 26, 46, 0.8), rgba(22, 33, 62, 0.9)), url('../images/stage_bg.jpg') no-repeat center center fixed;
            background-size: cover; min-height: 100vh; font-family: 'Segoe UI', sans-serif; color: white; display: flex; flex-direction: column;
        }

        .glass-card {
            background: rgba(255, 255, 255, 0.05); backdrop-filter: blur(20px); -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.1); border-radius: 1.5rem; padding: 2.5rem; box-shadow: 0 25px 45px rgba(0,0,0,0.5);
        }

        .profile-avatar {
            width: 100px; height: 100px; background: linear-gradient(135deg, #00c6ff, #0072ff); border-radius: 50%;
            display: flex; align-items: center; justify-content: center; font-size: 3rem; font-weight: bold; margin: 0 auto 20px auto; box-shadow: 0 10px 20px rgba(0, 198, 255, 0.3);
            text-transform: uppercase;
        }

        .info-box {
            background: rgba(255, 255, 255, 0.08); border: 1px solid rgba(255, 255, 255, 0.1); border-radius: 1rem;
            padding: 15px 20px; margin-bottom: 15px; display: flex; align-items: center;
        }

        .info-icon { color: #00c6ff; margin-right: 15px; }

        /* Modal Custom CSS */
        .custom-input { background: rgba(255,255,255,0.05) !important; color: white !important; border: 1px solid rgba(255,255,255,0.2) !important; }
        .custom-input:focus { border-color: #00c6ff !important; box-shadow: 0 0 10px rgba(0,198,255,0.3) !important; }
        .custom-input::placeholder { color: rgba(255,255,255,0.4) !important; }

        .custom-toast { position: fixed; top: 30px; left: 50%; transform: translateX(-50%); background: rgba(15, 23, 42, 0.9); backdrop-filter: blur(15px); padding: 15px 25px; border-radius: 12px; z-index: 9999; display: flex; align-items: center; gap: 15px; animation: slideDown 0.5s forwards; }
        @keyframes slideDown { 0% { top: -100px; opacity: 0; } 100% { top: 30px; opacity: 1; } }
        @keyframes slideUp { 0% { top: 30px; opacity: 1; } 100% { top: -100px; opacity: 0; } }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm w-100">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold" href="../event_ui/view_dramas.jsp"><i data-feather="film"></i> EventTix</a>
        <div class="navbar-nav ms-auto align-items-center">
            <a class="nav-link" href="../event_ui/view_dramas.jsp">Home</a>
            <a class="nav-link" href="../booking_ui/book_ticket.jsp">Book Tickets</a>
            <a class="nav-link text-info fw-bold" href="profile.jsp"><i data-feather="user" style="width: 18px; margin-bottom: 2px;"></i> My Profile</a>
            <a class="nav-link btn btn-outline-danger btn-sm ms-lg-3 px-3" href="logout.jsp" style="border-radius: 20px;">Logout</a>
        </div>
    </div>
</nav>


<% if ("updated".equals(request.getParameter("msg"))) { %>
    <div class="custom-toast" id="successToast" style="border: 1px solid rgba(16, 185, 129, 0.5);">
        <div style="background: rgba(16,185,129,0.2); color:#10b981; padding:10px; border-radius:50%;"><i data-feather="check-circle"></i></div>
        <div><strong style="color: #10b981;">Profile Updated!</strong><span class="d-block text-light" style="font-size: 0.9rem;">Your personal details have been saved.</span></div>
    </div>
    <script>setTimeout(() => { let t = document.getElementById('successToast'); if(t) t.style.animation = 'slideUp 0.5s forwards'; }, 4000);</script>
<% } %>

<div class="container my-5 d-flex justify-content-center flex-grow-1 align-items-center">
    <div class="glass-card" style="max-width: 500px; width: 100%;">

        <!--     -->
        <div class="profile-avatar">
            <%= (firstName != null && !firstName.isEmpty()) ? firstName.substring(0, 1) : "U" %>
        </div>

        <h3 class="text-center mb-4 fw-bold text-white">
            <%= (firstName.isEmpty() && lastName.isEmpty()) ? "Welcome User!" : firstName + " " + lastName %>
        </h3>

        <div class="info-box">
            <div class="info-icon"><i data-feather="mail"></i></div>
            <div>
                <div style="font-size: 0.8rem; color: rgba(255,255,255,0.6);">Email Address</div>
                <div class="fw-bold"><%= loggedUser %></div>
            </div>
        </div>

        <div class="info-box">
            <div class="info-icon"><i data-feather="phone"></i></div>
            <div>
                <div style="font-size: 0.8rem; color: rgba(255,255,255,0.6);">Phone Number</div>
                <div class="fw-bold"><%= (phone != null && !phone.isEmpty()) ? phone : "Not Provided" %></div>
            </div>
        </div>

        <div class="d-flex justify-content-between mt-4">
            <a href="../event_ui/view_dramas.jsp" class="btn btn-outline-light" style="border-radius: 20px; padding: 8px 25px;">
                <i data-feather="arrow-left" style="width: 18px; margin-bottom: 2px;"></i> Back
            </a>
            <!-- 🌟 Edit Profile  🌟 -->
            <button type="button" class="btn btn-info fw-bold" data-bs-toggle="modal" data-bs-target="#editProfileModal" style="border-radius: 20px; padding: 8px 25px;">
                <i data-feather="edit-2" style="width: 18px; margin-bottom: 2px;"></i> Edit Profile
            </button>
        </div>

    </div>
</div>


<div class="modal fade" id="editProfileModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="background: #1e293b; color: white; border: 1px solid rgba(255,255,255,0.1); border-radius: 1.2rem;">
            <div class="modal-header border-0 pb-0">
                <h5 class="modal-title fw-bold text-info"><i data-feather="edit" class="me-2"></i>Edit Personal Details</h5>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"></button>
            </div>


            <form action="../UpdateProfileServlet" method="POST">
                <div class="modal-body pt-4">

                    <div class="row mb-3">
                        <div class="col-6">
                            <label class="form-label text-light small">First Name</label>
                            <input type="text" name="firstName" class="form-control custom-input" value="<%= firstName %>" required>
                        </div>
                        <div class="col-6">
                            <label class="form-label text-light small">Last Name</label>
                            <input type="text" name="lastName" class="form-control custom-input" value="<%= lastName %>" required>
                        </div>
                    </div>

                    <div class="mb-3">
                        <label class="form-label text-light small">Phone Number</label>
                        <input type="text" name="phone" class="form-control custom-input" value="<%= phone %>" maxlength="10" pattern="[0-9]{10}" oninput="this.value = this.value.replace(/[^0-9]/g, '')" required>
                    </div>

                    <div class="mb-3">
                        <label class="form-label text-light small">Email Address</label>
                        <input type="email" name="email" class="form-control custom-input" value="<%= loggedUser %>" required>
                    </div>

                    <div class="mb-2">
                        <label class="form-label text-light small">New Password</label>
                        <input type="password" name="password" class="form-control custom-input" placeholder="Leave blank to keep current password">
                        <small class="text-muted" style="font-size: 0.75rem;">Only fill this if you want to change your password.</small>
                    </div>

                </div>
                <div class="modal-footer border-0 pt-0">
                    <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal" style="border-radius: 20px;">Cancel</button>
                    <button type="submit" class="btn btn-info fw-bold" style="border-radius: 20px;">Save Changes</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>feather.replace();</script>
</body>
</html>