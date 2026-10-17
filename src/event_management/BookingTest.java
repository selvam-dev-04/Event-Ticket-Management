
package event_management;

import java.util.Scanner;

public class BookingTest {

    public static void main(String[] args) {

        Scanner sc = new Scanner(System.in);

        System.out.print("Enter Booking ID: ");
        int bookingId = sc.nextInt();

        BookingDAO dao = new BookingDAO();
        dao.viewBookingDetails(bookingId);

        sc.close();
    }
}










