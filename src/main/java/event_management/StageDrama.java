package event_management;

public class StageDrama extends Event {
    private String director;

    public StageDrama(String eventId, String eventName, String date, String location, String director) {
        super(eventId, eventName, date, location);
        this.director = director;
    }


    public String getDirector() { return director; }

    @Override
    public String getEventDetails() {
        return super.getEventDetails() + ",StageDrama," + director;
    }
}