package event_management;

public class Event {
    protected String eventId;
    protected String eventName;
    protected String date;
    protected String location;

    public Event(String eventId, String eventName, String date, String location) {
        this.eventId = eventId;
        this.eventName = eventName;
        this.date = date;
        this.location = location;
    }


    public String getEventId() { return eventId; }
    public String getEventName() { return eventName; }
    public String getDate() { return date; }
    public String getLocation() { return location; }

    public String getEventDetails() {
        return eventId + "," + eventName + "," + date + "," + location;
    }
}