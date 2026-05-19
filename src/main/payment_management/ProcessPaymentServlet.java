package payment_management;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/ProcessPaymentServlet")
public class ProcessPaymentServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String bookingId = request.getParameter("bookingId");
        String cardNumber = request.getParameter("cardNumber");
        double amount = Double.parseDouble(request.getParameter("amount"));

        String paymentId = "PAY-" + System.currentTimeMillis();
        String status = "Success";

        Payment newPayment = new Payment(paymentId, bookingId, cardNumber, maskCardNumber(cardNumber), amount, status);
        PaymentManager manager = new PaymentManager();

        if (manager.processPayment(newPayment)) {
            response.sendRedirect("payment_ui/payment_success.jsp?payId=" + paymentId);
        } else {
            response.sendRedirect("payment_ui/payment_form.jsp?error=true");
        }
    }


    private String maskCardNumber(String cardNumber) {
        if (cardNumber.length() > 4) {
            return "**** **** **** " + cardNumber.substring(cardNumber.length() - 4);
        }
        return cardNumber;
    }
}