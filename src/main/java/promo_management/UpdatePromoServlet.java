package promo_management;

import user_management.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/UpdatePromoServlet")
public class UpdatePromoServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

         String originalCode = request.getParameter("originalCode");
        String newCode = request.getParameter("promoCode");
        String discountStr = request.getParameter("discount");
        String status = request.getParameter("status");

        try (Connection con = DBConnection.getConnection()) {
            int discount = Integer.parseInt(discountStr);


            String query = "UPDATE promo_codes SET code=?, discount_percentage=?, status=? WHERE code=?";
            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, newCode.toUpperCase());
            pst.setInt(2, discount);
            pst.setString(3, status);
            pst.setString(4, originalCode);

            int rows = pst.executeUpdate();

            if(rows > 0) {

                response.sendRedirect("admin_ui/manage_promos.jsp?msg=updated");
            } else {
                response.sendRedirect("admin_ui/manage_promos.jsp?error=update_failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin_ui/manage_promos.jsp?error=system_error");
        }
    }
}