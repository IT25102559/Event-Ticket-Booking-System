package controllers;

import services.UserManager;
import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. JSP එකෙන් එවන දත්ත අල්ලගැනීම
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        // 2. UserManager එක හරහා ඒවා නිවැරදිදැයි පරීක්ෂා කිරීම
        UserManager userManager = new UserManager();
        boolean isValidUser = userManager.authenticateUser(email, password);

        // 3. ප්‍රතිඵලය අනුව පිටු මාරු කිරීම
        if (isValidUser) {
            // ලොග් වීම සාර්ථක නම් Session එකක් හදලා කෙලින්ම Dashboard එකට යවනවා
            HttpSession session = request.getSession();
            session.setAttribute("loggedUser", email);
            response.sendRedirect("dashboard.jsp");
        } else {
            // ඊමේල් හෝ පාස්වර්ඩ් වැරදි නම් පමණක් පණිවිඩය පෙන්වනවා
            response.setContentType("text/html");
            PrintWriter out = response.getWriter();
            out.println("<h3 style='color:red; text-align:center;'>Invalid Email or Password! Please try again.</h3>");
            out.println("<div style='text-align:center;'><a href='login.jsp'>Go Back</a></div>");
        }
    }
}