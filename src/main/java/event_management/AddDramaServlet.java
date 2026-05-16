package event_management;

import user_management.DBConnection;
import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

@WebServlet("/AddDramaServlet")
// 👇 Photo Upload කරන්න මේ කෑල්ල අනිවාර්යයි 👇
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
        maxFileSize = 1024 * 1024 * 10,       // 10MB
        maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class AddDramaServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String location = request.getParameter("location"); // ඔයා කලින් දාන්න කිව්ව කෑල්ල
        String id = request.getParameter("dramaId");
        String name = request.getParameter("dramaName");
        String date = request.getParameter("showDate");
        String director = request.getParameter("director");

        // 🌟 Photo එක අල්ලගෙන ඒක Save කරන කෑල්ල 🌟
        Part filePart = request.getPart("posterFile");
        String fileName = filePart.getSubmittedFileName();

        // Project එකේ 'images' folder එකට path එක හදාගන්නවා
        String uploadPath = getServletContext().getRealPath("") + File.separator + "images";
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir(); // Folder එක නැත්නම් අලුතින් හදනවා
        }

        // පින්තූරය Server එකේ සේව් කරනවා
        if(fileName != null && !fileName.isEmpty()) {
            filePart.write(uploadPath + File.separator + fileName);
        } else {
            fileName = "default.jpg"; // පින්තූරයක් දැම්මේ නැත්නම් සාමාන්‍ය එකක් දානවා
        }

        try (Connection con = DBConnection.getConnection()) {

            // 👇 Database Query එකට 'poster' කියන අලුත් Column එකත් එකතු කළා 👇
            String query = "INSERT INTO dramas (id, name, show_date, director, poster) VALUES (?, ?, ?, ?, ?)";
            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, id);
            pst.setString(2, name);
            pst.setString(3, date);
            pst.setString(4, director);
            pst.setString(5, fileName); // පින්තූරේ නම DB එකට යනවා

            int result = pst.executeUpdate();

            if (result > 0) {
                response.sendRedirect("admin_ui/manage_dramas.jsp");
            } else {
                response.sendRedirect("admin_ui/add_drama.jsp?error=true");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("admin_ui/add_drama.jsp?error=true");
        }
    }
}