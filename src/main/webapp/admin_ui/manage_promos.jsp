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
    <title>Manage Promos | Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/site.css">
    <script src="https://unpkg.com/feather-icons"></script>
    <script defer src="${pageContext.request.contextPath}/assets/js/site.js"></script>
    <style>
        body { background: linear-gradient(135deg, #1a1a2e, #16213e); color: white; min-height: 100vh; font-family: 'Segoe UI', sans-serif;}
        .card-custom { background-color: #242a45; border-radius: 10px; padding: 20px; border: 1px solid #3a4161; }
        .custom-input { background-color: #1a1e36; color: white; border: 1px solid #3a4161; }
        .custom-input:focus { background-color: #1a1e36; color: white; border-color: #00c6ff; box-shadow: none;}
        .table-custom { color: white; margin-top: 15px;}
        .table-custom th { background-color: #1a1e36; border-color: #3a4161; color: #00c6ff;}
        .table-custom td { background-color: #242a45; border-color: #3a4161; color: white; vertical-align: middle;}
    </style>
</head>
<body>
<div class="container mt-5">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2 class="text-info fw-bold">🎫 Manage Promo Codes</h2>
        <a href="manage_dramas.jsp" class="btn btn-outline-light">Back to Dashboard</a>
    </div>

    <div class="row">
    
        <div class="col-md-4 mb-4">
            <div class="card-custom">
                <h4 class="mb-3 text-warning">Create New Promo</h4>

                <% if("success".equals(request.getParameter("msg"))) { %>
                    <div class="alert alert-success py-2">Promo Code Successfully Added!</div>
                <% } else if("db_error".equals(request.getParameter("error"))) { %>
                    <div class="alert alert-danger py-2">Error! Code might already exist.</div>
                <% } %>

                <form action="../PromoServlet" method="POST">
                    <div class="mb-3">
                        <label>Promo Code Name</label>
                        <input type="text" name="code" class="form-control custom-input" placeholder="e.g. AWRUDU20" required>
                    </div>
                    <div class="mb-4">
                        <label>Discount Percentage (%)</label>
                        <input type="number" name="discount" class="form-control custom-input" placeholder="15" min="1" max="100" required>
                    </div>
                    <button type="submit" class="btn btn-info w-100 fw-bold">Add Promo Code</button>
                </form>
            </div>
        </div>


        <div class="col-md-8">
            <div class="card-custom">
                <h4 class="mb-3 text-warning">Active Promo Codes</h4>


                <% if("updated".equals(request.getParameter("msg"))) { %>
                    <div class="alert alert-success py-2 text-center" style="border-radius: 8px;">Promo Code Updated Successfully!</div>
                <% } else if("promo_deleted".equals(request.getParameter("msg"))) { %>
                    <div class="alert alert-success py-2 text-center" style="border-radius: 8px; background: rgba(40, 167, 69, 0.2); color: #4ade80; border: 1px solid rgba(40, 167, 69, 0.3);">Promo Code Deleted Successfully!</div>
                <% } else if("update_failed".equals(request.getParameter("error")) || "delete_failed".equals(request.getParameter("error"))) { %>
                    <div class="alert alert-danger py-2 text-center" style="border-radius: 8px;">Failed to process request!</div>
                <% } %>
                

                <table class="table table-custom text-center">
                    <thead>
                        <tr>
                            <th>Promo Code</th>
                            <th>Discount (%)</th>
                            <th>Status</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <%
                            try (Connection con = DBConnection.getConnection()) {
                                String query = "SELECT * FROM promo_codes ORDER BY id DESC";
                                PreparedStatement pst = con.prepareStatement(query);
                                ResultSet rs = pst.executeQuery();

                                boolean hasCodes = false;
                                while(rs.next()) {
                                    hasCodes = true;
                                    String status = rs.getString("status");
                        %>
                                <tr>
                                    <td class="fw-bold text-warning h5"><%= rs.getString("code") %></td>
                                    <td class="h5"><%= rs.getInt("discount_percentage") %>%</td>
                                    <td>
                                        <% if("Active".equals(status)) { %>
                                            <span class="badge bg-success px-3 py-2">Active</span>
                                        <% } else { %>
                                            <span class="badge bg-secondary px-3 py-2">Inactive</span>
                                        <% } %>
                                    </td>

                                    
                                    <td class="d-flex justify-content-center gap-2">
                                        <a href="edit_promo.jsp?code=<%= rs.getString("code") %>"
                                           class="btn btn-outline-warning btn-sm fw-bold"
                                           style="border-radius: 20px;">
                                            <i data-feather="edit-2" style="width: 14px; margin-bottom: 2px;"></i> Edit
                                        </a>

                                        <a href="../DeletePromoServlet?code=<%= rs.getString("code") %>"
                                           class="btn btn-danger btn-sm fw-bold d-inline-flex align-items-center justify-content-center gap-1"
                                           style="border-radius: 20px; box-shadow: 0 4px 10px rgba(220, 53, 69, 0.3);"
                                           onclick="return confirm('Are you sure you want to delete this Promo Code?');">
                                            <i data-feather="trash-2" style="width: 14px; height: 14px;"></i> Delete
                                        </a>
                                    </td>
                                    
                                </tr>
                        <%
                                }
                                if(!hasCodes) {
                                    out.print("<tr><td colspan='4' class='text-muted py-3'>No promo codes available.</td></tr>");
                                }
                            } catch(Exception e) {
                                out.print("<tr><td colspan='4' class='text-danger'>Error loading codes.</td></tr>");
                            }
                        %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    feather.replace();
</script>
</body>
</html>