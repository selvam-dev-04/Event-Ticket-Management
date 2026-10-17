
package event_management;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class BookingDAO {

    // View Booking Details
    public void viewBookingDetails(int bookingId) {

        String sql =
            "SELECT b.booking_id, u.user_name, e.event_name, " +
            "tt.ticket_name, b.booking_date, b.quantity, " +
            "b.total_amount, b.booking_status " +
            "FROM bookings b " +
            "JOIN users u ON b.user_id = u.user_id " +
            "JOIN ticket_types tt ON b.ticket_type_id = tt.ticket_type_id " +
            "JOIN events e ON tt.event_id = e.event_id " +
            "WHERE b.booking_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, bookingId);

            try (ResultSet rs = ps.executeQuery()) {

                if (rs.next()) {
                    System.out.println("\n===== BOOKING DETAILS =====");
                    System.out.println("Booking ID    : " +
                            rs.getInt("booking_id"));
                    System.out.println("User Name     : " +
                            rs.getString("user_name"));
                    System.out.println("Event Name    : " +
                            rs.getString("event_name"));
                    System.out.println("Ticket Type   : " +
                            rs.getString("ticket_name"));
                    System.out.println("Booking Date  : " +
                            rs.getDate("booking_date"));
                    System.out.println("Quantity      : " +
                            rs.getInt("quantity"));
                    System.out.println("Total Amount  : Rs." +
                            rs.getBigDecimal("total_amount"));
                    System.out.println("Status        : " +
                            rs.getString("booking_status"));
                } else {
                    System.out.println("Booking ID not found!");
                }
            }

        } catch (SQLException e) {
            System.out.println("Error retrieving booking: " +
                    e.getMessage());
        }
    }

    // Cancel Booking
    public void cancelBooking(int bookingId) {

        String selectSql =
            "SELECT ticket_type_id, quantity, booking_status " +
            "FROM bookings WHERE booking_id = ? FOR UPDATE";

        String updateBookingSql =
            "UPDATE bookings SET booking_status = 'Cancelled' " +
            "WHERE booking_id = ?";

        String updateTicketSql =
            "UPDATE ticket_types " +
            "SET available_quantity = available_quantity + ? " +
            "WHERE ticket_type_id = ?";

        try (Connection con = DBConnection.getConnection()) {

            con.setAutoCommit(false);

            try {
                int ticketTypeId;
                int quantity;
                String status;

                // Step 1: Find booking and lock its row
                try (PreparedStatement ps =
                         con.prepareStatement(selectSql)) {

                    ps.setInt(1, bookingId);

                    try (ResultSet rs = ps.executeQuery()) {

                        if (!rs.next()) {
                            con.rollback();
                            System.out.println("Booking ID not found!");
                            return;
                        }

                        ticketTypeId = rs.getInt("ticket_type_id");
                        quantity = rs.getInt("quantity");
                        status = rs.getString("booking_status");
                    }
                }

                // Step 2: Check booking status
                if ("Cancelled".equalsIgnoreCase(status)) {
                    con.rollback();
                    System.out.println(
                        "This booking is already cancelled!"
                    );
                    return;
                }

                if (!"Pending".equalsIgnoreCase(status)
                        && !"Confirmed".equalsIgnoreCase(status)) {
                    con.rollback();
                    System.out.println(
                        "This booking cannot be cancelled. Status: " +
                        status
                    );
                    return;
                }

                // Step 3: Update booking status
                try (PreparedStatement ps =
                         con.prepareStatement(updateBookingSql)) {

                    ps.setInt(1, bookingId);
                    ps.executeUpdate();
                }

                // Step 4: Restore ticket quantity
                try (PreparedStatement ps =
                         con.prepareStatement(updateTicketSql)) {

                    ps.setInt(1, quantity);
                    ps.setInt(2, ticketTypeId);

                    int rows = ps.executeUpdate();

                    if (rows != 1) {
                        throw new SQLException(
                            "Could not restore ticket quantity."
                        );
                    }
                }

                // Step 5: Save changes
                con.commit();

                System.out.println("\n===== BOOKING CANCELLED =====");
                System.out.println("Booking ID: " + bookingId);
                System.out.println("Restored Tickets: " + quantity);
                System.out.println("Status: Cancelled");

            } catch (SQLException e) {
                con.rollback();
                throw e;
            }

        } catch (SQLException e) {
            System.out.println("Error cancelling booking: " +
                    e.getMessage());
        }
        
    }

    // View Booking History
    public void viewBookingHistory(int userId) {

        String sql =
            "SELECT b.booking_id, e.event_name, " +
            "tt.ticket_name, b.booking_date, b.quantity, " +
            "b.total_amount, b.booking_status " +
            "FROM bookings b " +
            "JOIN ticket_types tt " +
            "ON b.ticket_type_id = tt.ticket_type_id " +
            "JOIN events e ON tt.event_id = e.event_id " +
            "WHERE b.user_id = ? " +
            "ORDER BY b.booking_id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {

                boolean found = false;

                System.out.println("\n===== BOOKING HISTORY =====");

                while (rs.next()) {
                    found = true;

                    System.out.println("------------------------------");
                    System.out.println("Booking ID   : " +
                            rs.getInt("booking_id"));
                    System.out.println("Event Name   : " +
                            rs.getString("event_name"));
                    System.out.println("Ticket Type  : " +
                            rs.getString("ticket_name"));
                    System.out.println("Booking Date : " +
                            rs.getDate("booking_date"));
                    System.out.println("Quantity     : " +
                            rs.getInt("quantity"));
                    System.out.println("Total Amount : Rs." +
                            rs.getBigDecimal("total_amount"));
                    System.out.println("Status       : " +
                            rs.getString("booking_status"));
                }

                if (!found) {
                    System.out.println(
                        "No booking history found for this user."
                    );
                }
            }

        } catch (SQLException e) {
            System.out.println(
                "Error retrieving booking history: " +
                e.getMessage()
            );
        }
    }

}
