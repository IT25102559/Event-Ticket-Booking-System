package admin_dashboard;

import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class AdminManager {

    private static final String FILE_PATH = System.getProperty("user.home") + File.separator + "stage_dramas.txt";

    public boolean deleteDrama(String dramaId) {
        List<String> lines = new ArrayList<>();
        boolean found = false;



        System.out.println("Attempting to delete ID: [" + dramaId + "]");

        try (BufferedReader br = new BufferedReader(new FileReader(FILE_PATH))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] parts = line.split(",");
                if (parts.length > 0) {
                    String fileId = parts[0].trim();
                    String inputId = dramaId.trim();

                    if (fileId.equals(inputId)) {
                        System.out.println("Match Found! Deleting: " + fileId);
                        found = true;
                    } else {
                        lines.add(line);
                    }
                }
            }
        } catch (IOException e) {
            System.out.println("Error reading file: " + e.getMessage());
            return false;
        }

        if (found) {
            try (BufferedWriter bw = new BufferedWriter(new FileWriter(FILE_PATH))) {
                for (String l : lines) {
                    bw.write(l);
                    bw.newLine();
                }
                return true;
            } catch (IOException e) {
                e.printStackTrace();
            }
        } else {
            System.out.println("No match found in the file for ID: " + dramaId);
        }
        return false;
    }

    public event_management.StageDrama getDramaById(String dramaId) {
        try (BufferedReader br = new BufferedReader(new FileReader(FILE_PATH))) {
            String line;
            while ((line = br.readLine()) != null) {
                String[] p = line.split(",");
                if (p.length >= 6 && p[0].trim().equals(dramaId.trim())) {
                    return new event_management.StageDrama(p[0], p[1], p[2], p[3], p[5]);
                }
            }
        } catch (IOException e) { e.printStackTrace(); }
        return null;
    }


    public boolean updateDrama(event_management.StageDrama updatedDrama) {
        List<String> lines = new ArrayList<>();
        boolean found = false;
        try (BufferedReader br = new BufferedReader(new FileReader(FILE_PATH))) {
            String line;
            while ((line = br.readLine()) != null) {
                if (line.startsWith(updatedDrama.getEventId() + ",")) {
                    lines.add(updatedDrama.getEventId() + "," + updatedDrama.getEventName() + "," +
                            updatedDrama.getDate() + "," + updatedDrama.getLocation() + ",StageDrama," + updatedDrama.getDirector());
                    found = true;
                } else {
                    lines.add(line);
                }
            }
        } catch (IOException e) { e.printStackTrace(); }

        if (found) {
            try (PrintWriter pw = new PrintWriter(new FileWriter(FILE_PATH))) {
                for (String l : lines) pw.println(l);
                return true;
            } catch (IOException e) { e.printStackTrace(); }
        }
        return false;
    }
}