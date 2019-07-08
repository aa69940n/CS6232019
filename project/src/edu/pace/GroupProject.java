package edu.pace;


import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * @author Alaa Awad
 * Sample of JDBC for MySQL
 *
 */

public class GroupProject {

    /**
     * @param args
     * @throws ClassNotFoundException
     * @throws SQLException
     */
    public static void main(String args[]) throws ClassNotFoundException, SQLException {

        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/test?useTimezone=true&serverTimezone=UTC",
                System.getenv("DBUSER"),
                System.getenv("DBPASSWORD")
        );
        // For atomicity
        conn.setAutoCommit(false);

        // For isolation
        conn.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);
        Statement stmt = null;
        try {
            // create statement object
            stmt = conn.createStatement();

            // The depot d1 is deleted from Depot and Stock.
            stmt.executeUpdate("DELETE FROM Stock WHERE dep_id='d1'");
            stmt.executeUpdate("DELETE FROM depot WHERE dep_id='d1'");

        } catch (SQLException e) {
            System.out.println("A SQLException was thrown: " + e.getMessage());

            // we only commit if all transactions were successful. atomicity
            conn.rollback();
            stmt.close();
            conn.close();
            return;
        }

        conn.commit();
        stmt.close();
        conn.close();
    }
}