<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="admin_dashboard.AdminManager, event_management.StageDrama" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Drama | Admin</title>
    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/site.css">
    <!-- Feather icons (lightweight) -->
    <script src="https://unpkg.com/feather-icons"></script>
    <script defer src="${pageContext.request.contextPath}/assets/js/site.js"></script>
    <style>
        /* 1️⃣ Gradient background – same theme as the whole app */
        body {
            min-height: 100vh;
            background: linear-gradient(135deg, #1a1a2e, #16213e);
            display: flex;
            flex-direction: column;
            font-family: system-ui, sans-serif;
        }
        /* 2️⃣ Card slide‑fade animation */
        @keyframes slideFade {
            0%   { opacity: 0; transform: translateY(30px); }
            100% { opacity: 1; transform: translateY(0); }
        }
        .edit-card {
            animation: slideFade 0.8s ease-out;
            border-radius: 1rem;
        }
        /* 3️⃣ Button hover lift */
        .btn-warning, .btn-link {
            transition: transform .2s, box-shadow .2s;
        }
        .btn-warning:hover, .btn-link:hover {
            transform: translateY(-2px);
            box-shadow: 0 8px 15px rgba(0,0,0,.2);
        }
        /* 4️⃣ Toast container (for update‑success messages) */
        .toast-container {
            position: fixed;
            top: 1rem;
            right: 1rem;
            z-index: 1055;
        }
    </style>
</head>
<body>
<div class="container my-5 d-flex justify-content-center">
    <div class="edit-card shadow-lg bg-white p-4" style="max-width: 540px;">
        <h3 class="text-center fw-bold mb-4">
            <i data-feather="edit-2"></i> Edit Drama Details
        </h3>
        <!-- Toast for successful update (if ?updated=true) -->
        <div class="toast-container">
            <% if ("true".equals(request.getParameter("updated"))) { %>
            <div class="toast align-items-center text-bg-success border-0 show" role="alert">
                <div class="d-flex">
                    <div class="toast-body">Drama updated successfully!</div>
                    <button type="button" class="btn-close btn-close-white me-2 m-auto"
                            data-bs-dismiss="toast"></button>
                </div>
            </div>
            <% } %>
        </div>
        <%
            String id = request.getParameter("id");
            AdminManager manager = new AdminManager();
            StageDrama drama = manager.getDramaById(id);
            if (drama != null) {
        %>
        <form action="../UpdateDramaServlet" method="POST">
            <input type="hidden" name="dramaId" value="<%= drama.getEventId() %>">
            <div class="mb-3">
                <label class="form-label fw-bold"><i data-feather="film"></i> Drama Name</label>
                <input type="text" name="dramaName" class="form-control"
                       value="<%= drama.getEventName() %>" required>
            </div>
            <div class="mb-3">
                <label class="form-label fw-bold"><i data-feather="calendar"></i> Show Date</label>
                <input type="date" name="showDate" class="form-control"
                       value="<%= drama.getDate() %>" required>
            </div>
            <div class="mb-3">
                <label class="form-label fw-bold"><i data-feather="map-pin"></i> Location</label>
                <input type="text" name="location" class="form-control"
                       value="<%= drama.getLocation() %>" required>
            </div>
            <div class="mb-4">
                <label class="form-label fw-bold"><i data-feather="users"></i> Director Name</label>
                <input type="text" name="director" class="form-control"
                       value="<%= drama.getDirector() %>" required>
            </div>
            <button type="submit" class="btn btn-warning w-100 fw-bold py-2">
                <i data-feather="check-circle"></i> Update Changes
            </button>
            <a href="manage_dramas.jsp"
               class="btn btn-link w-100 text-muted mt-2">
                <i data-feather="arrow-left"></i> Back to Manage
            </a>
        </form>
        <% } else { %>
        <div class="alert alert-danger text-center">
            Drama not found!
        </div>
        <% } %>
    </div>
</div>
<!-- Bootstrap bundle (includes Popper) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Feather icons
    feather.replace();
    // Auto‑dismiss toast after 4 seconds
    const toastEls = document.querySelectorAll('.toast');
    toastEls.forEach(el => new bootstrap.Toast(el, { delay: 4000 }).show());
</script>
</body>
</html>