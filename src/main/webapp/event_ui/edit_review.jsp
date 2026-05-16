<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="user_management.DBConnection" %>
<%
    String loggedUser = (String) session.getAttribute("username");
    String role = (String) session.getAttribute("userRole");


    if (loggedUser == null) {
        response.sendRedirect("../user_ui/login.jsp?error=login_first");
        return;
    }

    String id = request.getParameter("id");
    String dramaName = "", comment = "", reviewOwner = "";
    int rating = 5;


    if (id != null) {
        try (Connection con = DBConnection.getConnection()) {
            PreparedStatement pst = con.prepareStatement("SELECT * FROM reviews WHERE id=?");
            pst.setString(1, id);
            ResultSet rs = pst.executeQuery();
            if(rs.next()){
                dramaName = rs.getString("drama_name");
                rating = rs.getInt("rating");
                comment = rs.getString("comment");
                reviewOwner = rs.getString("user_email"); // අයිතිකාරයා කවුද කියලා ගන්නවා
            }
        } catch(Exception e) { e.printStackTrace(); }
    }

    // 🌟 Security Check: අයිතිකාරයා නෙවෙයි නම් සහ Admin ත් නෙවෙයි නම් ආපහු හරවනවා 🌟
    if (!"Admin".equals(role) && !loggedUser.equals(reviewOwner)) {
        response.sendRedirect("reviews.jsp?error=access_denied");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Review | EventTix</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/site.css">
    <script defer src="${pageContext.request.contextPath}/assets/js/site.js"></script>
    <style>
        body { background: linear-gradient(135deg, #1a1a2e, #16213e); color: white; min-height: 100vh; display: flex; align-items: center; justify-content: center;}
        .card-custom { background-color: #242a45; border-radius: 10px; padding: 25px; border: 1px solid #3a4161; width: 100%; max-width: 500px; box-shadow: 0 10px 30px rgba(0,0,0,0.5);}
        .custom-input { background-color: #1a1e36; color: white; border: 1px solid #3a4161; }
        .custom-input:focus { background-color: #1a1e36; color: white; border-color: #00c6ff; box-shadow: none;}
    </style>
</head>
<body>

<div class="container d-flex justify-content-center">
    <div class="card-custom">
        <h4 class="mb-4 text-warning text-center fw-bold">Edit Your Review</h4>

        <form action="../UpdateReviewServlet" method="POST">
            <input type="hidden" name="id" value="<%= id %>">

            <div class="mb-3">
                <label>Drama Name</label>
                <input type="text" name="drama_name" class="form-control custom-input" value="<%= dramaName %>" required>
            </div>

            <div class="mb-3">
                <label>Rating</label>
                <select name="rating" class="form-control custom-input">
                    <option value="5" <%= rating==5 ? "selected" : "" %>>⭐⭐⭐⭐⭐ - Excellent</option>
                    <option value="4" <%= rating==4 ? "selected" : "" %>>⭐⭐⭐⭐ - Good</option>
                    <option value="3" <%= rating==3 ? "selected" : "" %>>⭐⭐⭐ - Average</option>
                    <option value="2" <%= rating==2 ? "selected" : "" %>>⭐⭐ - Poor</option>
                    <option value="1" <%= rating==1 ? "selected" : "" %>>⭐ - Very Poor</option>
                </select>
            </div>

            <div class="mb-4">
                <label>Comment</label>
                <textarea name="comment" rows="4" class="form-control custom-input" required><%= comment %></textarea>
            </div>

            <div class="d-flex gap-2">
                <a href="reviews.jsp" class="btn btn-outline-secondary w-50 fw-bold" style="border-radius: 20px;">Cancel</a>
                <button type="submit" class="btn btn-info w-50 fw-bold" style="border-radius: 20px;">Update</button>
            </div>
        </form>
    </div>
</div>

</body>
</html>