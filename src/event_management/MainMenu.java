
package event_management;

import java.util.Scanner;

public class MainMenu {

    public static void main(String[] args) {

        Scanner sc = new Scanner(System.in);
        UserDAO userDAO = new UserDAO();

        // Step 1: Registration and Login Menu
        while (true) {

            System.out.println("\n================================");
            System.out.println(" EVENT TICKET MANAGEMENT SYSTEM");
            System.out.println("================================");
            System.out.println("1. Register");
            System.out.println("2. Login");
            System.out.println("3. Exit");
            System.out.print("Enter your choice: ");

            int accountChoice;

            try {
                accountChoice = Integer.parseInt(sc.nextLine());
            } catch (NumberFormatException e) {
                System.out.println("Please enter a valid number!");
                continue;
            }

            if (accountChoice == 1) {

                System.out.print("Enter Name: ");
                String name = sc.nextLine();

                System.out.print("Enter Email: ");
                String email = sc.nextLine();

                System.out.print("Enter Phone: ");
                String phone = sc.nextLine();

                System.out.print("Enter City: ");
                String city = sc.nextLine();

                System.out.print("Enter Password: ");
                String password = sc.nextLine();

                if (name.trim().isEmpty()
                        || email.trim().isEmpty()
                        || password.isEmpty()) {
                    System.out.println(
                        "Name, email and password are required!"
                    );
                    continue;
                }

                userDAO.registerUser(
                    name, email, phone, city, password
                );

            } else if (accountChoice == 2) {

                System.out.print("Enter Email: ");
                String email = sc.nextLine();

                System.out.print("Enter Password: ");
                String password = sc.nextLine();

                int userId = userDAO.loginUser(email, password);

                if (userId == -1) {
                    continue;
                }

                // Step 2: Main Menu after successful login
                boolean loggedIn = true;

                while (loggedIn) {

                    System.out.println("\n================================");
                    System.out.println(" MAIN MENU");
                    System.out.println(" Welcome! User ID: " + userId);
                    System.out.println("================================");
                    System.out.println("1. Book Tickets");
                    System.out.println("2. View Booking Details");
                    System.out.println("3. Make Payment");
                    System.out.println("4. Cancel Booking");
                    System.out.println("5. View Booking History");
                    System.out.println("6. Logout");
                    System.out.println("7. Exit");
                    System.out.print("Enter your choice: ");

                    int choice;

                    try {
                        choice = Integer.parseInt(sc.nextLine());
                    } catch (NumberFormatException e) {
                        System.out.println(
                            "Please enter a valid number!"
                        );
                        continue;
                    }

                    switch (choice) {

                        case 1:
                            // Use the logged-in user's ID
                            TicketBookingMenu.bookTickets(sc, userId);
                            break;

                        case 2:
                            System.out.print("Enter Booking ID: ");

                            try {
                                int bookingId =
                                    Integer.parseInt(sc.nextLine());

                                BookingDAO dao = new BookingDAO();
                                dao.viewBookingDetails(bookingId);

                            } catch (NumberFormatException e) {
                                System.out.println("Invalid Booking ID!");
                            }
                            break;

                        case 3:
                            try {
                                System.out.print("Enter Booking ID: ");
                                int bookingId =
                                    Integer.parseInt(sc.nextLine());

                                System.out.println("1. UPI");
                                System.out.println("2. Card");
                                System.out.println("3. Cash");
                                System.out.print("Choose payment method: ");

                                int paymentChoice =
                                    Integer.parseInt(sc.nextLine());

                                String method = null;

                                switch (paymentChoice) {
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
                                        System.out.println(
                                            "Invalid payment choice!"
                                        );
                                }

                                if (method != null) {
                                    PaymentDAO payment = new PaymentDAO();
                                    payment.makePayment(bookingId, method);
                                }

                            } catch (NumberFormatException e) {
                                System.out.println("Invalid input!");
                            }
                            break;

                        case 4:
                            System.out.print(
                                "Enter Booking ID to cancel: "
                            );

                            try {
                                int bookingId =
                                    Integer.parseInt(sc.nextLine());

                                BookingDAO dao = new BookingDAO();
                                dao.cancelBooking(bookingId);

                            } catch (NumberFormatException e) {
                                System.out.println("Invalid Booking ID!");
                            }
                            break;

                        case 5:
                            // Automatically use logged-in user's ID
                            BookingDAO dao = new BookingDAO();
                            dao.viewBookingHistory(userId);
                            break;

                        case 6:
                            System.out.println("Logged out successfully!");
                            loggedIn = false;
                            break;

                        case 7:
                            System.out.println(
                                "Thank you for using our system!"
                            );
                            sc.close();
                            return;

                        default:
                            System.out.println(
                                "Invalid choice! Try again."
                            );
                    }
                }

            } else if (accountChoice == 3) {

                System.out.println("Thank you for using our system!");
                sc.close();
                return;

            } else {
                System.out.println("Invalid choice!");
            }
        }
    }
}
