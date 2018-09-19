package cn.edu.hdu.Controller;

import java.awt.Color;
import java.awt.Font;
import java.awt.Graphics2D;
import java.awt.font.FontRenderContext;
import java.awt.geom.Rectangle2D;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.util.Random;
import javax.imageio.ImageIO;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import org.apache.log4j.Logger;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/code")
public class SecCodeController{
	
	public static Logger log = Logger.getLogger(SecCodeController.class);
  
	@RequestMapping
	public void generate(HttpSession session, HttpServletResponse response){
	    response.setHeader("Pragma", "No-cache");
	    response.setHeader("Cache-Control", "no-cache");
	    response.setDateHeader("Expires", 0L);
	    response.setContentType("image/png");
	    
	    ByteArrayOutputStream output = new ByteArrayOutputStream();
	    String code = drawImg(output);
	    session.setAttribute("sessionSecCode", code);
	    try
	    {
	      ServletOutputStream out = response.getOutputStream();
	      output.writeTo(out);
	    }
	    catch (IOException e)
	    {
	      e.printStackTrace();
	    }
	}
  
	private String drawImg(ByteArrayOutputStream output){
	    String code = "";
	    for (int i = 0; i < 4; i++) {
	      code = code + randomChar();
	    }
	    int width = 70;
	    int height = 25;
	    BufferedImage bi = new BufferedImage(width, height, 5);
	    Font font = new Font("Times New Roman", 0, 20);
	    Graphics2D g = bi.createGraphics();
	    g.setFont(font);
	    Color color = new Color(66, 2, 82);
	    g.setColor(color);
	    g.setBackground(new Color(226, 226, 240));
	    g.clearRect(0, 0, width, height);
	    FontRenderContext context = g.getFontRenderContext();
	    Rectangle2D bounds = font.getStringBounds(code, context);
	    double x = (width - bounds.getWidth()) / 2.0D;
	    double y = (height - bounds.getHeight()) / 2.0D;
	    double ascent = bounds.getY();
	    double baseY = y - ascent;
	    g.drawString(code, (int)x, (int)baseY);
	    g.dispose();
	    try
	    {
	      ImageIO.write(bi, "png", output);
	    }
	    catch (IOException e)
	    {
	      e.printStackTrace();
	    }
	    return code;
	}
  
	private char randomChar(){
	    Random r = new Random();
	    String s = "ABCDEFGHJKLMNPRSTUVWXYZabcdefghijklmnprstuvwxyz0123456789";
	    return s.charAt(r.nextInt(s.length()));
	}
}
