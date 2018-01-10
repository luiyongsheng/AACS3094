/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package eventio.da;

import eventio.Database;

import java.sql.SQLException;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author sheng
 */
public class Subscription {
    private static Database _db = new Database();
    
    public static boolean addSubscription(eventio.domain.Subscription s) {
       
       String sql = "INSERT INTO SUBSCRIPTION (ID, MEMBER, EXPIRY, PAID) VALUES(?,?,?,?)";
       try {
           
           _db.stmt = _db.conn.prepareStatement(sql);
           _db.stmt.setObject(1, s.getId());
           _db.stmt.setObject(2, s.getMember());
           _db.stmt.setObject(3, s.getExpiry());
           _db.stmt.setObject(4, s.isPaid());
           
           _db.stmt.executeUpdate();
           
           
           return true;
       } 
       catch(SQLException ex){
           Logger.getLogger(Member.class.getName()).log(Level.SEVERE, null, ex);
           return false;
       }
    }
    
    public static boolean pay(String username) {
        String sql = "UPDATE SUBSCRIPTION SET PAID=TRUE WHERE MEMBER='"+username+"'";
        try {
           _db.stmt = _db.conn.prepareStatement(sql);
           _db.stmt.executeUpdate();
           return true;
        }
        catch(SQLException e) {
            return false;
        }
    }
    
    public static eventio.domain.Subscription getLatestSubs(String username) {
       String sql = "select * from subscription where member='" + username +"' order by expiry desc fetch first 1 row only";
       try {
           
           _db.stmt = _db.conn.prepareStatement(sql);
           
           _db.rs = _db.stmt.executeQuery();
           eventio.domain.Subscription subs = new eventio.domain.Subscription();
           while(_db.rs.next()) {
               subs.setExpiry(_db.rs.getDate("expiry"));
               subs.setId(_db.rs.getString("id"));
               subs.setMember(_db.rs.getString("member"));
               subs.setPaid(_db.rs.getBoolean("paid"));
               
               return subs;
           }
       } 
       catch(SQLException ex){
           Logger.getLogger(Member.class.getName()).log(Level.SEVERE, null, ex);
           return null;
       }
       return null;
    }
    
    public static boolean deleteSubs(String username) {
        String sql = "DELETE FROM SUBSCRIPTION WHERE MEMBER=?";
        try {
           _db.stmt = _db.conn.prepareStatement(sql); 
           _db.stmt.setString(1, username);
           _db.stmt.executeUpdate();
           return true;
        }
        catch(SQLException ex) {
            return false;
        }
    }
    
}
