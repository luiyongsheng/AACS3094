/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package eventio.da;

import eventio.Database;
import java.sql.SQLException;
import java.util.ArrayList;

/**
 *
 * @author sheng
 */
public class Event {
    private static Database _db = new Database();
    
    public static boolean addEvent(eventio.domain.Event e) {
        String sql = "INSERT INTO EVENT (ID, EVENTNAME, EVENTPRICE, LOCATION, DESCRIPTION, ORGANIZER, EVENTDATE, EVENTTIME, CATEGORY) VALUES(?,?,?,?,?,?,?,?,?)";
       try {
           int rowcount = getRowCount();
           rowcount += 1;
           
           _db.stmt = _db.conn.prepareStatement(sql);
           _db.stmt.setObject(1, rowcount);
           _db.stmt.setObject(2, e.getEventName());
           _db.stmt.setObject(3, e.getPrice());
           _db.stmt.setObject(4, e.getLocation());
           _db.stmt.setObject(5, e.getDescription());
           _db.stmt.setObject(6, e.getOrganizer());
           _db.stmt.setObject(7, e.getEventDate());
           _db.stmt.setObject(8, e.getEventTime());
           _db.stmt.setObject(9, e.getCategory());
           
           _db.stmt.executeUpdate();
           return true;
       } 
       catch(SQLException ex){
           return false;
       }
    }

    public static eventio.domain.Event getEvent(int id) {
        String sql = "SELECT * FROM EVENT WHERE id="+id+" FETCH FIRST 1 ROWS ONLY";
        try {
            _db.stmt =  _db.conn.prepareStatement(sql);
            
            _db.rs = _db.stmt.executeQuery();
            
            while(_db.rs.next()) {
                eventio.domain.Event m = new eventio.domain.Event();
                m.setEventId(_db.rs.getInt("id"));
                m.setEventName(_db.rs.getString("eventname"));
                m.setPrice(_db.rs.getFloat("eventprice"));
                m.setLocation(_db.rs.getString("location"));
                m.setDescription(_db.rs.getString("description"));
                m.setEventDate(_db.rs.getDate("eventdate"));
                m.setEventTime(_db.rs.getTime("eventtime"));
                m.setCategory(_db.rs.getString("category"));
                m.setOrganizer(_db.rs.getInt("organizer"));
                return m;
            }
            return null;
        }
        catch(SQLException ex) {
            return null;
        }
    }

    public static ArrayList<eventio.domain.Event> getEvents() {
        
        String sql = "SELECT * FROM EVENT ORDER BY EVENTDATE DESC FETCH FIRST 300 ROWS ONLY";
        try {
            _db.stmt =  _db.conn.prepareStatement(sql);
            
            _db.rs = _db.stmt.executeQuery();
            
            ArrayList<eventio.domain.Event> list = new ArrayList<eventio.domain.Event>();
            while(_db.rs.next()) {
                eventio.domain.Event m = new eventio.domain.Event();
                m.setEventId(_db.rs.getInt("id"));
                m.setEventName(_db.rs.getString("eventname"));
                m.setPrice(_db.rs.getFloat("eventprice"));
                m.setLocation(_db.rs.getString("location"));
                m.setDescription(_db.rs.getString("description"));
                m.setEventDate(_db.rs.getDate("eventdate"));
                m.setEventTime(_db.rs.getTime("eventtime"));
                m.setCategory(_db.rs.getString("category"));
                list.add(m);
            }
            return list;
        }
        catch(SQLException ex) {
            return null;
        }
    }
    
    public static boolean updateDesc(String desc, int eventid) {
        String sql = "UPDATE EVENT SET DESCRIPTION = '"+desc+"' WHERE ID =" + eventid;
        
        try {
           _db.stmt = _db.conn.prepareStatement(sql); 
           _db.stmt.executeUpdate();
           return true;
        }
        catch(SQLException ex) {
            return false;
        }
    }
    
    public static boolean deleteEvent(int eventid) {
        String sql = "DELETE FROM EVENT WHERE id=?";
        
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
    
    
    private static int getRowCount() {
        
        String sql = "select max(id) from event";
        try {
            _db.stmt = _db.conn.prepareStatement(sql);
            _db.rs = _db.stmt.executeQuery();
            while(_db.rs.next()) {
                return _db.rs.getInt(1);
            }
        }
        catch (SQLException ex){
            return 0;
        }
        return 0;
    }
}
