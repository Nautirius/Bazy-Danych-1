import java.sql.Driver;
import java.sql.DriverManager;
import java.sql.DriverPropertyInfo;
import java.sql.SQLException;
import java.util.Arrays;

public class ConnDetail {
   public static void main(String[] args) {
    try {
      String serverName = "pleadingly-credible-owl.data-1.euc1.tembo.io";
      String dbase = "postgres";
      String url = "jdbc:postgresql://" + serverName +  "/" + dbase;
      Driver driver = DriverManager.getDriver(url);

      // Get available properties
      DriverPropertyInfo[] properties = driver.getPropertyInfo(url, null);
      for (int i=0; i < properties.length; i++) {
         // Property information
         String name = properties[i].name;
         boolean required = properties[i].required;
         String value = properties[i].value;
         String description = properties[i].description;
         String[] choices = properties[i].choices;
         System.out.println("Property : " + name + "\nRequired : " + required + "\nValue : " + value + "\nDescription : " + description + "\nChoices : " + (choices!=null?Arrays.asList(choices):null) + "\n");
        }
    } catch (SQLException e) {
       System.out.println("Could not retrieve database metadata " + e.getMessage());
    }

  }
}