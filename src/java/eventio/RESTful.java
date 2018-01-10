/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package eventio;

import com.google.gson.Gson;

import eventio.controller.EventController;
import eventio.controller.MemberController;
import eventio.controller.SubscriptionController;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.sql.Time;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.servlet.ServletException;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 *
 * @author Lui Yong Sheng
 */
public class RESTful extends HttpServlet {

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        //processRequest(request, response);
        String masterPath = request.getPathInfo();
        Map<String, String[]> paraMap = request.getParameterMap();
        try {
        if(masterPath.contains("/username")) {
            String username = paraMap.get("u")[0];
            try (PrintWriter out = response.getWriter()) {
                out.print(eventio.da.Member.checkCollision(username));
            }
        }
        else if(masterPath.contains("/users")) {
            response.setContentType("application/json;charset=utf-8");
            try(PrintWriter out = response.getWriter()) {
                out.print(new Gson().toJson(eventio.controller.MemberController.getMemberList()));
            }
        }
        else if(masterPath.contains("/user")) {
            String username = paraMap.get("n")[0];
            response.setContentType("application/json;charset=utf-8");
            try(PrintWriter out = response.getWriter()) {
                out.print(new Gson().toJson(eventio.controller.MemberController.getMember(username)));
            }
        }
        else if(masterPath.contains("/events")) {
            response.setContentType("application/json;charset=utf-8");
            try(PrintWriter out = response.getWriter()) {
                out.print(new Gson().toJson(eventio.controller.EventController.getEventList()));
            }
        }
        else if(masterPath.contains("/event")){
            String id = paraMap.get("e")[0];
            int eventid = Integer.parseInt(id);
            response.setContentType("application/json;charset=utf-8");
            try(PrintWriter out = response.getWriter()) {
                out.print(new Gson().toJson(eventio.controller.EventController.getEvent(eventid)));
            }
        }
        else if(masterPath.contains("/subs")){
            String username = paraMap.get("n")[0];
            response.setContentType("application/json;charset=utf-8");
            try(PrintWriter out = response.getWriter()) {
                out.print(new Gson().toJson(eventio.controller.SubscriptionController.latestSubs(username)));
            }
        }
        else if(masterPath.contains("/orgs")) {
            response.setContentType("application/json;charset=utf-8");
            try(PrintWriter out = response.getWriter()) {
                out.print(new Gson().toJson(eventio.controller.OrganizationController.getAllOrganization()));
            }
        }
        else if(masterPath.contains("/ticket")){
            String eid = paraMap.get("e")[0];
            int eventId = Integer.parseInt(eid);
            String username = paraMap.get("m")[0];
            
            eventio.domain.Member m = eventio.controller.MemberController.getMember(username);
            eventio.domain.Ticket t = eventio.controller.TicketController.TicketLookup(eventId, m.getId());
            
            response.setContentType("application/json;charset=utf-8");
            try(PrintWriter out = response.getWriter()) {
                out.print(new Gson().toJson(t));
            }
            
        }
        else if(masterPath.contains("/allTickets")) {
            String eid = paraMap.get("e")[0];
            int eventId = Integer.parseInt(eid);
            response.setContentType("application/json;charset=utf-8");
            try(PrintWriter out = response.getWriter()) {
                out.print(new Gson().toJson(eventio.controller.TicketController.AllTickets(eventId)));
            }
            
        }
        else if(masterPath.contains("/logout")) {
            Cookie[] cs = request.getCookies();
            for(Cookie c : cs) {
                c.setValue("");
                c.setMaxAge(0);
            }
            HttpSession sess = request.getSession();
            sess.removeAttribute("username");
            sess.removeAttribute("memberLevel");
            sess.removeAttribute("firstName");
            sess.removeAttribute("lastName");
            sess.removeAttribute("picture");
            
            response.sendRedirect("/Assignment");
        }
        else {
            try (PrintWriter out = response.getWriter()){
                out.print(new Gson().toJson("Hey dude, you're not supposed to be here."));
            }
        }
        }
        catch(Exception ex) {
            response.setContentType("application/json;charset=utf-8");
            try (PrintWriter out = response.getWriter()){
                out.print(new Gson().toJson("Parameter missing."));
            }
            
           Logger.getLogger(RESTful.class.getName()).log(Level.SEVERE, ex.getMessage(), ex);
        }
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        String masterPath = request.getPathInfo();
        Map<String, String[]> paraMap = request.getParameterMap();
        try {
        if(masterPath.contains("/login")) {
            String[] credentials = {
                paraMap.get("username")[0],
                paraMap.get("password")[0]
            };
            boolean auth = false;
            try {
                auth = eventio.controller.MemberController.Login(credentials[0], credentials[1]);
            }
            catch(Exception ex) {
                int attempts = 0;
                HttpSession sess = request.getSession();
                Object obj = sess.getAttribute("attempts");
                
                if(obj != null) {
                    attempts = (int)obj;
                }
                else {
                    sess.setAttribute("attempts", attempts);
                }
                
                if(attempts > 3) {
                    sess.setAttribute("lock", System.currentTimeMillis());
                }
                else {
                    attempts += 1;
                    sess.setAttribute("attempts", attempts);
                }
                
                response.sendRedirect("/Assignment/login.jsp?error=true");
            }
            if(auth == true) {
                eventio.domain.Member m = eventio.controller.MemberController.getMember(credentials[0]);
                HttpSession sess = request.getSession();
                sess.setAttribute("username", m.getUsername());
                sess.setAttribute("fistName", m.getFirstName());
                sess.setAttribute("lastName", m.getLastName());
                sess.setAttribute("memberLevel", m.getMemberLevel());
                sess.setAttribute("picture", m.getPicture());
                
                response.sendRedirect("/Assignment");
            }
            else {
                response.sendRedirect("/Assignment/login.jsp?error");
            }
        }
        else if(masterPath.contains("/register")) {
            
            eventio.domain.Member m = new eventio.domain.Member();
            m.setFirstName(paraMap.get("fistName")[0]);
            m.setLastName(paraMap.get("lastName")[0]);
            m.setUsername(paraMap.get("username")[0]);
            m.setPassword(paraMap.get("password")[0]);
            m.setMemberLevel(1);
            
            boolean exec = false;
            exec = eventio.controller.MemberController.Register(m);
            
            HttpSession sess = request.getSession();
            sess.setAttribute("username", m.getUsername());
            sess.setAttribute("fistName", m.getFirstName());
            sess.setAttribute("lastName", m.getLastName());
            sess.setAttribute("memberLevel", m.getMemberLevel());
            sess.setAttribute("picture", "");
            response.sendRedirect("/Assignment");
        }
        else if(masterPath.contains("/createOrg")){
            eventio.domain.Organization o = new eventio.domain.Organization();
            o.setName(paraMap.get("name")[0]);
            o.setContact(paraMap.get("contact")[0]);
            
            boolean exec = false;
            exec = eventio.controller.OrganizationController.CreateOrg(o);
        }
        else if(masterPath.contains("/createEvent")) {
            eventio.domain.Event ev = new eventio.domain.Event();
            String dateStr = paraMap.get("eventdate")[0];
            Date exactDate = Date.valueOf(dateStr);
            String timeStr = paraMap.get("eventtime")[0];
            String[] timeParts = timeStr.split(":");
            
            
            Time exactTime = Time.valueOf(timeParts[0] + ":"+timeParts[1] + ":00");
            
            ev.setEventName(paraMap.get("eventname")[0]);
            ev.setEventDate(exactDate);
            ev.setEventTime(exactTime);
            ev.setDescription(paraMap.get("description")[0]);
            ev.setLocation(paraMap.get("location")[0]);
            String priceStr = paraMap.get("price")[0];
            float price = Float.parseFloat(priceStr);
            ev.setPrice(price);
            String orgStr = paraMap.get("organization")[0];
            int org = Integer.parseInt(orgStr);
            ev.setOrganizer(org);
            ev.setLocation(paraMap.get("location")[0]);
            ev.setCategory(paraMap.get("category")[0]);
            
            boolean exec = false;
            exec = eventio.controller.EventController.CreateEvent(ev);
            response.sendRedirect("/Assignment/index.jsp");
        }
        else if(masterPath.contains("/editdesc")) {
            String desc = paraMap.get("desc")[0];
            String id = paraMap.get("id")[0];
            int eid = Integer.parseInt(id);
            boolean exec = false;
            exec = EventController.EditDescription(desc,eid);
            
        }
        else if(masterPath.contains("/buyticket")) {
            String eid = paraMap.get("e")[0];
            int eventId = Integer.parseInt(eid);
            
            HttpSession sess = request.getSession();
            String n = sess.getAttribute("username").toString();
            eventio.domain.Member m = eventio.controller.MemberController.getMember(n);
            eventio.domain.Ticket t = new eventio.domain.Ticket();
            t.setOwner(m.getId());
            t.setEventId(eventId);
            int ticket = 0;
            ticket = eventio.controller.TicketController.BuyTicket(t);
            try (PrintWriter out = response.getWriter()){
                out.print(ticket);
            }
            
        }
        else if(masterPath.contains("/delEvent")) {
            String id = paraMap.get("e")[0];
            int eid = Integer.parseInt(id);
            boolean exec = false;
            exec = eventio.controller.EventController.RemoveEvent(eid);
            
            try (PrintWriter out = response.getWriter()){
                out.print(exec);
            }
        }
        else if(masterPath.contains("/updateProfile")) {
            
            eventio.domain.Member m = new eventio.domain.Member();
            m.setFirstName(paraMap.get("fistName")[0]);
            m.setLastName(paraMap.get("lastName")[0]);
            m.setPassword(paraMap.get("password")[0]);
            m.setUsername(paraMap.get("username")[0]);
            String[] pic = paraMap.get("picture");
            if(pic != null) m.setPicture(pic[0]);
            m.setId(Integer.parseInt(paraMap.get("id")[0]));
            
            boolean exec = eventio.controller.MemberController.UpdateProfile(m);
            if(exec == true) response.sendRedirect("/Assignment/profile.jsp");
            else response.sendRedirect("/Assignment/profile.jsp?error=true");
        }
        else if(masterPath.contains("/pay")) {
            String id = paraMap.get("n")[0];
            boolean exec = false;
            exec = SubscriptionController.ProceedPayment(id);
            
            try (PrintWriter out = response.getWriter()){
                out.print(exec);
            }
        }
        else if(masterPath.contains("/unsubs")) {
            String id = paraMap.get("n")[0];
            boolean exec = false;
            exec = MemberController.Unsubscribe(id);
            
            try (PrintWriter out = response.getWriter()){
                out.print(exec);
            }
        }
        }catch(Exception ex) {
        
        }
    }
    
    
    // </editor-fold>
}
