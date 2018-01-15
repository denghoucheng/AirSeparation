package cn.edu.hdu.Entity;

import javax.servlet.http.HttpSession;

public class SessionAndUser
{
  private String userID;
  private String sid;
  private HttpSession session;
  
  public String getUserID()
  {
    return this.userID;
  }
  
  public void setUserID(String userID)
  {
    this.userID = userID;
  }
  
  public String getSid()
  {
    return this.sid;
  }
  
  public void setSid(String sid)
  {
    this.sid = sid;
  }
  
  public HttpSession getSession()
  {
    return this.session;
  }
  
  public void setSession(HttpSession session)
  {
    this.session = session;
  }
}
