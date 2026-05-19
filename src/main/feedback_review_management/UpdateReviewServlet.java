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

@WebServlet("/UpdateReviewServlet")
public class UpdateReviewServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String id = request.getParameter("id");
        String dramaName = request.getParameter("drama_name");
        String ratingStr = request.getParameter("rating");
        String comment = request.getParameter("comment");

        try (Connection con = DBConnection.getConnection()) {

            String query = "UPDATE reviews SET drama_name=?, rating=?, comment=? WHERE id=?";
            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, dramaName);
            pst.setInt(2, Integer.parseInt(ratingStr));
            pst.setString(3, comment);
            pst.setInt(4, Integer.parseInt(id));

            int rows = pst.executeUpdate();

            if(rows > 0) {
                response.sendRedirect("event_ui/reviews.jsp?msg=updated");
            } else {
                response.sendRedirect("event_ui/reviews.jsp?error=update_failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("event_ui/reviews.jsp?error=system_error");
        }
    }
}