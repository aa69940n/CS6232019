package edu.pace;


import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * @author aawad
 * Sample of JDBC for MySQL
 *
 */

public class GroupProject {

    /**
     * @param args
     * @throws ClassNotFoundException
     * @throws SQLException
     * @throws ClassNotFoundException
     */
    public static void main(String args[]) throws SQLException, ClassNotFoundException {

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

            // Either the 2 following inserts are executed, or none of them are. This is atomicity.
            stmt.executeUpdate("insert into student values (5, 'stud1', 'addr1', 'A')");
            stmt.executeUpdate("insert into student values (6, 'stud2', 'addr2', 'B')");
        } catch (SQLException e) {
            System.out.println("A SQLException was thrown: " + e.getMessage());
            // For atomicity
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