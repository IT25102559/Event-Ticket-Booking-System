<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    // Security Check: Admin   
    String role = (String) session.getAttribute("userRole");
    if (!"Admin".equals(role)) {
        response.sendRedirect("../user_ui/login.jsp?error=true");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Drama | Admin Panel</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/site.css">
    <script src="https://unpkg.com/feather-icons"></script>
    <script defer src="${pageContext.request.contextPath}/assets/js/site.js"></script>
    <style>
        body {
            min-height: 100vh;
            /*  Background  */
            background: linear-gradient(rgba(26, 26, 46, 0.85), rgba(22, 33, 62, 0.95)), url('../images/stage_bg.jpg') no-repeat center center fixed;
            background-size: cover;
            display: flex;
            flex-direction: column;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: white;
        }

        /* Glassmorphism Card */
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
            color: #38ef7d;
            font-weight: 800;
        }

        /* Input Box Design */
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
            border-color: #38ef7d !important;
            box-shadow: 0 0 15px rgba(56, 239, 125, 0.4) !important;
        }

        /* 🌟 ‍  Auto-fill       ‍  🌟 */
        .custom-input:-webkit-autofill,
        .custom-input:-webkit-autofill:hover,
        .custom-input:-webkit-autofill:focus,
        .custom-input:-webkit-autofill:active {
            -webkit-text-fill-color: white !important;
            transition: background-color 5000s ease-in-out 0s;
            caret-color: white;
        }

        ::-webkit-calendar-picker-indicator { filter: invert(1); cursor: pointer; }

        .input-label { color: #e2e8f0; font-weight: 600; margin-bottom: 8px; font-size: 0.85rem; }

        /* Save Button  (Neon Green) */
        .btn-glow-success {
            background: linear-gradient(135deg, #11998e, #38ef7d);
            color: white; border: none; border-radius: 50px; padding: 12px;
            font-size: 1.05rem; font-weight: bold; letter-spacing: 1px;
            transition: all 0.3s ease; box-shadow: 0 8px 20px rgba(56, 239, 125, 0.4);
        }
        .btn-glow-success:hover {
            transform: translateY(-3px); box-shadow: 0 12px 25px rgba(56, 239, 125, 0.6); color: white;
        }

        /*  Custom File Upload Design  */
        input[type="file"] { display: none; }

        .file-upload-label {
            display: flex; align-items: center; justify-content: center;
            border: 2px dashed rgba(255, 255, 255, 0.3) !important;
            cursor: pointer; color: #cbd5e1; padding: 15px !important; text-align: center;
        }

        .file-upload-label:hover { border-color: #38ef7d !important; background: rgba(56, 239, 125, 0.05) !important; color: white; }

        .file-upload-label.active { border-style: solid !important; border-color: #38ef7d !important; color: #38ef7d !important; background: rgba(56, 239, 125, 0.1) !important; }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm w-100 mb-4">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold text-warning" href="manage_dramas.jsp"><i data-feather="settings"></i> Admin Panel</a>
        <div class="navbar-nav ms-auto align-items-center">
            <a class="nav-link" href="../event_ui/view_dramas.jsp">User View</a>
            <a class="nav-link text-white fw-bold" href="manage_dramas.jsp">Manage Dramas</a>
            <a class="nav-link btn btn-outline-danger btn-sm ms-lg-3 px-3" href="../user_ui/logout.jsp" style="border-radius: 20px;">Logout</a>
        </div>
    </div>
</nav>

<div class="container d-flex justify-content-center flex-grow-1 mb-5">
    <div class="admin-card" style="max-width: 550px;">
        <h3 class="text-center mb-4 d-flex align-items-center justify-content-center">
            <i data-feather="plus-circle" class="me-2 text-success" style="width: 28px; height: 28px;"></i>
            <span class="gradient-text">Add New Stage Drama</span>
        </h3>

        <form action="../AddDramaServlet" method="POST" enctype="multipart/form-data">

            <div class="row mb-3">
                <div class="col-md-5">
                    <label class="form-label input-label">Drama ID</label>
                    <input type="text" name="dramaId" class="form-control custom-input" placeholder="SD001" required>
                </div>
                <div class="col-md-7">
                    <label class="form-label input-label">Drama Name</label>
                    <input type="text" name="dramaName" class="form-control custom-input" placeholder="Mama Newe Wena Kenek" required>
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label input-label">Show Date</label>
                <input type="date" name="showDate" class="form-control custom-input" required>
            </div>

            <div class="mb-3">
                <label class="form-label input-label">Theater / Location</label>
                <input type="text" name="location" class="form-control custom-input" placeholder="e.g. Lionel Wendt" required>
            </div>

            <div class="mb-3">
                <label class="form-label input-label">Director Name</label>
                <input type="text" name="director" class="form-control custom-input" placeholder="e.g. Ediriweera Sarachchandra" required>
            </div>

            <div class="mb-4">
                <label class="form-label input-label">Upload Poster</label>
                <input type="file" id="posterFile" name="posterFile" accept="image/*" required onchange="updateFileName(this)">
                <label for="posterFile" id="fileLabel" class="form-control custom-input file-upload-label">
                    <i data-feather="upload-cloud" class="me-2" style="width: 20px; height: 20px;"></i>
                    <span id="fileName">Click here to browse your image</span>
                </label>
            </div>

            <button type="submit" class="btn btn-glow-success w-100 mt-2">
                <i data-feather="save" class="me-2" style="width: 18px; margin-bottom: 2px;"></i> Save Drama Details
            </button>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    feather.replace();
    function updateFileName(input) {
        const fileNameSpan = document.getElementById('fileName');
        const fileLabel = document.getElementById('fileLabel');
        if (input.files && input.files.length > 0) {
            fileNameSpan.innerHTML = "<b>" + input.files[0].name + "</b> selected";
            fileLabel.classList.add('active');
        } else {
            fileNameSpan.textContent = "Click here to browse your image";
            fileLabel.classList.remove('active');
        }
    }
</script>
</body>
</html>