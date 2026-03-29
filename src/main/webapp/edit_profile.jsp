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
    <title>Edit Profile | EventTix</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f0f2f5; }
        .card { border-radius: 15px; box-shadow: 0 10px 20px rgba(0,0,0,0.1); border: none; }
    </style>
</head>
<body class="d-flex align-items-center py-5" style="min-height: 100vh;">

    <main class="w-100 m-auto" style="max-width: 450px;">
        <div class="card p-4 p-md-5">
            <div class="text-center mb-4">
                <h3 class="fw-bold">Update Profile</h3>
                <p class="text-muted small">Updating details for:<br><strong class="text-dark"><%= userEmail %></strong></p>
            </div>

            <form action="UpdateProfileServlet" method="POST">
                <div class="mb-3">
                    <label class="form-label text-secondary fw-bold">New Password</label>
                    <input type="password" name="newPassword" class="form-control form-control-lg" placeholder="Enter new password" required>
                </div>

                <div class="mb-4">
                    <label class="form-label text-secondary fw-bold">New Phone Number</label>
                    <input type="text" name="newPhone" class="form-control form-control-lg" placeholder="Enter new phone" required>
                </div>

                <button class="btn btn-warning btn-lg w-100 fw-bold mb-3" type="submit">Update Details</button>
                <a href="dashboard.jsp" class="btn btn-light border btn-lg w-100 fw-bold text-secondary">Cancel / Go Back</a>
            </form>
        </div>
    </main>

</body>
</html>