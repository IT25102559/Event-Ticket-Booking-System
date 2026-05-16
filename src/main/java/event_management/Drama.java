package event_management;

public class Drama {

    private String id;
    private String name;
    private String showDate;
    private String director;


    public Drama(String id, String name, String showDate, String director) {
        this.id = id;
        this.name = name;
        this.showDate = showDate;
        this.director = director;
    }


    public String getId() { return id; }
    public String getName() { return name; }
    public String getShowDate() { return showDate; }
    public String getDirector() { return director; }
}