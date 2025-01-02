import java.sql.*;
public class Metadane {
  public static void main(String[ ] argv) {
  System.out.println("Checking if Driver is registered with DriverManager.");
/*  try {
        Class.forName("org.postgresql.Driver");
  } catch (ClassNotFoundException cnfe) {
        System.out.println("Couldn't find the driver!");
        System.out.println("Let's print a stack trace, and exit.");
        cnfe.printStackTrace();
        System.exit(1);
  }
  System.out.println("Registered the driver ok, so let's make a connection.");
*/
  Connection c = null;
  try {
        String dbaseURL = "jdbc:postgresql://pleadingly-credible-owl.data-1.euc1.tembo.io/postgres";
        String username  = "postgres";
        String password  = "mPGUWC9zbxjWGNOK";
        c = DriverManager.getConnection (dbaseURL, username, password);
  } catch (SQLException se) {
        System.out.println("Couldn't connect: print out a stack trace and exit.");
        se.printStackTrace();
        System.exit(1);
  }
if (c != null) {
        System.out.println("Hooray! We connected to the database!");
        try {

            DatabaseMetaData md; // metadane
            // nalezy polaczyc sie z baza danych
                        md = c.getMetaData();


                        System.out.println("Database Product Name: "+md.getDatabaseProductName());
                        System.out.println("Database Product Version: "+md.getDatabaseProductVersion());
                        System.out.println("JDBC Driver: " + md.getDriverName());
                        System.out.println("Driver Version: " + md.getDriverVersion());
                        System.out.println("URL Database: " + md.getURL());
                        System.out.println("Logged User: " + md.getUserName());
                        md.supportsAlterTableWithAddColumn();
                        md.supportsAlterTableWithDropColumn();
                        md.supportsBatchUpdates();
                        md.supportsPositionedDelete();
                        md.supportsPositionedUpdate();
                        md.supportsTransactions();
                        md.supportsResultSetType(ResultSet.TYPE_SCROLL_INSENSITIVE);
                        md.supportsResultSetType(ResultSet.TYPE_SCROLL_SENSITIVE);

            Statement st = c.createStatement();
            ResultSet rs = st.executeQuery("SELECT fname,lname FROM lab11.osoba");
            while (rs.next())  {
                String fname = rs.getString("fname") ;
                String lname = rs.getString("lname") ;
                System.out.print("Columns returned ");
                System.out.println(fname+" "+lname) ;   }
            rs.close();
            st.close();    }
        catch(SQLException e)  {
            System.out.println("Blad podczas przetwarzania danych:"+e) ;  }
        }
        else
            System.out.println("We should never get here.");   }
}