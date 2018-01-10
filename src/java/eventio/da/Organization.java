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
public class Organization {
    private static Database _db = new Database();
    
    public static boolean addOrganization(eventio.domain.Organization o) {
        String sql = "INSERT INTO ORGANIZATION (ID, NAME, CONTACTNO) VALUES(?,?,?)";
       try {
           int rowcount = getRowCount();
           rowcount += 1;
           
           _db.stmt = _db.conn.prepareStatement(sql);
           _db.stmt.setObject(1, rowcount);
           _db.stmt.setObject(2, o.getName());
           _db.stmt.setObject(3, o.getContact());
           
           _db.stmt.executeUpdate();
           return true;
       } 
       catch(SQLException ex){
           return false;
       }
    }
    
    public static eventio.domain.Organization getOrganization(int orgId) {
        
        String sql = "select * from organization where id = ?";
        eventio.domain.Organization m = new eventio.domain.Organization();
        try {
            _db.stmt =  _db.conn.prepareStatement(sql);
            _db.stmt.setInt(1, orgId);
            
            _db.rs = _db.stmt.executeQuery();
            while(_db.rs.next()) {
                
            m.setId(_db.rs.getInt("id"));
            m.setName(_db.rs.getString("name"));
            m.setContact(_db.rs.getString("contactno"));
            return m;
            }
        }
        catch(SQLException ex) {
           
            return null;
        }
        return null;
    }
    
    public static ArrayList<eventio.domain.Organization> getOrganizations() {
        String sql = "SELECT * FROM ORGANIZATION FETCH FIRST 300 ROWS ONLY";
        try {
            _db.stmt =  _db.conn.prepareStatement(sql);
            
            _db.rs = _db.stmt.executeQuery();
            
            ArrayList<eventio.domain.Organization> list = new ArrayList<eventio.domain.Organization>();
            while(_db.rs.next()) {
                eventio.domain.Organization o = new eventio.domain.Organization();
                o.setId(_db.rs.getInt("id"));
                o.setContact(_db.rs.getString("contactno"));
                o.setName(_db.rs.getString("name"));
                list.add(o);
            }
            return list;
        }
        catch(SQLException ex) {
            return null;
        }
    }
    
    private static int getRowCount() {
        
        String sql = "select max(id) from organization";
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
