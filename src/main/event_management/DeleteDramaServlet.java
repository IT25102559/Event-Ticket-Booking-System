package event_management;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/DeleteDramaServlet")
public class DeleteDramaServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String id = request.getParameter("id");

        if (id != null && !id.trim().isEmpty()) {
            DramaManager manager = new DramaManager();
            boolean isDeleted = manager.deleteDrama(id);

            if (isDeleted) {
                response.sendRedirect("admin_ui/manage_dramas.jsp?msg=deleted");
            } else {
                response.sendRedirect("admin_ui/manage_dramas.jsp?error=delete_failed");
            }
        } else {
            response.sendRedirect("admin_ui/manage_dramas.jsp");
        }
    }
}