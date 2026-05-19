package payment_management;

import user_management.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/GetAmountServlet")
public class GetAmountServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String bookingId = request.getParameter("bookingId");
        double amount = 0.0;

        try (Connection con = DBConnection.getConnection()) {


            String query = "SELECT total_amount FROM bookings WHERE booking_id = ?";

            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, bookingId);
            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                amount = rs.getDouble(1);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }


        response.setContentType("text/plain");
        PrintWriter out = response.getWriter();
        out.print(amount);
    }
}