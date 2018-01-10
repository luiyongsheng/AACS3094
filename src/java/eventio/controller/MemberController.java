/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package eventio.controller;

import eventio.Captcha;
import java.util.ArrayList;
import java.util.List;



/**
 *
 * @author sheng
 */
public class MemberController {
    
    public static boolean Register(eventio.domain.Member m) {
        String passHash = Captcha.getHash(m.getPassword(), m.getUsername());
        m.setPassword(passHash);
        boolean reg = eventio.da.Member.addUser(m);
        eventio.controller.SubscriptionController.Subscribe(m);
        return reg;
    }
    
    public static boolean Login(String username, String password) {
        eventio.domain.Member m = eventio.da.Member.getUser(username);
        String passHash = Captcha.getHash(password, username);
        return (m.getPassword().equals(passHash));
    }
    
    public static eventio.domain.Member getMember(String username) {
        eventio.domain.Member m = eventio.da.Member.getUser(username);
        m.setPassword(null); // sanitizing data
        return m;
    }
    
    public static ArrayList<eventio.domain.Member> getMemberList() {
        return eventio.da.Member.getUsers();
    }
    
    public static boolean UpdateProfile(eventio.domain.Member m) {
        String passHash = Captcha.getHash(m.getPassword(), m.getUsername());
        m.setPassword(passHash);
        return eventio.da.Member.updateUser(m);
    }
    
    public static boolean Unsubscribe(String username) {
        return eventio.da.Member.removeUser(username) && eventio.da.Subscription.deleteSubs(username);
    }
}
