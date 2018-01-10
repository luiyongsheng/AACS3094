/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package eventio.controller;


import eventio.Captcha;
import java.sql.Date;
import java.util.Calendar;
import java.util.Random;

/**
 *
 * @author sheng
 */
public class SubscriptionController {
   
    public static void Subscribe(eventio.domain.Member m) {
        Random rnd = new Random(m.getId() + 4096 + System.currentTimeMillis());
        long rndSeed = rnd.nextLong();
        String id = Captcha.getHash(Long.toString(rndSeed) , m.getUsername());
       
        eventio.domain.Subscription sub = new eventio.domain.Subscription();
        sub.setId(id);
        sub.setPaid(false);
        sub.setMember(m.getUsername());
        Calendar cal = Calendar.getInstance();
        cal.add(Calendar.MONTH, 6);
        sub.setExpiry(new Date(cal.getTimeInMillis()));
        
        eventio.da.Subscription.addSubscription(sub);
   }
    
   public static eventio.domain.Subscription latestSubs(String username) {
       return eventio.da.Subscription.getLatestSubs(username);
   }
   
   public static boolean ProceedPayment(String username) {
       return eventio.da.Subscription.pay(username);
   }
}
