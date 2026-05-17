<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="user_management.DBConnection" %>
<%
    
    String loggedUser = (String) session.getAttribute("username");
    if (loggedUser == null) {
        response.sendRedirect("../user_ui/login.jsp?msg=login_first");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Secure Payment | EventTix</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/site.css">
    <script src="https://unpkg.com/feather-icons"></script>
    <script defer src="${pageContext.request.contextPath}/assets/js/site.js"></script>
    <style>
        body {
            min-height: 100vh;
            background: linear-gradient(rgba(26, 26, 46, 0.7), rgba(22, 33, 62, 0.8)), url('../images/Cpayment.jpg') no-repeat center center fixed;
            background-size: cover;
            display: flex;
            flex-direction: column;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            color: white;
        }
        .payment-card { background: rgba(255, 255, 255, 0.05); backdrop-filter: blur(20px); -webkit-backdrop-filter: blur(20px); border: 1px solid rgba(255, 255, 255, 0.1); border-radius: 1.5rem; padding: 2.5rem; width: 100%; box-shadow: 0 25px 45px rgba(0,0,0,0.5); animation: slideFade 0.6s ease-out; }
        @keyframes slideFade { 0% { opacity: 0; transform: translateY(30px); } 100% { opacity: 1; transform: translateY(0); } }
        .gradient-text { background: linear-gradient(135deg, #00c6ff 0%, #0072ff 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; font-weight: 800; }

        /* අර සුදු වෙලා තිබ්බ Input කොටු වල ලස්සන අඳුරු Design එක */
        .custom-input { background: rgba(255, 255, 255, 0.08) !important; border: 1px solid rgba(255, 255, 255, 0.2) !important; color: white !important; border-radius: 0.8rem; padding: 12px 15px; transition: all 0.3s ease; }
        .custom-input:focus { background: rgba(255, 255, 255, 0.12) !important; border-color: #00c6ff !important; box-shadow: 0 0 15px rgba(0, 198, 255, 0.4) !important; }
        .custom-input::placeholder { color: rgba(255, 255, 255, 0.5) !important; }

        .input-label { color: #e2e8f0; font-weight: 600; letter-spacing: 0.5px; margin-bottom: 8px; font-size: 0.9rem; }
        .btn-glow { background: linear-gradient(135deg, #00c6ff, #0072ff); color: white; border: none; border-radius: 50px; padding: 12px; font-size: 1.2rem; font-weight: bold; letter-spacing: 1px; transition: all 0.3s ease; box-shadow: 0 8px 20px rgba(0, 114, 255, 0.4); }
        .btn-glow:hover { transform: translateY(-3px); box-shadow: 0 12px 25px rgba(0, 114, 255, 0.6); color: white; }
        .summary-box { background: rgba(0, 0, 0, 0.2); border: 1px solid rgba(255, 255, 255, 0.1); border-radius: 1rem; padding: 15px; }
    </style>
</head>
<body>

<nav class="navbar navbar-expand-lg navbar-dark bg-dark shadow-sm w-100">
    <div class="container-fluid">
        <a class="navbar-brand fw-bold" href="../event_ui/view_dramas.jsp"><i data-feather="film"></i> EventTix</a>
        <div class="navbar-nav ms-auto align-items-center">
            <a class="nav-link" href="../event_ui/view_dramas.jsp">Home</a>
            <a class="nav-link" href="../booking_ui/book_ticket.jsp">Book Tickets</a>
            <a class="nav-link" href="../booking_ui/view_bookings.jsp">My Bookings</a>
            <a class="nav-link text-warning fw-bold" href="payment_form.jsp">Make Payment</a>
            <a class="nav-link btn btn-outline-danger btn-sm ms-lg-3 px-3" href="../user_ui/logout.jsp" style="border-radius: 20px;">Logout</a>
        </div>
    </div>
</nav>

<div class="container my-5 d-flex justify-content-center flex-grow-1">
    <div class="payment-card" style="max-width: 500px;">
        <h3 class="text-center mb-4">
            <i data-feather="lock" class="me-2 text-info" style="width: 28px; height: 28px;"></i>
            <span class="gradient-text">Secured Payment</span>
        </h3>

        
        <form action="../PaymentServlet" method="POST" autocomplete="off">
            <div class="mb-3">
                <label class="form-label input-label">Booking ID</label>
                <input type="text" name="bookingId" class="form-control custom-input" placeholder="e.g. BKG-123456" autocomplete="off" required>
            </div>

            <div class="mb-3">
                <label class="form-label input-label">Name on Card</label>
                <input type="text" name="cardName" class="form-control custom-input" placeholder="e.g. Kamal Perera" autocomplete="off" required>
            </div>

            <div class="mb-3">
                <label class="form-label input-label">Card Number</label>
                <input type="text" name="cardNumber" class="form-control custom-input" placeholder="1234 5678 1234 5678" maxlength="19" autocomplete="off" required>
            </div>

            <div class="row mb-3">
                <div class="col-6">
                    <label class="form-label input-label">Expiry Date</label>
                    <input type="text" name="expiryDate" class="form-control custom-input" placeholder="MM/YY" maxlength="5" autocomplete="off" required>
                </div>
                <div class="col-6">
                    <label class="form-label input-label">CVV</label>
                    <input type="password" name="cvv" class="form-control custom-input" placeholder="123" maxlength="3" autocomplete="off" required>
                </div>
            </div>

            
            <div class="mb-3 p-3" style="background: rgba(255, 193, 7, 0.1); border-radius: 0.8rem; border: 1px dashed rgba(255, 193, 7, 0.5);">
                <label class="form-label text-warning fw-bold" style="font-size: 0.9rem;">
                    <i data-feather="tag" style="width: 16px; margin-bottom: 2px;"></i> Have a Promo Code?
                </label>
                <div class="input-group">
                    <input type="text" id="promoInput" name="promoCode" class="form-control custom-input" placeholder="e.g. BONUS25" autocomplete="off" style="border-color: rgba(255, 193, 7, 0.3) !important;">
                    <button type="button" class="btn btn-warning fw-bold" onclick="applyPromo()">Apply</button>
                </div>
                <small id="promoMessage" class="mt-2 d-block"></small>
            </div>

            
            <div class="summary-box mb-4">
                <div class="d-flex justify-content-between mb-2">
                    <span class="text-light">Subtotal:</span>
                    <span class="fw-bold">Rs. <span id="subtotal">0.00</span></span>
                </div>
                <div class="d-flex justify-content-between mb-2 text-success" id="discountRow" style="display: none !important;">
                    <span>Discount (<span id="discountPercent">0</span>%):</span>
                    <span class="fw-bold">- Rs. <span id="discountAmount">0.00</span></span>
                </div>
                <hr style="border-color: rgba(255,255,255,0.2);">
                <div class="d-flex justify-content-between fs-5">
                    <span class="text-info fw-bold">Total to Pay:</span>
                    <span class="text-info fw-bold">Rs. <span id="finalTotal">0.00</span></span>
                </div>
            </div>

            <button type="submit" class="btn btn-glow w-100">
                <i data-feather="shield" class="me-2"></i> Pay Now
            </button>
        </form>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script>
    feather.replace();

    const validPromos = {};
    <%
        try (Connection con = DBConnection.getConnection()) {
            Statement st = con.createStatement();
            ResultSet rs = st.executeQuery("SELECT code, discount_percentage FROM promo_codes WHERE status='Active'");
            while(rs.next()) {
                out.print("validPromos['" + rs.getString("code").toUpperCase() + "'] = " + rs.getInt("discount_percentage") + ";\n");
            }
        } catch(Exception e) { e.printStackTrace(); }
    %>

    let baseAmount = 0.00;

    document.querySelector("input[name='bookingId']").addEventListener("blur", function() {
        let bId = this.value.trim();
        let subtotalEl = document.getElementById("subtotal");

        if(bId !== "") {
            subtotalEl.innerText = "Loading...";

            fetch('../GetAmountServlet?bookingId=' + bId)
            .then(response => response.text())
            .then(data => {
                let amount = parseFloat(data);
                if(amount > 0) {
                    baseAmount = amount;
                    subtotalEl.innerText = baseAmount.toFixed(2);
                    applyPromo();
                } else {
                    subtotalEl.innerText = "0.00";
                    alert("Invalid Booking ID! Not found in database.");
                }
            })
            .catch(error => {
                console.error('Error fetching amount:', error);
                subtotalEl.innerText = "0.00";
            });
        }
    });

    function applyPromo() {
        let code = document.getElementById("promoInput").value.trim().toUpperCase();
        let messageEl = document.getElementById("promoMessage");
        let discountRow = document.getElementById("discountRow");

        if (code === "") {
            messageEl.innerHTML = "";
            resetCalculation();
            return;
        }

        if (validPromos[code]) {
            let discountPrc = validPromos[code];
            let discountVal = (baseAmount * discountPrc) / 100;
            let newTotal = baseAmount - discountVal;

            messageEl.innerHTML = "<span class='text-success fw-bold'>✔ Promo Applied! " + discountPrc + "% Off</span>";

            document.getElementById("discountPercent").innerText = discountPrc;
            document.getElementById("discountAmount").innerText = discountVal.toFixed(2);
            discountRow.style.setProperty("display", "flex", "important");

            document.getElementById("finalTotal").innerText = newTotal.toFixed(2);
        } else {
            messageEl.innerHTML = "<span class='text-danger fw-bold'>✖ Invalid or Expired Code</span>";
            resetCalculation();
        }
    }

    function resetCalculation() {
        document.getElementById("discountRow").style.setProperty("display", "none", "important");
        document.getElementById("finalTotal").innerText = baseAmount.toFixed(2);
    }
</script>
</body>
</html>