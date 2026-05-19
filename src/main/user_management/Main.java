package user_management;

import java.sql.Connection;

public class Main {
    public static void main(String[] args) {
        System.out.println("Testing Database Connection...");


        Connection con = DBConnection.getConnection();

        if (con != null) {
            System.out.println("DataBase has connected");
        } else {
            System.out.println("DataBase hasn't connected");
        }
    }
}