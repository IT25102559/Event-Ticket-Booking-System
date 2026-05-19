package ticket_booking;

import user_management.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class BookingManager {


    public boolean saveBooking(Ticket ticket) {
        String query = "INSERT INTO bookings (booking_id, customer_name, drama_name, category_price, seats, total_amount, username) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(query)) {

            pst.setString(1, ticket.getBookingId());
            pst.setString(2, ticket.getCustomerName());
            pst.setString(3, ticket.getDramaName());
            pst.setDouble(4, ticket.getPrice());
            pst.setInt(5, ticket.getSeats());
            pst.setDouble(6, ticket.getSeats() * ticket.getPrice());
            pst.setString(7, ticket.getLoggedUser());

            int rows = pst.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }


    public List<Ticket> getUserBookings(String loggedUser) {
        List<Ticket> userBookings = new ArrayList<>();
        String query = "SELECT * FROM bookings WHERE username = ? ORDER BY booking_id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(query)) {

            pst.setString(1, loggedUser);
            ResultSet rs = pst.executeQuery();

            while (rs.next()) {
                Ticket ticket = new Ticket(
                        rs.getString("booking_id"),
                        rs.getString("customer_name"),
                        rs.getString("drama_name"),
                        rs.getInt("seats"),
                        rs.getDouble("category_price"),
                        rs.getString("username")
                );
                userBookings.add(ticket);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return userBookings;
    }


    public List<Ticket> getAllBookings() {
        List<Ticket> bookingList = new ArrayList<>();
        String query = "SELECT * FROM bookings ORDER BY booking_id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(query);
             ResultSet rs = pst.executeQuery()) {

            while (rs.next()) {
                Ticket ticket = new Ticket(
                        rs.getString("booking_id"),
                        rs.getString("customer_name"),
                        rs.getString("drama_name"),
                        rs.getInt("seats"),
                        rs.getDouble("category_price"),
                        rs.getString("username")
                );
                bookingList.add(ticket);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookingList;
    }


    public boolean updateBooking(String bookingId, String newCustomerName, int newSeats) {
        String query = "UPDATE bookings SET customer_name = ?, seats = ?, total_amount = (category_price * ?) WHERE booking_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(query)) {

            pst.setString(1, newCustomerName);
            pst.setInt(2, newSeats);
            pst.setInt(3, newSeats);
            pst.setString(4, bookingId);

            int rows = pst.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }


    public boolean deleteBooking(String bookingId) {
        String query = "DELETE FROM bookings WHERE booking_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(query)) {

            pst.setString(1, bookingId);
            int rows = pst.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }


    public int getBookedSeats(String dramaName, double price) {
        int totalBooked = 0;

        String query = "SELECT IFNULL(SUM(seats), 0) AS total_seats FROM bookings WHERE drama_name = ? AND category_price = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement pst = con.prepareStatement(query)) {

            pst.setString(1, dramaName);
            pst.setDouble(2, price);
            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                totalBooked = rs.getInt("total_seats");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return totalBooked;
    }
}