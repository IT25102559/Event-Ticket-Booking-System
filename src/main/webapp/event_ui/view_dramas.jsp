<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="event_management.DramaManager" %>
<%@ page import="event_management.Drama" %>
<%@ page import="java.net.URLEncoder" %>
<%
    String loggedUser = (String) session.getAttribute("username");
    if (loggedUser == null) {
        response.sendRedirect("../user_ui/login.jsp?error=login_first");
        return;
    }


    String role = (String) session.getAttribute("userRole");

    DramaManager manager = new DramaManager();
    List<Drama> dramaList = manager.getAllDramas();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Home - EventTix</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/site.css">
    <script src="https://unpkg.com/feather-icons"></script>
    <script defer src="${pageContext.request.contextPath}/assets/js/site.js"></script>
    <style>

        body {
            background: linear-gradient(rgba(26, 26, 46, 0.5), rgba(22, 33, 62, 0.7)), url('../images/1234.jpg') no-repeat center center fixed;
            background-size: cover;
            color: white;
            min-height: 100vh;
            font-family: 'Segoe UI', sans-serif;
            animation: pageFadeIn 0.8s ease-in-out;
        }

        @keyframes pageFadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        ::-webkit-scrollbar { display: none; }


        .hero-section {
            padding: 4rem 0 2rem 0;
            text-align: center;
            animation: fadeSlideDown 0.8s ease-out;
        }

        @keyframes fadeSlideDown {
            from { opacity: 0; transform: translateY(-30px); }
            to { opacity: 1; transform: translateY(0); }
        }


        .poster-card {
            background: transparent;
            border: none;
            transition: transform 0.3s;
            max-width: 320px;
            margin: auto;
            opacity: 0; 
            animation: fadeSlideUp 0.8s ease-out 0.3s forwards; 
        }

        @keyframes fadeSlideUp {
            from { opacity: 0; transform: translateY(40px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .poster-card:hover { transform: scale(1.03); }

        .poster-img {
            width: 100%;
            height: 480px;
            object-fit: contain;
            border-radius: 1.5rem;
            box-shadow: 0 15px 35px rgba(0,0,0,0.5);
        }

        .book-btn-container {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(10px);
            -webkit-backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            padding: 15px;
            border-radius: 1.2rem;
            margin-top: 15px;
            position: relative;
            z-index: 10;
        }

        .btn-book-now {
            background: linear-gradient(135deg, #ff007a, #7f00ff);
            color: white !important;
            border: none;
            border-radius: 50px;
            padding: 12px 20px;
            font-size: 1.1rem;
            font-weight: 700;
            letter-spacing: 1px;
            text-transform: uppercase;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(255, 0, 122, 0.4);
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .btn-book-now:hover {
            transform: translateY(-3px) scale(1.02);
            box-shadow: 0 8px 25px rgba(255, 0, 122, 0.7);
        }

        .btn-book-now i { transition: transform 0.3s ease; }
        .btn-book-now:hover i { transform: rotate(-15deg) scale(1.2); }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm w-100">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold" href="view_dramas.jsp"><i data-feather="film"></i> EventTix</a>
        <div class="navbar-nav ms-auto align-items-center">
            <a class="nav-link text-warning fw-bold" href="view_dramas.jsp">Home</a>

            <% if (!"Admin".equals(role)) { %>
                <a class="nav-link" href="../booking_ui/book_ticket.jsp">Book Tickets</a>
                <a class="nav-link" href="../booking_ui/view_bookings.jsp">My Bookings</a>
                <a class="nav-link" href="../payment_ui/payment_form.jsp">Make Payment</a>
                <a class="nav-link text-info fw-bold ms-lg-3" href="../user_ui/profile.jsp">
                    <i data-feather="user" style="width: 18px; margin-bottom: 2px;"></i> My Profile
                </a>
            <% } %>

            <% if ("Admin".equals(role)) { %>
                <a class="nav-link text-success fw-bold ms-lg-3" href="../admin_ui/manage_dramas.jsp">
                    <i data-feather="settings" style="width: 16px; margin-bottom: 2px;"></i> Admin Panel
                </a>
            <% } %>

            <a class="nav-link btn btn-outline-danger btn-sm ms-lg-3 px-3" href="../user_ui/logout.jsp" style="border-radius: 20px;">Logout</a>
        </div>
    </div>
</nav>

<div class="container">
    <div class="hero-section">
        <h1 class="display-4 fw-bold mb-2">Welcome to EventTix 🎭</h1>
        <p class="lead text-light">Discover and book tickets for the best stage dramas in town!</p>

        <div class="mt-4 mb-2">
            <a href="reviews.jsp" class="btn btn-outline-warning" style="border-radius: 20px; padding: 10px 25px; font-weight: bold; font-size: 1.1rem;">
                <i data-feather="star" style="width: 20px; margin-right: 8px; margin-bottom: 3px;"></i>
                View & Add Reviews
            </a>
        </div>
    </div>

    <div class="row g-5 mb-5 justify-content-center">
        <%
            if (dramaList != null && !dramaList.isEmpty()) {
                for (Drama drama : dramaList) {
                    String imgName = drama.getName().replaceAll("\\s+", "") + ".jpg";
        %>
        <div class="col-md-6 col-lg-4">
            <div class="poster-card text-center">

                <img src="../images/<%= imgName %>"
                     class="poster-img"
                     alt="<%= drama.getName() %>"
                     onerror="this.src='https://via.placeholder.com/400x600?text=Poster+Not+Found'">

                <div class="book-btn-container mx-2">
                    <a href="../booking_ui/book_ticket.jsp?drama=<%= URLEncoder.encode(drama.getName(), "UTF-8") %>"
                       class="btn btn-book-now w-100 text-decoration-none text-center">
                        <i data-feather="ticket" style="margin-right: 8px;"></i> BOOK NOW
                    </a>
                </div>
            </div>
        </div>
        <%
                }
            } else {
        %>
        <div class="col-12 text-center mt-5">
            <h4 class="text-warning fw-bold">No Stage Dramas available.</h4>
        </div>
        <% } %>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>feather.replace();</script>
</body>
</html>