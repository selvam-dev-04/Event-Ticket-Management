
package event_management;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.nio.charset.StandardCharsets;
import java.util.Scanner;

public class UserDAO {

    // Hash password using SHA-256
    private String hashPassword(String password) {

        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(
                password.getBytes(StandardCharsets.UTF_8)
            );

            StringBuilder hex = new StringBuilder();

            for (byte b : hash) {
                hex.append(String.format("%02x", b & 0xff));
            }

            return hex.toString();

        } catch (NoSuchAlgorithmException e) {
            throw new RuntimeException("Password hashing failed.", e);
        }
    }

    // User Registration
    public void registerUser(
            String name, String email, String phone,
            String city, String password) {

        String sql =
            "INSERT INTO users " +
            "(user_name, email, phone, city, registration_date, password_hash) " +
            "VALUES (?, ?, ?, ?, CURDATE(), ?)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, phone);
            ps.setString(4, city);
            ps.setString(5, hashPassword(password));

            ps.executeUpdate();

            System.out.println("Registration successful!");

        } catch (SQLException e) {
            if (e.getErrorCode() == 1062) {
                System.out.println("This email is already registered!");
            } else {
                System.out.println("Registration failed: " + e.getMessage());
            }
        }
    }

    // User Login: returns user ID when successful, otherwise -1
    public int loginUser(String email, String password) {

        String sql =
            "SELECT user_id, password_hash FROM users WHERE email = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    String savedHash = rs.getString("password_hash");

                    if (savedHash != null &&
                            savedHash.equals(hashPassword(password))) {

                        System.out.println("Login successful!");
                        return rs.getInt("user_id");
                    }
                }
            }

            System.out.println("Invalid email or password.");
            return -1;

        } catch (SQLException e) {
            System.out.println("Login failed: " + e.getMessage());
            return -1;
        }
    }

    // Registration and login test menu
    public static void main(String[] args) {

        Scanner sc = new Scanner(System.in);
        UserDAO dao = new UserDAO();

        while (true) {
            System.out.println("\n===== USER ACCOUNT =====");
            System.out.println("1. Register");
            System.out.println("2. Login");
            System.out.println("3. Exit");
            System.out.print("Enter choice: ");

            try {
                int choice = Integer.parseInt(sc.nextLine());

                if (choice == 1) {
                    System.out.print("Enter name: ");
                    String name = sc.nextLine();

                    System.out.print("Enter email: ");
                    String email = sc.nextLine();

                    System.out.print("Enter phone: ");
                    String phone = sc.nextLine();

                    System.out.print("Enter city: ");
                    String city = sc.nextLine();

                    System.out.print("Enter password: ");
                    String password = sc.nextLine();

                    if (name.trim().isEmpty() ||
                            email.trim().isEmpty() ||
                            password.isEmpty()) {
                        System.out.println(
                            "Name, email and password are required."
                        );
                        continue;
                    }

                    dao.registerUser(
                        name, email, phone, city, password
                    );

                } else if (choice == 2) {
                    System.out.print("Enter email: ");
                    String email = sc.nextLine();

                    System.out.print("Enter password: ");
                    String password = sc.nextLine();

                    int userId = dao.loginUser(email, password);

                    if (userId != -1) {
                        System.out.println("Welcome! User ID: " + userId);
                    }

                } else if (choice == 3) {
                    System.out.println("Thank you!");
                    break;

                } else {
                    System.out.println("Invalid choice!");
                }

            } catch (NumberFormatException e) {
                System.out.println("Please enter a valid number.");
            }
        }

        sc.close();
    }
}
