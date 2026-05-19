package user_management;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;



@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {


        String email = request.getParameter("email");
        String password = request.getParameter("password");


        try (Connection con = DBConnection.getConnection()) {


            String query = "SELECT role FROM users WHERE email = ? AND password = ?";
            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, email);
            pst.setString(2, password);

            ResultSet rs = pst.executeQuery();

            if (rs.next()) {

                String role = rs.getString("role");


                HttpSession session = request.getSession();
                session.setAttribute("username", email);
                session.setAttribute("userRole", role);


                if ("Admin".equals(role)) {

                    response.sendRedirect("admin_ui/manage_dramas.jsp");
                } else {

                    response.sendRedirect("event_ui/view_dramas.jsp");
                }
            } else {

                response.sendRedirect("user_ui/login.jsp?error=invalid");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("user_ui/login.jsp?error=db_error");
        }
    }
}