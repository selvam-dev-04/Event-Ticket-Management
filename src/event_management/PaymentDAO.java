package event_management;
import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.time.LocalDate;
import java.util.UUID;

public class PaymentDAO	//DAO-->Data Access Object 
{

    public boolean makePayment(int bookingId, String paymentMethod) {

        String bookingQuery =
            "SELECT total_amount, booking_status FROM bookings WHERE booking_id = ?";

        String paymentQuery =
            "INSERT INTO payments " +
            "(booking_id, payment_date, amount, payment_method, " +
            "payment_status, transaction_reference) " +
            "VALUES (?, ?, ?, ?, ?, ?)";

        String updateBooking =
            "UPDATE bookings SET booking_status = 'Confirmed' " +
            "WHERE booking_id = ? AND booking_status = 'Pending'";

        try (Connection con = DBConnection.getConnection()) {

            con.setAutoCommit(false);

            try {
                BigDecimal amount;

                // Step 1: Check booking
                try (PreparedStatement ps =
                         con.prepareStatement(bookingQuery)) {

                    ps.setInt(1, bookingId);

                    try (ResultSet rs = ps.executeQuery()) {

                        if (!rs.next()) {
                            System.out.println("Booking ID not found.");
                            con.rollback();
                            return false;
                        }

                        if (!"Pending".equalsIgnoreCase(
                                rs.getString("booking_status"))) {
                            System.out.println(
                                "This booking is not pending payment.");
                            con.rollback();
                            return false;
                        }

                        amount = rs.getBigDecimal("total_amount");
                    }
                }

                // Step 2: Record simulated payment
                String transactionReference =
                    "DEMO-" + UUID.randomUUID()
                               .toString()
                               .substring(0, 8).toUpperCase();

                try (PreparedStatement ps =
                         con.prepareStatement(
                             paymentQuery,
                             Statement.RETURN_GENERATED_KEYS)) {

                    ps.setInt(1, bookingId);
                    ps.setDate(2, Date.valueOf(LocalDate.now()));
                    ps.setBigDecimal(3, amount);
                    ps.setString(4, paymentMethod);
                    ps.setString(5, "Successful");
                    ps.setString(6, transactionReference);

                    ps.executeUpdate();

                    try (ResultSet keys = ps.getGeneratedKeys()) {
                        if (keys.next()) {
                            System.out.println(
                                "Payment ID: " + keys.getInt(1));
                        }
                    }
                }

                // Step 3: Confirm the booking
                try (PreparedStatement ps =
                         con.prepareStatement(updateBooking)) {

                    ps.setInt(1, bookingId);

                    if (ps.executeUpdate() != 1) {
                        throw new java.sql.SQLException(
                            "Could not confirm booking.");
                    }
                }

                con.commit();

                System.out.println("\n===== PAYMENT SUCCESSFUL =====");
                System.out.println("Booking ID: " + bookingId);
                System.out.println("Amount: Rs." + amount);
                System.out.println("Payment Method: " + paymentMethod);
                System.out.println(
                    "Transaction Reference: " + transactionReference);
                System.out.println("Booking Status: Confirmed");
                System.out.println(
                    "Note: This is a simulated project payment.");

                return true;

            } catch (Exception e) {
                con.rollback();
                throw e;
            }

        } catch (Exception e) {
            System.out.println("Payment failed: " + e.getMessage());
            return false;
        }
    }
}
