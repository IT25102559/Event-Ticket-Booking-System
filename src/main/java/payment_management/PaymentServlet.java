package payment_management;

import user_management.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/PaymentServlet")
public class PaymentServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String bookingId = request.getParameter("bookingId");
        String promoCode = request.getParameter("promoCode");
        String cardName = request.getParameter("cardName");

        if(cardName == null) cardName = "Unknown";

        int discount = 0;

        try (Connection con = DBConnection.getConnection()) {


            if (promoCode != null && !promoCode.trim().isEmpty()) {
                String query = "SELECT discount_percentage FROM promo_codes WHERE code = ? AND status = 'Active'";
                PreparedStatement pst = con.prepareStatement(query);
                pst.setString(1, promoCode.toUpperCase());
                ResultSet rs = pst.executeQuery();

                if (rs.next()) {
                    discount = rs.getInt("discount_percentage");
                } else {
                    response.sendRedirect("../payment_ui/payment_form.jsp?error=invalid_promo");
                    return;
                }
            }


            String insertPayment = "INSERT INTO payments (booking_id, card_name, amount) VALUES (?, ?, ?)";
            PreparedStatement pstPayment = con.prepareStatement(insertPayment);
            pstPayment.setString(1, bookingId);
            pstPayment.setString(2, cardName);
            pstPayment.setDouble(3, 0.00);
            pstPayment.executeUpdate();


            try {
                String updateQuery = "UPDATE bookings SET payment_status = 'Paid' WHERE booking_id = ?";
                PreparedStatement updatePst = con.prepareStatement(updateQuery);
                updatePst.setString(1, bookingId);
                updatePst.executeUpdate();
            } catch (Exception ignored) {

            }


            response.sendRedirect("../payment_ui/payment_success.jsp?status=success&discount=" + discount);

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("../payment_ui/payment_form.jsp?error=system_error");
        }
    }
}