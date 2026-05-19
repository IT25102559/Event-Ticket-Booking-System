package booking_history;

import ticket_booking.Ticket;
import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class BookingHistoryManager {
    // වැදගත්: Ticket Booking එකේ තියෙන ෆයිල් එකේ නමම මෙතනත් තියෙන්න ඕනේ
    private static final String FILE_PATH = System.getProperty("user.home") + File.separator + "bookings.txt";

    public List<Ticket> getAllBookings() {
        List<Ticket> history = new ArrayList<>();

        try (BufferedReader br = new BufferedReader(new FileReader(FILE_PATH))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] p = line.split(",");
                // 👈 මෙතන 4 වෙනුවට 5 කළා (දැන් ෆයිල් එකේ දත්ත 5ක් තියෙන නිසා)
                if (p.length >= 5) {
                    String id = p[0].trim();
                    String name = p[1].trim();
                    String drama = p[2].trim();
                    int seats = Integer.parseInt(p[3].trim());

                    // 👈 අලුතින් සේව් කරපු price එකත් ෆයිල් එකෙන් ගන්නවා
                    double price = Double.parseDouble(p[4].trim());


                }
            }
        } catch (IOException | NumberFormatException e) {
            System.out.println("Error reading booking history: " + e.getMessage());
        }

        return history;
    }
}