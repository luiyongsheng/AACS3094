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
public class TicketController {
    public static int BuyTicket(eventio.domain.Ticket t) {
        return eventio.da.Ticket.addTicket(t);
    }
    
    public static eventio.domain.Ticket TicketLookup(int evnetid, int owner) {
        return eventio.da.Ticket.getTicket(evnetid, owner);
    }
    
    public static ArrayList<eventio.domain.Ticket> AllTickets(int eventid) {
        return eventio.da.Ticket.getTickets(eventid);
    }
    
}
