/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package eventio.da;

import eventio.Database;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Random;

/**
 *
 * @author sheng
 */
public class Ticket {
    
    private static Database _db = new Database();
    
    public static int addTicket(eventio.domain.Ticket t) {
        String sql = "INSERT INTO TICKET (ID, OWNER, EVENT, USED) VALUES(?,?,?,?)";
       try {
           Random rnd = new Random();
           int tid = Math.abs(rnd.nextInt());
           
           _db.stmt = _db.conn.prepareStatement(sql);
           _db.stmt.setObject(1, String.valueOf(tid));
           _db.stmt.setObject(2, t.getOwner());
           _db.stmt.setObject(3, t.getEventId());
           _db.stmt.setObject(4, false);
           
           _db.stmt.executeUpdate();
           return tid;
       } 
       catch(SQLException ex){
           return 0;
       }
    }
    
    public static eventio.domain.Ticket getTicket(int eventid, int owner) {
        String sql = "SELECT * FROM TICKET WHERE event=? AND owner=? FETCH FIRST 1 ROWS ONLY";
        eventio.domain.Ticket t = new eventio.domain.Ticket();
        try {
            _db.stmt =  _db.conn.prepareStatement(sql);
            _db.stmt.setInt(1, eventid);
            _db.stmt.setInt(2, owner);
            
            _db.rs = _db.stmt.executeQuery();
            while(_db.rs.next()) {
                t.setId(_db.rs.getString("id"));
                t.setOwner(owner);
                t.setEventId(eventid);
                t.setUsed(_db.rs.getBoolean("used"));
                return t;
            }
        }
        catch(SQLException ex) {
           
            return null;
        }
        return null;
    }
    
    public static ArrayList<eventio.domain.Ticket> getTickets(int eventid) {
        String sql = "SELECT * FROM TICKET WHERE event=? FETCH FIRST 300 ROWS ONLY";
        try {
            _db.stmt =  _db.conn.prepareStatement(sql);
            _db.stmt.setInt(1, eventid);
            _db.rs = _db.stmt.executeQuery();
            
            ArrayList<eventio.domain.Ticket> list = new ArrayList<eventio.domain.Ticket>();
            while(_db.rs.next()) {
                eventio.domain.Ticket o = new eventio.domain.Ticket();
                o.setId(_db.rs.getString("id"));
                o.setEventId(_db.rs.getInt("event"));
                o.setOwner(_db.rs.getInt("owner"));
                o.setUsed(_db.rs.getBoolean("used"));
                list.add(o);
            }
            return list;
        }
        catch(SQLException ex) {
            return null;
        }
    }
    
    public static boolean deleteAllTicket(int eventid) {
        String sql = "DELETE FROM TICKET WHERE event=?";
        
        try {
           _db.stmt = _db.conn.prepareStatement(sql); 
           _db.stmt.setInt(1, eventid);
           _db.stmt.executeLargeUpdate();
           return true;
        }
        catch(SQLException ex) {
            return false;
        }
    }
    
}
