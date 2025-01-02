import java.sql.*;
public class jdbc_ex01 {
  public static void main(String[] argv) {
  /*
  System.out.println("Sprawdzenie czy sterownik jest zarejestrowany w menadzerze");
  try {
    Class.forName("org.postgresql.Driver");
  } catch (ClassNotFoundException cnfe) {
    System.out.println("Nie znaleziono sterownika!");
    System.out.println("Wyduk sledzenia bledu i zakonczenie.");
    cnfe.printStackTrace();
    System.exit(1);
  }
  System.out.println("Zarejstrowano sterownik - OK, kolejny krok nawiazanie polaczenia z baza danych.");
  */
  Connection c = null;

  try {
    // Wymagane parametry polaczenia z baza danych:
    // Pierwszy - URL do bazy danych:
    //        jdbc:dialekt SQL:serwer(adres + port)/baza w naszym przypadku:
    //        jdbc:postgres://pascal.fis.agh.edu.pl:5432/baza
    // Drugi i trzeci parametr: uzytkownik bazy i haslo do bazy
    c = DriverManager.getConnection("jdbc:postgresql://pleadingly-credible-owl.data-1.euc1.tembo.io:5432/postgres",
                                    "postgres", "mPGUWC9zbxjWGNOK");
  } catch (SQLException se) {
    System.out.println("Brak polaczenia z baza danych, wydruk logu sledzenia i koniec.");
    se.printStackTrace();
    System.exit(1);
  }
  if (c != null) {
    System.out.println("Polaczenie z baza danych OK ! ");
    try {
      //  Wykonanie zapytania SELECT do bazy danych
      //  Wykorzystane elementy: prepareStatement(), executeQuery()
            //wydruk rekordow zawartych w zwroconym kursorze  ( zbior rekordow - ResultSet )
       PreparedStatement pst = c.prepareStatement("SELECT id, fname, lname FROM lab11.osoba",ResultSet.TYPE_SCROLL_SENSITIVE,ResultSet.CONCUR_UPDATABLE);
       ResultSet rs = pst.executeQuery();
       while (rs.next()) {

            String imie = rs.getString("fname");
            String nazwisko = rs.getString("lname");
            System.out.print("Zwrocone kolumny  ");
            System.out.println(imie+" "+nazwisko); }
       rs.close();
       pst.close();    }
     catch(SQLException e)  {
          System.out.println("Blad podczas przetwarzania danych:"+e); }
  }
    else
    System.out.println("Brak polaczenia z baza, dalsza czesc aplikacji nie jest wykonywana."); }
}