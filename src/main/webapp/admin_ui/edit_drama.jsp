<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%

    String role = (String) session.getAttribute("userRole");
    if (!"Admin".equals(role)) {
        response.sendRedirect("../user_ui/login.jsp?error=true");
        return;
    }


    String dramaId = request.getParameter("id");
    if(dramaId == null) dramaId = "Unknown ID";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Drama | Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/site.css">
    <script src="https://unpkg.com/feather-icons"></script>
    <script defer src="${pageContext.request.contextPath}/assets/js/site.js"></script>
    <style>
        body {
            min-height: 100vh;
            background: linear-gradient(135deg, #1a1a2e, #16213e);
            display: flex;
            flex-direction: column;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: white;
        }

        
        .admin-card {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 1.5rem;
            padding: 2.5rem;
            width: 100%;
            box-shadow: 0 25px 45px rgba(0,0,0,0.5);
            animation: slideFade 0.4s ease-out;
        }

        @keyframes slideFade {
            0% { opacity: 0; transform: translateY(20px); }
            100% { opacity: 1; transform: translateY(0); }
        }

        .gradient-text {
            background: linear-gradient(135deg, #f6d365 0%, #fda085 100%);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            font-weight: 800;
        }

        
        .custom-input {
            background: rgba(255, 255, 255, 0.08) !important;
            border: 1px solid rgba(255, 255, 255, 0.2) !important;
            color: white !important;
            border-radius: 0.8rem;
            padding: 12px 15px;
            transition: all 0.3s ease;
        }

        .custom-input:focus {
            background: rgba(255, 255, 255, 0.12) !important;
            border-color: #f6d365 !important;
            box-shadow: 0 0 15px rgba(246, 211, 101, 0.4) !important;
        }

        .input-label { color: #e2e8f0; font-weight: 600; margin-bottom: 8px; }

        
        .btn-glow-warning {
            background: linear-gradient(135deg, #f6d365, #fda085);
            color: #000;
            border: none;
            border-radius: 50px;
            padding: 12px;
            font-size: 1.1rem;
            font-weight: bold;
            letter-spacing: 1px;
            transition: all 0.3s ease;
            box-shadow: 0 8px 20px rgba(246, 211, 101, 0.4);
        }

        .btn-glow-warning:hover {
            transform: translateY(-3px);
            box-shadow: 0 12px 25px rgba(246, 211, 101, 0.6);
            color: #000;
        }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm w-100">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold text-warning" href="manage_dramas.jsp"><i data-feather="settings"></i> Admin Panel</a>
        <div class="navbar-nav ms-auto align-items-center">
            <a class="nav-link" href="../event_ui/view_dramas.jsp">User View</a>
            <a class="nav-link text-white fw-bold" href="manage_dramas.jsp">Manage Dramas</a>
        </div>
    </div>
</nav>

<div class="container my-5 d-flex justify-content-center flex-grow-1">
    <div class="admin-card" style="max-width: 500px;">
        <h3 class="text-center mb-4">
            <i data-feather="edit-2" class="me-2 text-warning" style="width: 28px; height: 28px;"></i>
            <span class="gradient-text">Edit Drama</span>
        </h3>

        <form action="../UpdateDramaServlet" method="POST">

            <div class="mb-3">
                <label class="form-label input-label">Drama ID</label>
                <input type="text" name="dramaId" class="form-control custom-input" value="<%= dramaId %>" readonly>
            </div>

            <div class="mb-3">
                <label class="form-label input-label">Drama Name</label>
                <input type="text" name="dramaName" class="form-control custom-input" placeholder="Enter Drama Name" required>
            </div>

            <div class="mb-3">
                <label class="form-label input-label">Show Date</label>
                <input type="date" name="showDate" class="form-control custom-input" required>
            </div>

            <div class="mb-4">
                <label class="form-label input-label">Director</label>
                <input type="text" name="director" class="form-control custom-input" placeholder="Enter Director Name" required>
            </div>

            <button type="submit" class="btn btn-glow-warning w-100 mb-3">
                <i data-feather="save" class="me-2"></i> Update Drama
            </button>

            <a href="manage_dramas.jsp" class="btn btn-outline-secondary w-100" style="border-radius: 50px;">Cancel</a>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>feather.replace();</script>
</body>
</html>