/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package eventio.controller;

import java.util.ArrayList;

/**
 *
 * @author sheng
 */
public class EventController {
    
    public static boolean CreateEvent(eventio.domain.Event e) {
        
        return eventio.da.Event.addEvent(e);
    }

    public static eventio.domain.Event getEvent(int eventid) {
        return eventio.da.Event.getEvent(eventid);
    }

    public static ArrayList<eventio.domain.Event> getEventList() {
        return eventio.da.Event.getEvents();
    }
    
    public static boolean EditDescription(String desc, int id) {
        return eventio.da.Event.updateDesc(desc, id);
    }
    
    public static boolean RemoveEvent(int id) {
        return eventio.da.Event.deleteEvent(id) && eventio.da.Ticket.deleteAllTicket(id);
    }
}
