package feedback_review_management;

import user_management.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/ReviewServlet")
public class ReviewServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {



        request.setCharacterEncoding("UTF-8");


        HttpSession session = request.getSession();
        String userEmail = (String) session.getAttribute("username");


        if (userEmail == null) {
            response.sendRedirect("user_ui/login.jsp?error=login_first");
            return;
        }


        String dramaName = request.getParameter("drama_name");
        int rating = Integer.parseInt(request.getParameter("rating"));
        String comment = request.getParameter("comment");


        try (Connection con = DBConnection.getConnection()) {

            String query = "INSERT INTO reviews (user_email, drama_name, rating, comment) VALUES (?, ?, ?, ?)";
            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, userEmail);
            pst.setString(2, dramaName);
            pst.setInt(3, rating);
            pst.setString(4, comment);

            pst.executeUpdate();


            response.sendRedirect("event_ui/reviews.jsp?msg=success");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("event_ui/reviews.jsp?error=db_error");
        }
    }
}