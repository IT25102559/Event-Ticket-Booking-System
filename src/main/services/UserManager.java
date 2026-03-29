package services;

import models.Customer;
import java.io.*;
import java.io.BufferedReader;
import java.io.FileReader;

public class UserManager {

    private static final String FILE_PATH = "users.txt";

    public boolean registerCustomer(Customer customer) {

        try (FileWriter fw = new FileWriter(FILE_PATH, true);
             BufferedWriter bw = new BufferedWriter(fw);
             PrintWriter out = new PrintWriter(bw)) {

            String userData = customer.getId() + "," +
                    customer.getName() + "," +
                    customer.getEmail() + "," +
                    customer.getPassword() + "," +
                    customer.getPhoneNumber();

            out.println(userData);
            return true;

        } catch (IOException e) {
            System.out.println("Error saving user: " + e.getMessage());
            return false;
        }
    }
    // CRUD: READ - Login වීම සඳහා පරිශීලකයාගේ දත්ත පරීක්ෂා කිරීම
    public boolean authenticateUser(String email, String password) {
        try (BufferedReader br = new BufferedReader(new FileReader(FILE_PATH))) {
            String line;
            // File එකේ පේළියෙන් පේළිය කියවනවා
            while ((line = br.readLine()) != null) {
                // කොමාවෙන් දත්ත ටික වෙන් කරගන්නවා (ID, Name, Email, Password, Phone)
                String[] userDetails = line.split(",");

                // දත්ත හරියට තියෙනවද කියලා බලනවා
                if (userDetails.length >= 4) {
                    String storedEmail = userDetails[2];    // 3 වෙනියට තියෙන්නේ Email එක
                    String storedPassword = userDetails[3]; // 4 වෙනියට තියෙන්නේ Password එක

                    // ගහපු Email එකයි Password එකයි, ෆයිල් එකේ තියෙන ඒවාට සමානද බලනවා
                    if (storedEmail.equals(email) && storedPassword.equals(password)) {
                        return true; // ගැලපෙනවා නම් True යවනවා (Login Successful)
                    }
                }
            }
        } catch (IOException e) {
            System.out.println("Error reading users file: " + e.getMessage());
        }
        return false; // ගැලපෙන්නේ නැත්නම් False යවනවා (Login Failed)
    }
}
