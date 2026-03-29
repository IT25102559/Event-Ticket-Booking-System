package controllers;

// මේ imports ටික තමයි අඩුවෙලා තිබුණේ
import models.Customer;
import services.UserManager;
import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

// මේකෙන් තමයි JSP එකයි මේ class එකයි සම්බන්ධ වෙන්නේ
@WebServlet("/RegisterServlet")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. JSP Form එකෙන් එවන දත්ත ටික අල්ලගැනීම
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String phone = request.getParameter("phone");

        // අලුත් Customer ට අලුත් ID එකක් හැදීම (දැනට වේලාව පාවිච්චි කරමු)
        String id = "CUST-" + System.currentTimeMillis();

        // 2. ඒ දත්ත වලින් Customer Object එකක් සෑදීම
        Customer newCustomer = new Customer(id, name, email, password, phone);

        // 3. UserManager එක හරහා Text File එකට සේව් කිරීම
        UserManager userManager = new UserManager();
        boolean isSaved = userManager.registerCustomer(newCustomer);

        // 4. පරිශීලකයාට පණිවිඩයක් පෙන්වීම
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        if (isSaved) {
            out.println("<h3 style='color:green; text-align:center;'>Registration Successful!</h3>");
            out.println("<div style='text-align:center;'><a href='register.jsp'>Go Back</a></div>");
        } else {
            out.println("<h3 style='color:red; text-align:center;'>Error in registration!</h3>");
        }
    }
}