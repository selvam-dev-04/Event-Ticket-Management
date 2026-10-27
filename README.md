🎟️ Event Ticket Management System

🚀 A Java + MySQL Based Console Application

Manage events, book tickets, track payments, and handle bookings — all in one simple application!

---

📌 About the Project:-

The Event Ticket Management System is a console-based application developed using Java, JDBC, and MySQL. It simplifies event ticket booking by allowing users to register, log in, explore available events, book tickets, manage their bookings, and track payment status.

The application connects Java with a MySQL database using JDBC to store and manage user, event, ticket, booking, and payment information efficiently.

🎯 Project Goal: To build a practical database-driven application using Java, Object-Oriented Programming (OOP), JDBC, and SQL.

---

✨ Key Features:-


1.👤 User Registration & Login — Create an account and securely authenticate using password hashes.

2.🎫 Ticket Booking — Book tickets for available events. 

3.📅 Event Management — View event details and available ticket types.

4.💳 Payment Management — Record payment details and manage payment status using a simulated payment process.

5.📋 Booking Details — Retrieve booking information using a booking ID.

6.📚 Booking History — View previous bookings associated with the logged-in user.❌ Booking Cancellation — Cancel bookings and restore ticket availability.

7.🔄 Database Transactions — Maintain ticket availability and booking consistency during booking and cancellation.

8.🔐 Environment-Based Credentials — Read database credentials from environment variables instead of hardcoding them in Java source code.

---

🛠️ TECHNOLOGIES USED:-

☕ Java              - Application Development

🔌 JDBC              - Database Connectivity

🐬 MySQL             - Database Management

🧰 MySQL Workbench   - Database Design and Queries

💻 Eclipse IDE       - Development Environment

🌿 Git and GitHub    - Version Control

---

🗄️ Database Structure:-

The project uses a MySQL database named `event_ticket_management`.

📂 Main Tables:-

1. 👤 `users` — Stores user account details.
2. 🏢 `organizers` — Stores event organizer information.
3. 📍 `venues` — Stores event venue details.
4. 🎉 `events` — Stores event information.
5. 🎟️ `ticket_types` — Stores ticket categories, prices, and availability.
6. 📋 `bookings` — Stores booking details and booking status.
7. 💳 `payments` — Stores payment records and payment status.

---

⚙️ How to Run the Project

1️⃣ Requirements:-

Make sure you have installed:

- Java JDK
- Eclipse IDE
- MySQL Server
- MySQL Workbench
- MySQL JDBC Driver

2️⃣ Clone the Repository:-

git clone https://github.com/YOUR-USERNAME/Event-Ticket-Management-System.git

3️⃣ Import into Eclipse:-

1. Open Eclipse IDE.
2. Select "File → Import → Existing Projects into Workspace".
3. Choose the cloned project folder.
4. Click "Finish".

4️⃣ Set Up the Database:-

1. Open MySQL Workbench.
2. Create the database `event_ticket_management`.
3. Execute the project's SQL script to create the required tables.
4. Ensure the database tables and columns match the application code.

5️⃣ Configure Database Credentials

Set the following environment variables on your computer:

DB_USER=your_mysql_username
DB_PASSWORD=your_mysql_password

Replace the example values with your own MySQL credentials. Do not commit real passwords to GitHub.

6️⃣ Run the Application:-

1. Open `MainMenu.java` in Eclipse.
2. Right-click the file.
3. Select Run As → Java Application.
4. Register an account and log in to explore the available features.

---

🖥️ Application Menu:-


 EVENT TICKET MANAGEMENT SYSTEM

1. Register
2. Login
3. Exit
   
After logging in, users can access ticket booking, booking details, payment management, booking cancellation, and booking history.

---

🔒 Security & Notes:-

1. 🔑 Database credentials are loaded using environment variables.
2. 💳 Payments are simulated; no real payment gateway is integrated.
3. 🧪 This project is intended for learning and demonstration purposes.

---

```
CONFIGURE DATABASE CREDENTIALS:-

The application uses Windows environment variables to keep
database credentials outside the Java source code.

Follow these steps to configure them.

STEP 1: OPEN ENVIRONMENT VARIABLES

- Press the Windows key.
- Search for "Environment Variables".
- Open "Edit environment variables for your account".

STEP 2: CREATE THE DB_USER VARIABLE

- Under "User variables", click "New".
- Enter the following details:

  Variable name  : DB_USER
  Variable value : root

- Click OK.

Note: Replace "root" with your MySQL username if different.

STEP 3: CREATE THE DB_PASSWORD VARIABLE

- Under "User variables", click "New".
- Enter the following details:

  Variable name  : DB_PASSWORD
  Variable value : Your_MySQL_Password

- Replace "Your_MySQL_Password" with your actual MySQL
  password.
- Click OK.

IMPORTANT:
Do not write your actual password in this README file.
Set it only on your own computer.

STEP 4: SAVE THE SETTINGS

- Click OK on all open Environment Variables windows.
- Close Eclipse completely.
- Reopen Eclipse so it can read the new variables.

STEP 5: RUN THE APPLICATION

- Open the project in Eclipse.
- Open MainMenu.java.
- Right-click and select "Run As > Java Application".
- Register or log in to test the application.

```
---

🎓 Learning Outcomes:-

Through this project, I practised:

1. Java programming and OOP concepts.
2. JDBC database connectivity.
3. SQL queries and relational database design.
4. CRUD operations and transaction handling.
5. Exception handling and debugging.
6. Git and GitHub version control.

---

👨‍💻 Developed By

Mari Selvam E
🎯 Aspiring Software Developer | Java | JDBC | MySQL | HTML | CSS | JavaScript

💡 Learning, building, and improving one project at a time!

⭐ If you find this project useful, consider giving the repository a star!

