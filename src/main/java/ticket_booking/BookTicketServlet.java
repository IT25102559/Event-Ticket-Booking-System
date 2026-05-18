package ticket_booking;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import user_management.DBConnection; // 👈 DB එකට දත්ත යවන්න මේක ඕනේ

@WebServlet("/BookTicketServlet")
public class BookTicketServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {


        HttpSession session = request.getSession();
        String loggedUser = (String) session.getAttribute("username");

        String customerName = request.getParameter("customerName");
        String dramaName = request.getParameter("dramaName");
        int seats = Integer.parseInt(request.getParameter("numberOfSeats"));
        double price = Double.parseDouble(request.getParameter("ticketCategory"));
        double totalPrice = seats * price; // 👈 මුළු ගාණ හැදෙන තැන

        String bookingId = "BKG-" + System.currentTimeMillis();


        Ticket newTicket = new Ticket(bookingId, customerName, dramaName, seats, price, loggedUser);
        BookingManager manager = new BookingManager();

        if (manager.saveBooking(newTicket)) {


            try (Connection con = DBConnection.getConnection()) {
                String query = "INSERT INTO bookings (booking_id, customer_name, drama_name, category_price, seats, total_amount) VALUES (?, ?, ?, ?, ?, ?)";
                PreparedStatement pst = con.prepareStatement(query);
                pst.setString(1, bookingId);
                pst.setString(2, customerName);
                pst.setString(3, dramaName);
                pst.setDouble(4, price);
                pst.setInt(5, seats);
                pst.setDouble(6, totalPrice);

                pst.executeUpdate(); // Database එකට ලියනවා!
            } catch (Exception e) {
                e.printStackTrace();
            }



            response.sendRedirect("booking_ui/book_ticket.jsp?success=true&price=" + totalPrice + "&bkg_id=" + bookingId);
        } else {
            response.sendRedirect("booking_ui/book_ticket.jsp?error=true");
        }
    }
}