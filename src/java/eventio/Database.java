/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package eventio;

import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
/**
 *
 * @author sheng
 */
public class Database {
    
    private static final String[] dbCredentials = { "root", "toor", "jdbc:derby://localhost:1527/eventdata" };
    
    public Connection conn;
    public PreparedStatement stmt;
    public ResultSet rs;
    
    public Database(){
        try {
           conn = DriverManager.getConnection(dbCredentials[2],dbCredentials[0],dbCredentials[1]);
           
        }
        catch(SQLException ex) {
        }
    }
    
    public void shutDown() throws SQLException {
        if(conn != null) {
            try {
                conn.close();
            }
            catch(SQLException ex) {
                throw ex;
            }
        }
    }
}
