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

@WebServlet("/PromoServlet")
public class PromoServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {


         String code = request.getParameter("code");
         String discountStr = request.getParameter("discount");

        try (Connection con = DBConnection.getConnection()) {
            int discount = Integer.parseInt(discountStr);


            String query = "INSERT INTO promo_codes (code, discount_percentage, status) VALUES (?, ?, 'Active')";
            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, code.toUpperCase());
            pst.setInt(2, discount);

            pst.executeUpdate();


            response.sendRedirect("admin_ui/manage_promos.jsp?msg=success");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin_ui/manage_promos.jsp?error=db_error");
        }
    }
}