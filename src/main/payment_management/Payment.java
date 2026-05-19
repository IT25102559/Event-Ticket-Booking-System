package payment_management;

public class Payment {
    private String paymentId;
    private String bookingId;
    private String cardNumber;
    private String maskedCard; // මේක අලුතින් එකතු කළා
    private double amount;
    private String status;


    public Payment(String paymentId, String bookingId, String cardNumber, String maskedCard, double amount, String status) {
        this.paymentId = paymentId;
        this.bookingId = bookingId;
        this.cardNumber = cardNumber;
        this.maskedCard = maskedCard;
        this.amount = amount;
        this.status = status;
    }

    public String getPaymentId() { return paymentId; }
    public String getBookingId() { return bookingId; }
    public String getCardNumber() { return cardNumber; }
    public String getMaskedCard() { return maskedCard; }
    public double getAmount() { return amount; }
    public String getStatus() { return status; }

    public String toFileString() {
        return paymentId + "," + bookingId + "," + cardNumber + "," + maskedCard + "," + amount + "," + status;
    }
}