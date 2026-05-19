package event_management;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class EventManager {

    private static final String FILE_PATH = System.getProperty("user.home") + File.separator + "stage_dramas.txt";

    public boolean addEvent(Event event) {
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(FILE_PATH, true))) {
            bw.write(event.getEventDetails());
            bw.newLine();
            return true;
        } catch (IOException e) {
            System.out.println("Error saving drama: " + e.getMessage());
            return false;
        }
    }
    public List<StageDrama> getAllDramas() {
        List<StageDrama> dramaList = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(new FileReader(FILE_PATH))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] details = line.split(",");

                if (details.length >= 6) {
                    if ("StageDrama".equals(details[4])) {
                        StageDrama drama = new StageDrama(details[0], details[1], details[2], details[3], details[5]);
                        dramaList.add(drama);
                    }
                }
            }
        } catch (IOException e) {
            System.out.println("Error reading dramas: " + e.getMessage());
        }
        return dramaList;
    }
}