<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Registration | TicketBooking</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f0f2f5; }
        .card { border-radius: 15px; box-shadow: 0 10px 20px rgba(0,0,0,0.1); border: none; }
        .brand-text { color: #198754; font-weight: 800; letter-spacing: 1px; }
    </style>
</head>
<body class="d-flex align-items-center py-5" style="min-height: 100vh;">

    <main class="w-100 m-auto" style="max-width: 450px;">
        <div class="card p-4 p-md-5">
            <div class="text-center mb-4">
                <h2 class="brand-text">EventTix</h2>
                <p class="text-muted">Create your new account</p>
            </div>

            <form action="RegisterServlet" method="POST">
                <div class="mb-3">
                    <label class="form-label text-secondary fw-bold">Full Name</label>
                    <input type="text" name="name" class="form-control form-control-lg" placeholder="e.g. Kusal Mendis" required>
                </div>

                <div class="mb-3">
                    <label class="form-label text-secondary fw-bold">Email Address</label>
                    <input type="email" name="email" class="form-control form-control-lg" placeholder="name@example.com" required>
                </div>

                <div class="mb-3">
                    <label class="form-label text-secondary fw-bold">Password</label>
                    <input type="password" name="password" class="form-control form-control-lg" placeholder="********" required>
                </div>

                <div class="mb-4">
                    <label class="form-label text-secondary fw-bold">Phone Number</label>
                    <input type="text" name="phone" class="form-control form-control-lg" placeholder="07X XXX XXXX" required>
                </div>

                <button class="btn btn-success btn-lg w-100 fw-bold" type="submit">Register Now</button>

                <div class="text-center mt-4">
                    <p class="mb-0 text-muted">Already have an account? <a href="login.jsp" class="text-decoration-none fw-bold">Log in here</a></p>
                </div>
            </form>
        </div>
    </main>

    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>