package feedback_review_management;

import user_management.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/DeleteReviewServlet")
public class DeleteReviewServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("id");

        if (id != null && !id.trim().isEmpty()) {
            try (Connection con = DBConnection.getConnection()) {


                String query = "DELETE FROM reviews WHERE id = ?";
                PreparedStatement pst = con.prepareStatement(query);
                pst.setInt(1, Integer.parseInt(id));

                int rows = pst.executeUpdate();

                if (rows > 0) {
                    response.sendRedirect("event_ui/reviews.jsp?msg=deleted");
                } else {
                    response.sendRedirect("event_ui/reviews.jsp?error=delete_failed");
                }

            } catch (Exception e) {
                e.printStackTrace();
                response.sendRedirect("event_ui/reviews.jsp?error=system_error");
            }
        }
    }
}