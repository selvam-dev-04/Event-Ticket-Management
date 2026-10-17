package event_management;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {

    private static final String URL =
            "jdbc:mysql://localhost:3306/event_ticket_management";

    public static Connection getConnection() throws SQLException {

        String username = System.getenv("DB_USER");
        String password = System.getenv("DB_PASSWORD");

        if (username == null || username.isBlank()
                || password == null || password.isBlank()) {
            throw new SQLException(
                    "Database credentials are missing. "
                    + "Please configure DB_USER and DB_PASSWORD."
            );
        }

        return DriverManager.getConnection(URL, username, password);
    }
}