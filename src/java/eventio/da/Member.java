package eventio.da;

import eventio.Database;
import java.sql.*;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 *
 * @author Lui Yong Sheng
 */
public class Member {
    private static Database _db = new Database();
    
            
    public static boolean addUser(eventio.domain.Member m) {
       
       String sql = "INSERT INTO MEMBER (ID, USERNAME, PASSWORD, MEMBERLEVEL, FIRSTNAME, LASTNAME, PICTURE) VALUES(?,?,?,?,?,?,?)";
       try {
           int rowcount = getRowCount();
           rowcount += 1;
           
           boolean collision = checkCollision(m.getUsername());
           if(collision == true) m.setUsername(m.getUsername() + "1");

           _db.stmt = _db.conn.prepareStatement(sql);
           _db.stmt.setObject(1, rowcount);
           _db.stmt.setObject(2, m.getUsername());
           _db.stmt.setObject(3, m.getPassword());
           _db.stmt.setObject(4, m.getMemberLevel());
           _db.stmt.setObject(5, m.getFirstName());
           _db.stmt.setObject(6, m.getLastName());
           _db.stmt.setObject(7, "");
           
           _db.stmt.executeUpdate();
           return true;
       } 
       catch(SQLException ex){
           Logger.getLogger(Member.class.getName()).log(Level.SEVERE, null, ex);
           return false;
       }
    }
    
    public static boolean removeUser(String username) {
        String sql = "DELETE FROM MEMBER WHERE USERNAME=?";
        
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
    
    public static boolean updateUser(eventio.domain.Member m) {
        String sql = "UPDATE MEMBER SET FIRSTNAME=?, LASTNAME=?, PASSWORD=?, PICTURE=? WHERE ID=?";
       try {
           
           _db.stmt = _db.conn.prepareStatement(sql);
           _db.stmt.setObject(1, m.getFirstName());
           _db.stmt.setObject(2, m.getLastName());
           _db.stmt.setObject(3, m.getPassword());
           _db.stmt.setObject(4, m.getPicture());
           _db.stmt.setObject(5, m.getId());
           
           _db.stmt.executeUpdate();
           return true;
       } 
       catch(SQLException ex){
           Logger.getLogger(Member.class.getName()).log(Level.SEVERE, null, ex);
           return false;
       }
    }
    
    public static eventio.domain.Member getUser(String username) {
        
        String sql = "select * from MEMBER where username='"+username+"'";
        eventio.domain.Member m = new eventio.domain.Member();
        try {
            _db.stmt =  _db.conn.prepareStatement(sql);
            
            _db.rs = _db.stmt.executeQuery();
            while(_db.rs.next()) {
            m.setId(_db.rs.getInt("id"));
            m.setUsername(_db.rs.getString("username"));
            m.setFirstName(_db.rs.getString("firstname"));
            m.setLastName(_db.rs.getString("lastname"));
            m.setMemberLevel(_db.rs.getInt("memberlevel"));
            m.setPassword(_db.rs.getString("password"));
            m.setPicture(_db.rs.getString("picture"));
            return m;
            }
        }
        catch(SQLException ex) {
           Logger.getLogger(Member.class.getName()).log(Level.SEVERE, m.getUsername(), ex);
           
            return null;
        }
        return null;
    }
    
    public static ArrayList<eventio.domain.Member> getUsers() {
        
        String sql = "SELECT * FROM MEMBER FETCH FIRST 300 ROWS ONLY";
        try {
            _db.stmt =  _db.conn.prepareStatement(sql);
            
            _db.rs = _db.stmt.executeQuery();
            
            ArrayList<eventio.domain.Member> list = new ArrayList<eventio.domain.Member>();
            while(_db.rs.next()) {
                eventio.domain.Member m = new eventio.domain.Member();
                m.setId(_db.rs.getInt("id"));
                m.setUsername(_db.rs.getString("username"));
                m.setFirstName(_db.rs.getString("firstname"));
                m.setLastName(_db.rs.getString("lastname"));
                m.setMemberLevel(_db.rs.getInt("memberlevel"));
                m.setPicture(_db.rs.getString("picture"));
                list.add(m);
            }
            return list;
        }
        catch(SQLException ex) {
            return null;
        }
    }
    
    private static int getRowCount() {
        
        String sql = "select max(id) from member";
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
    
    public static boolean checkCollision(String username) {
        
        String sql = "select username from member where username='"+username+"'";
        try {
            _db.stmt = _db.conn.prepareStatement(sql);
            
            _db.rs = _db.stmt.executeQuery();
            while(_db.rs.next()) {
                return _db.rs.getString("username").equals(username);
            }
        }
        catch(SQLException ex) {
            return false;
        }
        return false;
    }
}
