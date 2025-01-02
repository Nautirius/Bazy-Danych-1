import java.sql.*;

public class lab11 {

    public static void main(String[] argv) {
        Connection connection = null;

        try {
            connection = DriverManager.getConnection(
                    "jdbc:postgresql://pleadingly-credible-owl.data-1.euc1.tembo.io:5432/postgres",
                    "postgres", "mPGUWC9zbxjWGNOK");

        } catch (SQLException se) {
            System.out.println("Brak polaczenia z baza danych, wydruk logu sledzenia i koniec.");
            se.printStackTrace();
            System.exit(1);
        }

        if (connection != null) {
            System.out.println("Polaczenie z baza danych OK!");

            // Testowanie dzialania programu
            try {
                // Zadanie 1
                System.out.println("Zadanie 1:");
                // wykladowca i kurs istnieja
                addLecturerToCourse(connection, 10, 4);
                addLecturerToCourse(connection, 11, 5);
                addLecturerToCourse(connection, 11, 4);

                // wykladowca i kurs nie istnieja - dodanie nowych
                addLecturerToCourse(connection, 12, 6);

                // Zadanie 2
                System.out.println("Zadanie 2:");
                // jedna osoba o danym nazwisku
                getCoursesByLecturerSurname(connection, "Maj");

                // dwie osoby o tym samym nazwisku
                getCoursesByLecturerSurname(connection, "Lipa");

                // kurs wykladowcy, ktory nie istnial w zadaniu 1
                getCoursesByLecturerSurname(connection, "Nazwisko");

            } catch (SQLException e) {
                System.out.println("Blad podczas przetwarzania danych: " + e.getMessage());
                e.printStackTrace();
            }
        } else {
            System.out.println("Brak polaczenia z baza, dalsza czesc aplikacji nie jest wykonywana.");
        }
    }

    public static void addLecturerToCourse(Connection connection, int lecturerId, int courseId) throws SQLException {
        try {
            connection.setAutoCommit(false);

            String checkLecturerQuery = "SELECT wykladowca_id FROM lab11.wykladowca WHERE wykladowca_id = ?";
            PreparedStatement checkLecturerStmt = connection.prepareStatement(checkLecturerQuery);
            checkLecturerStmt.setInt(1, lecturerId);
            ResultSet lecturerResult = checkLecturerStmt.executeQuery();

            if (!lecturerResult.next()) {
                System.out.println("Wykladowca nie istnieje. Dodawanie nowego wykladowcy.");
                String lecturerName = "Imie";
                String lecturerSurname = "Nazwisko";
                String insertLecturerQuery = "INSERT INTO lab11.wykladowca (wykladowca_id, imie, nazwisko, rok_zatrudnienia, wynagrodzenie, instytut_id) " +
                        "VALUES (?, ?, ?, 2024, 3000, 1)";
                PreparedStatement insertLecturerStmt = connection.prepareStatement(insertLecturerQuery);
                insertLecturerStmt.setInt(1, lecturerId);
                insertLecturerStmt.setString(2, lecturerName);
                insertLecturerStmt.setString(3, lecturerSurname);
                insertLecturerStmt.executeUpdate();
                insertLecturerStmt.close();
            }

            String checkCourseQuery = "SELECT kurs_id FROM lab11.kurs WHERE kurs_id = ?";
            PreparedStatement checkCourseStmt = connection.prepareStatement(checkCourseQuery);
            checkCourseStmt.setInt(1, courseId);
            ResultSet courseResult = checkCourseStmt.executeQuery();

            if (!courseResult.next()) {
                System.out.println("Kurs nie istnieje. Dodawanie nowego kursu.");
                String courseName = "Nazwa_Kursu";
                Date courseStart = Date.valueOf("2024-12-19");
                String insertCourseQuery = "INSERT INTO lab11.kurs (kurs_id, nazwa, start, koniec) VALUES (?, ?, ?, NULL)";
                PreparedStatement insertCourseStmt = connection.prepareStatement(insertCourseQuery);
                insertCourseStmt.setInt(1, courseId);
                insertCourseStmt.setString(2, courseName);
                insertCourseStmt.setDate(3, courseStart);
                insertCourseStmt.executeUpdate();
                insertCourseStmt.close();
            }

            String assignQuery = "INSERT INTO lab11.zajecia (wykladowca_id, kurs_id) VALUES (?, ?)";
            PreparedStatement assignStmt = connection.prepareStatement(assignQuery);
            assignStmt.setInt(1, lecturerId);
            assignStmt.setInt(2, courseId);
            assignStmt.executeUpdate();
            assignStmt.close();

            connection.commit();
            System.out.println("Wykladowca zostal przypisany do kursu pomyslnie.");
        } catch (SQLException e) {
            connection.rollback();
            throw e;
        } finally {
            connection.setAutoCommit(true);
        }
    }

    public static void getCoursesByLecturerSurname(Connection connection, String surname) throws SQLException {
        String findLecturersQuery = "SELECT wykladowca_id FROM lab11.wykladowca WHERE nazwisko = ?";
        PreparedStatement findLecturersStmt = connection.prepareStatement(findLecturersQuery);
        findLecturersStmt.setString(1, surname);
        ResultSet lecturersResult = findLecturersStmt.executeQuery();

        while (lecturersResult.next()) {
            int lecturerId = lecturersResult.getInt("wykladowca_id");
            System.out.println("Wykladowca ID: " + lecturerId);

            String callFunctionQuery = "SELECT * FROM lab11.get_courses_by_lecturer(?)";
            PreparedStatement callFunctionStmt = connection.prepareStatement(callFunctionQuery);
            callFunctionStmt.setInt(1, lecturerId);
            ResultSet coursesResult = callFunctionStmt.executeQuery();

            while (coursesResult.next()) {
                String courseName = coursesResult.getString("nazwa_kursu");

                Date startDate = coursesResult.getDate("data_rozpoczecia");

                boolean isFinished = coursesResult.getBoolean("czy_zakonczony");

                System.out.println("Kurs: " + courseName + ", Data rozpoczecia: " + startDate + ", Zakonczony: " + isFinished);
            }
            callFunctionStmt.close();
        }
        findLecturersStmt.close();
    }
}
