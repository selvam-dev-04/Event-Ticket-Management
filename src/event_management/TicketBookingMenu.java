package event_management;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Date;
import java.time.LocalDate;
import java.util.Scanner;

public class TicketBookingMenu {

	public static void main(String[] args) {
	    Scanner sc = new Scanner(System.in);

	    System.out.print("Enter User ID: ");
	    int userId = Integer.parseInt(sc.nextLine());

	    bookTickets(sc, userId);
	}

    public static void bookTickets(Scanner sc, int userId) {

        String url =
            "jdbc:mysql://localhost:3306/event_ticket_management";
        String user = "root";
        String pass = "root";

        try (Connection con =
                 DriverManager.getConnection(url, user, pass)) {

            // Step 1: Display events
            String eventQuery =
                "SELECT event_id, event_name, event_date FROM events";

            System.out.println("\n===== AVAILABLE EVENTS =====");

            try (PreparedStatement ps =
                     con.prepareStatement(eventQuery);
                 ResultSet rs = ps.executeQuery()) {

                while (rs.next()) {
                    System.out.println(
                        rs.getInt("event_id") + " | " +
                        rs.getString("event_name") + " | " +
                        rs.getDate("event_date")
                    );
                }
            }

            System.out.print("\nEnter Event ID: ");
            int eventId = Integer.parseInt(sc.nextLine());

            // Step 2: Display available tickets
            String ticketQuery =
                "SELECT ticket_type_id, ticket_name, price, " +
                "available_quantity FROM ticket_types " +
                "WHERE event_id = ? AND available_quantity > 0";

            System.out.println("\n===== AVAILABLE TICKETS =====");

            try (PreparedStatement ps =
                     con.prepareStatement(ticketQuery)) {

                ps.setInt(1, eventId);

                try (ResultSet rs = ps.executeQuery()) {
                    boolean found = false;

                    while (rs.next()) {
                        found = true;

                        System.out.println(
                            "Ticket ID: " +
                            rs.getInt("ticket_type_id") +
                            " | " + rs.getString("ticket_name") +
                            " | Price: Rs." +
                            rs.getBigDecimal("price") +
                            " | Available: " +
                            rs.getInt("available_quantity")
                        );
                    }

                    if (!found) {
                        System.out.println(
                            "No available tickets for this event."
                        );
                        return;
                    }
                }
            }

            System.out.print("\nEnter Ticket Type ID: ");
            int ticketTypeId = Integer.parseInt(sc.nextLine());


            System.out.print("Enter Quantity: ");
            int quantity = Integer.parseInt(sc.nextLine());

            if (quantity <= 0) {
                System.out.println(
                    "Quantity must be greater than zero."
                );
                return;
            }

            // Step 3: Begin transaction
            con.setAutoCommit(false);

            try {
                // Check user exists
                String userQuery =
                    "SELECT user_id FROM users WHERE user_id = ?";

                try (PreparedStatement ps =
                         con.prepareStatement(userQuery)) {

                    ps.setInt(1, userId);

                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) {
                            con.rollback();
                            System.out.println(
                                "User ID does not exist."
                            );
                            return;
                        }
                    }
                }

                // Lock ticket row and check availability
                String checkQuery =
                    "SELECT price, available_quantity " +
                    "FROM ticket_types " +
                    "WHERE ticket_type_id = ? AND event_id = ? " +
                    "FOR UPDATE";

                BigDecimal price;
                int available;

                try (PreparedStatement ps =
                         con.prepareStatement(checkQuery)) {

                    ps.setInt(1, ticketTypeId);
                    ps.setInt(2, eventId);

                    try (ResultSet rs = ps.executeQuery()) {
                        if (!rs.next()) {
                            con.rollback();
                            System.out.println(
                                "Invalid ticket type for this event."
                            );
                            return;
                        }

                        price = rs.getBigDecimal("price");
                        available =
                            rs.getInt("available_quantity");
                    }
                }

                if (quantity > available) {
                    con.rollback();
                    System.out.println(
                        "Only " + available +
                        " tickets are available."
                    );
                    return;
                }

                BigDecimal totalAmount =
                    price.multiply(BigDecimal.valueOf(quantity));

                // Step 4: Insert booking
                String insertQuery =
                    "INSERT INTO bookings " +
                    "(user_id, ticket_type_id, booking_date, " +
                    "quantity, total_amount, booking_status) " +
                    "VALUES (?, ?, ?, ?, ?, ?)";

                int bookingId;

                try (PreparedStatement ps =
                         con.prepareStatement(
                             insertQuery,
                             Statement.RETURN_GENERATED_KEYS)) {

                    ps.setInt(1, userId);
                    ps.setInt(2, ticketTypeId);
                    ps.setDate(3, Date.valueOf(LocalDate.now()));
                    ps.setInt(4, quantity);
                    ps.setBigDecimal(5, totalAmount);
                    ps.setString(6, "Pending");

                    ps.executeUpdate();

                    try (ResultSet keys = ps.getGeneratedKeys()) {
                        if (!keys.next()) {
                            throw new SQLException(
                                "Booking ID was not generated."
                            );
                        }

                        bookingId = keys.getInt(1);
                    }
                }

                // Step 5: Update available quantity
                String updateQuery =
                    "UPDATE ticket_types " +
                    "SET available_quantity = available_quantity - ? " +
                    "WHERE ticket_type_id = ? AND event_id = ? " +
                    "AND available_quantity >= ?";

                try (PreparedStatement ps =
                         con.prepareStatement(updateQuery)) {

                    ps.setInt(1, quantity);
                    ps.setInt(2, ticketTypeId);
                    ps.setInt(3, eventId);
                    ps.setInt(4, quantity);

                    int rows = ps.executeUpdate();

                    if (rows != 1) {
                        throw new SQLException(
                            "Ticket availability changed. Try again."
                        );
                    }
                }

                // Step 6: Commit transaction
                con.commit();

                System.out.println("\n===== BOOKING SUCCESSFUL =====");
                System.out.println("Booking ID: " + bookingId);
                System.out.println("User ID: " + userId);
                System.out.println("Ticket Type ID: " + ticketTypeId);
                System.out.println("Quantity: " + quantity);
                System.out.println("Total Amount: Rs." + totalAmount);
                System.out.println("Booking Status: Pending");

            } catch (SQLException e) {
                con.rollback();
                throw e;
            }

        } catch (SQLException e) {
            System.out.println(
                "Booking failed: " + e.getMessage()
            );

        } catch (NumberFormatException e) {
            System.out.println(
                "Please enter valid numeric values."
            );
        }
    }
}
