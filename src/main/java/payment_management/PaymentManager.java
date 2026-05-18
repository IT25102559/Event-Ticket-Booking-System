package payment_management;

import java.io.*;

public class PaymentManager {
    private static final String FILE_PATH = System.getProperty("user.home") + File.separator + "payments.txt";

    public boolean processPayment(Payment payment) {
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(FILE_PATH, true))) {
            bw.write(payment.toFileString());
            bw.newLine();
            return true;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }
}