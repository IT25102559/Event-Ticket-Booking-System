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

@WebServlet("/DeletePromoServlet")
public class DeletePromoServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {


        String code = request.getParameter("code");

        if (code != null && !code.trim().isEmpty()) {
            try (Connection con = DBConnection.getConnection()) {


                String query = "DELETE FROM promo_codes WHERE code = ?";
                PreparedStatement pst = con.prepareStatement(query);
                pst.setString(1, code);

                int rows = pst.executeUpdate();

                if (rows > 0) {

                     response.sendRedirect("admin_ui/manage_promos.jsp?msg=promo_deleted");
                } else {
                    response.sendRedirect("admin_ui/manage_promos.jsp?error=delete_failed");
                }

            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("admin_ui/manage_promos.jsp?error=system_error");
            }
        } else {
            response.sendRedirect("admin_ui/manage_promos.jsp");
        }
    }
}