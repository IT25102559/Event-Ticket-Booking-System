package event_management;

import user_management.DBConnection;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class DramaManager {


    public List<Drama> getAllDramas() {
        List<Drama> dramaList = new ArrayList<>();

        try (Connection con = DBConnection.getConnection()) {
            String query = "SELECT * FROM dramas";
            PreparedStatement pst = con.prepareStatement(query);
            ResultSet rs = pst.executeQuery();

            while (rs.next()) {
                Drama drama = new Drama(
                        rs.getString("id"),
                        rs.getString("name"),
                        rs.getString("show_date"),
                        rs.getString("director")
                );
                dramaList.add(drama);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return dramaList;
    }

    public boolean deleteDrama(String id) {
        try (java.sql.Connection con = user_management.DBConnection.getConnection()) {
            String query = "DELETE FROM dramas WHERE id = ?";
            java.sql.PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, id);


            return pst.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
}
