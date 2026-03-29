<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Customer Login | EventTix</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body { background-color: #f0f2f5; }
        .card { border-radius: 15px; box-shadow: 0 10px 20px rgba(0,0,0,0.1); border: none; }
    </style>
</head>
<body class="d-flex align-items-center py-5" style="min-height: 100vh;">

    <main class="w-100 m-auto" style="max-width: 400px;">
        <div class="card p-4 p-md-5">
            <div class="text-center mb-4">
                <h2 class="text-primary fw-bold">EventTix</h2>
                <p class="text-muted">Welcome back! Please login.</p>
            </div>

            <form action="LoginServlet" method="POST">
                <div class="mb-3">
                    <label class="form-label text-secondary fw-bold">Email Address</label>
                    <input type="email" name="email" class="form-control form-control-lg" placeholder="name@example.com" required>
                </div>

                <div class="mb-4">
                    <label class="form-label text-secondary fw-bold">Password</label>
                    <input type="password" name="password" class="form-control form-control-lg" placeholder="********" required>
                </div>

                <button class="btn btn-primary btn-lg w-100 fw-bold" type="submit">Login</button>

                <div class="text-center mt-4">
                    <p class="mb-0 text-muted">Don't have an account? <a href="register.jsp" class="text-decoration-none fw-bold">Register here</a></p>
                </div>
            </form>
        </div>
    </main>

</body>
</html>