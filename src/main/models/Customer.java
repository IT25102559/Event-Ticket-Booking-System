package models;

public class Customer extends user {
    private String phoneNumber;

    public Customer(String id, String name, String email, String password, String phoneNumber) {
        super(id, name, email, password); // Parent class (User) එකේ constructor එකට data යවනවා
        this.phoneNumber = phoneNumber;
    }

    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }

    @Override
    public String getUserRole() {
        return "Customer";
    }
}