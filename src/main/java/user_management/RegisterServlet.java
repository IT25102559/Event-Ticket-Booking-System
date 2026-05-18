package user_management;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;

@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String password = request.getParameter("password");


        String query = "INSERT INTO users (email, password, first_name, last_name, phone, role) VALUES (?, ?, ?, ?, ?, 'User')";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(query)) {

            pst.setString(1, email);
            pst.setString(2, password);
            pst.setString(3, firstName);
            pst.setString(4, lastName);
            pst.setString(5, phone);

            int rows = pst.executeUpdate();

            if (rows > 0) {
                response.sendRedirect("../user_ui/login.jsp?msg=registered");
            } else {
                response.sendRedirect("../user_ui/register.jsp?error=failed");
            }

        } catch (SQLException e) {
            e.printStackTrace(); // මේකෙන් ඇත්තම අවුල Console එකේ පෙන්වනවා
            response.sendRedirect("../user_ui/register.jsp?error=exception");
        }
    }
}