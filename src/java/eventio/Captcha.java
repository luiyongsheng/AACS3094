/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package eventio;

import com.sun.image.codec.jpeg.JPEGCodec;
import com.sun.image.codec.jpeg.JPEGImageEncoder;
import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.io.IOException;
import java.io.PrintWriter;

import java.util.Random;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.logging.Level;
import java.util.logging.Logger;
/**
 *
 * @author sheng
 */
public class Captcha extends HttpServlet {
    
    public static String getHash(String password, String salt) {
        MessageDigest md = null;
        byte[] vsalt = null;
        if(salt != null) vsalt = salt.getBytes();
        try {
            md = MessageDigest.getInstance("SHA-256");
        } catch (NoSuchAlgorithmException ex) {
            Logger.getLogger(Captcha.class.getName()).log(Level.SEVERE, null, ex);
        }
        md.update(password.getBytes());

        byte byteData[] = (vsalt == null) ? md.digest() : md.digest(vsalt);

        //convert the byte to hex format method 1
        StringBuffer sb = new StringBuffer();
        for (int i = 0; i < byteData.length; i++) {
         sb.append(Integer.toString((byteData[i] & 0xff) + 0x100, 16).substring(1));
        }

        //convert the byte to hex format method 2
        StringBuffer hexString = new StringBuffer();
    	for (int i=0;i<byteData.length;i++) {
    		String hex=Integer.toHexString(0xff & byteData[i]);
   	     	if(hex.length()==1) hexString.append('0');
   	     	hexString.append(hex);
    	}
    	return hexString.toString();
    }
    
    public static final char[] chars = {
        '2','3','4','5','6','7','8','9','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p',
        'q','r','s','t','x','y','z'
    };
    
    public static String getRandomString() {
        StringBuffer buffer = new StringBuffer();
        Random random = new Random();
        for(int i =0; i < 6; i++) {
            buffer.append(chars[random.nextInt(chars.length)]);
        }
        return buffer.toString();
    }
    
    public static Color getRandomColor() {
        Random random = new Random();
        return new Color(random.nextInt(255), random.nextInt(255), random.nextInt(255));
    }
    
    public static Color getReversedColor(Color c) {
        return new Color(255 - c.getRed(), 255 - c.getGreen(), 255 - c.getBlue());
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try {
            String param = req.getParameter("hash");
            if(param.equals("t")) {
                resp.setContentType("text/plain");
                try (PrintWriter out = resp.getWriter()) {
                    out.write((String) req.getSession(true).getAttribute("captcha"));
                }
            }
        }
        catch (Exception e){
        resp.setContentType("image/jpeg");
        String randomStr = getRandomString();
        req.getSession(true).setAttribute("captcha", getHash(randomStr, null));
        int w = 120; int h = 40;
        Color c = getRandomColor();
        Color rev = getReversedColor(c);
        BufferedImage bi = new BufferedImage(w, h, BufferedImage.TYPE_INT_RGB);
        Graphics2D g = bi.createGraphics();
        g.setFont(new Font("Georgia", Font.BOLD, 26));
        g.setColor(c);
        g.fillRect(0, 0, w, h);
        g.setColor(rev);
        g.drawString(randomStr, 18, 20);
        Random random = new Random();
        for(int i = 0, n = random.nextInt(100); i < n; i++) {
            g.drawRect(random.nextInt(w), random.nextInt(h), 1,1);
            ServletOutputStream out = resp.getOutputStream();
            JPEGImageEncoder encoder = JPEGCodec.createJPEGEncoder(out);
            encoder.encode(bi);
            out.flush();
        }
        }
    }
    
    

}
