package ticket_booking;

public class Ticket {
    private String bookingId;
    private String customerName;
    private String dramaName;
    private int seats;
    private double price;
    private String loggedUser;


    public Ticket(String bookingId, String customerName, String dramaName, int seats, double price, String loggedUser) {
        this.bookingId = bookingId;
        this.customerName = customerName;
        this.dramaName = dramaName;
        this.seats = seats;
        this.price = price;
        this.loggedUser = loggedUser;
    }

    public String getBookingId() { return bookingId; }
    public String getCustomerName() { return customerName; }
    public String getDramaName() { return dramaName; }
    public int getSeats() { return seats; }
    public double getPrice() { return price; }
    public String getLoggedUser() { return loggedUser; } // 👈 අලුත් Getter එක

    public String getBookingDetails() {

        return bookingId + "," + customerName + "," + dramaName + "," + seats + "," + price + "," + loggedUser;
    }

    }