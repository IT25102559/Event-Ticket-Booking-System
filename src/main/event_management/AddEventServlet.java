package event_management;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/AddEventServlet")
public class AddEventServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String id = request.getParameter("eventId");
        String name = request.getParameter("eventName");
        String date = request.getParameter("date");
        String location = request.getParameter("location");
        String director = request.getParameter("director");


        StageDrama newDrama = new StageDrama(id, name, date, location, director);
        EventManager manager = new EventManager();


        if (manager.addEvent(newDrama)) {
            response.sendRedirect("event_ui/add_drama.jsp?success=true");
        } else {
            response.sendRedirect("event_ui/add_drama.jsp?error=true");
        }
    }
}