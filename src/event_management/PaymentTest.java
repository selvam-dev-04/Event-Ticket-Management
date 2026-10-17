
package event_management;

import java.util.Scanner;

public class PaymentTest {

    public static void main(String[] args) {

        Scanner sc = new Scanner(System.in);

        System.out.print("Enter Booking ID: ");
        int bookingId = sc.nextInt();
        sc.nextLine();

        System.out.println("1. UPI");
        System.out.println("2. Card");
        System.out.println("3. Cash");
        System.out.print("Choose payment method: ");

        int choice = sc.nextInt();

        String method;

        switch (choice) {
            case 1:
                method = "UPI";
                break;
            case 2:
                method = "Card";
                break;
            case 3:
                method = "Cash";
                break;
            default:
                System.out.println("Invalid choice!");
                sc.close();
                return;
        }

        PaymentDAO payment = new PaymentDAO();
        payment.makePayment(bookingId, method);

        sc.close();
    }
}
