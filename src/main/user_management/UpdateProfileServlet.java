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

@WebServlet("/UpdateProfileServlet")
public class UpdateProfileServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {


        HttpSession session = request.getSession();
        String loggedUser = (String) session.getAttribute("username");

        if (loggedUser == null) {
            response.sendRedirect("user_ui/login.jsp?error=login_first");
            return;
        }


        String firstName = request.getParameter("firstName");
        String lastName = request.getParameter("lastName");
        String phone = request.getParameter("phone");
        String password = request.getParameter("password");

        try (Connection con = DBConnection.getConnection()) {


            if (password == null || password.trim().isEmpty()) {
                String query = "UPDATE users SET first_name = ?, last_name = ?, phone = ? WHERE email = ?";
                PreparedStatement pst = con.prepareStatement(query);
                pst.setString(1, firstName);
                pst.setString(2, lastName);
                pst.setString(3, phone);
                pst.setString(4, loggedUser);
                pst.executeUpdate();
            }

            else {
                String query = "UPDATE users SET first_name = ?, last_name = ?, phone = ?, password = ? WHERE email = ?";
                PreparedStatement pst = con.prepareStatement(query);
                pst.setString(1, firstName);
                pst.setString(2, lastName);
                pst.setString(3, phone);
                pst.setString(4, password);
                pst.setString(5, loggedUser);
                pst.executeUpdate();
            }


            response.sendRedirect("user_ui/profile.jsp?msg=updated");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("user_ui/profile.jsp?error=true");
        }
    }
}