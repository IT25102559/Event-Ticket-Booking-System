<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="user_management.DBConnection" %>
<%
    String role = (String) session.getAttribute("userRole");
    if (!"Admin".equals(role)) {
        response.sendRedirect("../user_ui/login.jsp?error=access_denied");
        return;
    }

    String code = request.getParameter("code");
    int discount = 0;
    String status = "";

    if (code != null) {
        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement pst = con.prepareStatement("SELECT discount_percentage, status FROM promo_codes WHERE code=?");
            pst.setString(1, code);
            ResultSet rs = pst.executeQuery();
            if(rs.next()){
                discount = rs.getInt("discount_percentage");
                status = rs.getString("status");
            }
        } catch(Exception e) { e.printStackTrace(); }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Promo Code | Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/site.css">
    <script src="https://unpkg.com/feather-icons"></script>
    <script defer src="${pageContext.request.contextPath}/assets/js/site.js"></script>
    <style>
        body { min-height: 100vh; background: linear-gradient(135deg, #1a1a2e, #16213e); color: white; font-family: 'Segoe UI', sans-serif; display: flex; align-items: center; justify-content: center;}
        .admin-card { background: rgba(255, 255, 255, 0.05); backdrop-filter: blur(20px); border: 1px solid rgba(255, 255, 255, 0.1); border-radius: 1.5rem; padding: 2.5rem; width: 100%; max-width: 450px; box-shadow: 0 25px 45px rgba(0,0,0,0.5); }
        .custom-input { background: rgba(255, 255, 255, 0.08) !important; border: 1px solid rgba(255, 255, 255, 0.2) !important; color: white !important; border-radius: 0.8rem; padding: 10px 15px; }
        .custom-input:focus { border-color: #00c6ff !important; box-shadow: 0 0 15px rgba(0, 198, 255, 0.4) !important; }
        .custom-input option { background: #1a1a2e; color: white; }
        .btn-glow { background: linear-gradient(135deg, #00c6ff, #0072ff); color: white; border: none; border-radius: 50px; padding: 12px; font-weight: bold; width: 100%; transition: all 0.3s; }
        .btn-glow:hover { transform: translateY(-3px); box-shadow: 0 10px 20px rgba(0, 114, 255, 0.4); }
    </style>
</head>
<body>

<div class="container d-flex justify-content-center">
    <div class="admin-card">
        <h3 class="mb-4 text-center fw-bold" style="color: #00c6ff;">
            <i data-feather="edit" class="me-2"></i>Edit Promo Code
        </h3>

        <form action="../UpdatePromoServlet" method="POST">
            <input type="hidden" name="originalCode" value="<%= code %>">

            <div class="mb-3">
                <label class="form-label text-light fw-bold">Promo Code</label>
                <input type="text" name="promoCode" class="form-control custom-input" value="<%= code %>" required>
            </div>

            <div class="mb-3">
                <label class="form-label text-light fw-bold">Discount Percentage (%)</label>
                <input type="number" name="discount" class="form-control custom-input" value="<%= discount %>" required>
            </div>

            <div class="mb-4">
                <label class="form-label text-light fw-bold">Status</label>
                <select name="status" class="form-select custom-input">
                    <option value="Active" <%= "Active".equals(status) ? "selected" : "" %>>Active</option>
                    <option value="Inactive" <%= "Inactive".equals(status) ? "selected" : "" %>>Inactive</option>
                </select>
            </div>

            <button type="submit" class="btn btn-glow mb-3">Update Promo</button>

            <!-- 👇    Cancel  Delete   👇 -->
            <div class="d-flex gap-2">
                <a href="manage_promos.jsp" class="btn btn-outline-secondary w-50 fw-bold" style="border-radius: 50px;">Cancel</a>

                <a href="../DeletePromoServlet?code=<%= code %>"
                   class="btn btn-danger w-50 fw-bold d-flex align-items-center justify-content-center gap-1"
                   style="border-radius: 50px; box-shadow: 0 4px 10px rgba(220, 53, 69, 0.3);"
                   onclick="return confirm('Are you sure you want to delete this Promo Code forever?');">
                    <i data-feather="trash-2" style="width: 16px;"></i> Delete
                </a>
            </div>
            <!-- 👆 ---------------------------------------------- 👆 -->
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>feather.replace();</script>
</body>
</html>