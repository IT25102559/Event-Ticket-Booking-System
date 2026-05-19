package ticket_booking;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/UpdateBookingServlet")
public class UpdateBookingServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String bookingId = request.getParameter("booking_id");
        String customerName = request.getParameter("customerName");
        int seats = Integer.parseInt(request.getParameter("seats"));


        BookingManager manager = new BookingManager();
        boolean isUpdated = manager.updateBooking(bookingId, customerName, seats);

        if (isUpdated) {
            System.out.println("✅ Text File Updated Successfully!");
            response.sendRedirect("booking_ui/view_bookings.jsp?msg=updated");
        } else {
            System.out.println("❌ Text File Update Failed!");
            response.sendRedirect("booking_ui/view_bookings.jsp?error=update_failed");
        }
    }
}