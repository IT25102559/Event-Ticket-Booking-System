<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="event_management.Drama" %>
<%@ page import="event_management.DramaManager" %>
<%@ page import="java.util.List" %>
<%@ page import="java.net.URLEncoder" %> <%
    String role = (String) session.getAttribute("userRole");
    if (!"Admin".equals(role)) {
        response.sendRedirect("../user_ui/login.jsp?error=true");
        return;
    }

    DramaManager manager = new DramaManager();
    List<Drama> dramaList = manager.getAllDramas();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Dramas | Admin Panel</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/site.css">
    <script src="https://unpkg.com/feather-icons"></script>
    <script defer src="${pageContext.request.contextPath}/assets/js/site.js"></script>
    <style>
        body {
            min-height: 100vh;

            background: linear-gradient(rgba(26, 26, 46, 0.85), rgba(22, 33, 62, 0.95)), url('../images/Admin.png') no-repeat center center fixed;
            background-size: cover;

            display: flex;
            flex-direction: column;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: white;
            overflow-x: hidden;
        }
        ::-webkit-scrollbar { display: none; }

        .admin-card { background: rgba(255, 255, 255, 0.05); backdrop-filter: blur(20px); border: 1px solid rgba(255, 255, 255, 0.1); border-radius: 1.5rem; padding: 1.5rem; width: 100%; max-width: 95%; margin: 20px auto; box-shadow: 0 25px 45px rgba(0,0,0,0.5); animation: slideFade 0.6s ease-out; }
        @keyframes slideFade { 0% { opacity: 0; transform: translateY(30px); } 100% { opacity: 1; transform: translateY(0); } }

        .gradient-text { background: linear-gradient(135deg, #f6d365 0%, #fda085 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; font-weight: 800; }
        .glass-table { width: 100%; border-collapse: separate; border-spacing: 0 10px; }
        .glass-table th { background: rgba(255, 255, 255, 0.1); color: #f8fafc; padding: 15px; border: none; text-transform: uppercase; font-size: 0.9rem; letter-spacing: 1px; }
        .glass-table td { background: rgba(255, 255, 255, 0.05); padding: 15px; border: none; color: #e2e8f0; vertical-align: middle; transition: all 0.3s; }
        .glass-table th:first-child, .glass-table td:first-child { border-top-left-radius: 12px; border-bottom-left-radius: 12px; }
        .glass-table th:last-child, .glass-table td:last-child { border-top-right-radius: 12px; border-bottom-right-radius: 12px; }
        .glass-table tbody tr:hover td { background: rgba(255, 255, 255, 0.1); transform: scale(1.01); }

        .btn-glow-success { background: linear-gradient(135deg, #11998e, #38ef7d); color: white; border: none; border-radius: 50px; padding: 10px 20px; font-weight: bold; transition: all 0.3s ease; box-shadow: 0 8px 20px rgba(56, 239, 125, 0.4); text-decoration: none; display: inline-flex; align-items: center; }
        .btn-glow-success:hover { transform: translateY(-3px); box-shadow: 0 12px 25px rgba(56, 239, 125, 0.6); color: white; }

        .action-btn { border-radius: 8px; padding: 6px 12px; font-size: 0.9rem; font-weight: bold; transition: all 0.3s; text-decoration: none; display: inline-flex; align-items: center; gap: 5px; }
        .btn-edit { background: rgba(255, 193, 7, 0.2); color: #ffc107; border: 1px solid rgba(255, 193, 7, 0.5); }
        .btn-edit:hover { background: #ffc107; color: #000; }
        .btn-delete { background: rgba(220, 53, 69, 0.2); color: #ff6b6b; border: 1px solid rgba(220, 53, 69, 0.5); }
        .btn-delete:hover { background: #dc3545; color: #fff; }

        .drama-link { color: #00c6ff; text-decoration: none; transition: all 0.3s ease; border-bottom: 1px dashed transparent; }
        .drama-link:hover { color: #fff; text-shadow: 0 0 10px #00c6ff; border-bottom: 1px dashed #00c6ff; }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm w-100">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold text-warning" href="#"><i data-feather="settings"></i> Admin Panel</a>
        <div class="navbar-nav ms-auto align-items-center">
            <a class="nav-link" href="../event_ui/view_dramas.jsp">User View</a>
            <a class="nav-link text-white fw-bold" href="manage_dramas.jsp">Manage Dramas</a>
            <a class="nav-link" href="view_all_bookings.jsp">All Bookings</a>
            <a class="nav-link btn btn-outline-danger btn-sm ms-lg-3 px-3" href="../user_ui/login.jsp" style="border-radius: 20px;">Logout</a>
        </div>
    </div>
</nav>

<div class="container my-5 flex-grow-1 d-flex justify-content-center">
    <div class="admin-card">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h3 class="mb-0 d-flex align-items-center">
                <i data-feather="grid" class="me-3 text-warning" style="width: 32px; height: 32px;"></i>
                <span class="gradient-text">Manage Stage Dramas</span>
            </h3>

            <div>
                <!-- Promo Codes  -->
                <a href="manage_promos.jsp" class="btn btn-outline-warning me-3" style="border-radius: 50px; padding: 10px 20px; font-weight: bold; box-shadow: 0 4px 10px rgba(255, 193, 7, 0.1);">
                    <i data-feather="tag" style="margin-right: 5px;"></i> Manage Promos
                </a>

                <a href="add_drama.jsp" class="btn-glow-success">
                    <i data-feather="plus-circle" class="me-2"></i> Add New Drama
                </a>
            </div>
        </div>

        <div class="table-responsive">
            <table class="glass-table text-center mb-0">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Drama Name</th>
                        <th>Show Date</th>
                        <th>Director</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (dramaList != null && !dramaList.isEmpty()) {
                            for (Drama d : dramaList) { %>
                    <tr>
                        <td class="fw-bold" style="color: #94a3b8;"><%= d.getId() %></td>
                        <td>
                            <a href="view_all_bookings.jsp?filterDrama=<%= URLEncoder.encode(d.getName(), "UTF-8") %>" class="drama-link fw-bold" title="View Bookings for this Drama">
                                <%= d.getName() %> <i data-feather="external-link" style="width: 14px; margin-left: 5px;"></i>
                            </a>
                        </td>
                        <td style="color: #cbd5e1;"><%= d.getShowDate() %></td>
                        <td><%= d.getDirector() %></td>
                        <td>
                            <a href="edit_drama.jsp?id=<%= d.getId() %>" class="action-btn btn-edit"><i data-feather="edit-2" style="width: 14px;"></i> Edit</a>
                            <a href="../DeleteDramaServlet?id=<%= d.getId() %>" class="action-btn btn-delete" onclick="return confirm('Are you sure you want to delete this drama?');"><i data-feather="trash-2" style="width: 14px;"></i> Delete</a>
                        </td>
                    </tr>
                    <% } } else { %>
                    <tr>
                        <td colspan="5" class="text-warning fw-bold py-4">No dramas found in the database!</td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>feather.replace();</script>
</body>
</html>