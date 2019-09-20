<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
 import="java.io.*,java.util.*,java.text.*,java.nio.file.*" %>
<%
  request.setCharacterEncoding("UTF-8");

  String artist = request.getParameter("artist");
  if (artist == null) {
    artist = "\t";
  }
  String title = request.getParameter("title");
  if (title == null) {
    title = "\t";
  }
  //保存
  String add0 = artist;
  String add1 = title;

  //write
  String filename=application.getRealPath("lyric");
  BufferedWriter objBw = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(filename),"UTF-8"));

  objBw.write(add0);
  objBw.write("\n");

  objBw.write(add1);
  objBw.write("\n");

  objBw.close();

  Thread.sleep(3000);
  
  filename=application.getRealPath("lyric");
  BufferedReader objBr = new BufferedReader(new InputStreamReader(new FileInputStream(filename),"UTF-8"));
  String line = "";
  while ((line = objBr.readLine()) != null) {
    out.println(line);
  }
  objBr.close();
%>
