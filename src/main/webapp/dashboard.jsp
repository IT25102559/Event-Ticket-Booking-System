<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String userEmail = (String) session.getAttribute("loggedUser");
    if (userEmail == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Dashboard | EventTix</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light pt-5">

    <div class="container mt-5">
        <div class="row justify-content-center">
            <div class="col-md-8 col-lg-6">
                <div class="card border-0 shadow-sm rounded-4 text-center p-5">
                    <h2 class="mb-3 fw-bold">My Dashboard</h2>
                    <p class="text-muted mb-4">You are logged in as: <br><strong class="text-dark fs-5"><%= userEmail %></strong></p>

                    <hr class="mb-4">

                    <div class="d-grid gap-3 d-sm-flex justify-content-sm-center">
                        <a href="edit_profile.jsp" class="btn btn-warning btn-lg px-4 fw-bold text-dark">✏️ Edit Profile</a>
                        <a href="LogoutServlet" class="btn btn-outline-danger btn-lg px-4 fw-bold">🚪 Logout</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

</body>
</html>