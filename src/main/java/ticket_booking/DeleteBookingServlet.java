package ticket_booking;

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

@WebServlet("/DeleteBookingServlet")
public class DeleteBookingServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {


        String id = request.getParameter("id");


        HttpSession session = request.getSession();
        String role = (String) session.getAttribute("userRole");


        String redirectUrl = "booking_ui/view_bookings.jsp";
        if ("Admin".equals(role)) {
            redirectUrl = "admin_ui/view_all_bookings.jsp";
        }

        if (id != null && !id.trim().isEmpty()) {


            BookingManager manager = new BookingManager();
            boolean isDeletedFromManager = manager.deleteBooking(id);


            boolean isDeletedFromDB = false;
            try (Connection con = DBConnection.getConnection()) {
                String query = "DELETE FROM bookings WHERE booking_id = ?";
                PreparedStatement pst = con.prepareStatement(query);
                pst.setString(1, id);
                int rows = pst.executeUpdate();
                if (rows > 0) {
                    isDeletedFromDB = true;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }


            if (isDeletedFromManager || isDeletedFromDB) {
                response.sendRedirect("../" + redirectUrl + "?msg=deleted");
            } else {
                response.sendRedirect("../" + redirectUrl + "?error=delete_failed");
            }

        } else {
            response.sendRedirect("../" + redirectUrl);
        }
    }
}