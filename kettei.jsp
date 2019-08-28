<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
 import="java.io.*,java.util.*,java.text.*" %>

<html>
  <head>
    <meta http-equiv="refresh" content="1;URL=input.jsp">
    <title>カラオケ</title>
  </head>
  <body>
<%
  //次の曲（Volume.jspより）
  request.setCharacterEncoding("UTF-8");

  String cancel = request.getParameter("cancel");
  //write
  if (cancel != null) {
    FileWriter objFwC=new FileWriter(application.getRealPath("cancel"));
    BufferedWriter objBwC=new BufferedWriter(objFwC);
    objBwC.write("1\n");
    objBwC.close();
  }

  request.setCharacterEncoding("UTF-8");

  String strTxt = request.getParameter("filename");
  String volume = request.getParameter("volume");
  if (strTxt != null) {
    //strTxt = "'" + strTxt + "'";
    out.println("入力：" + strTxt + " / vol:" + volume + "：予約します");

    SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMddHHmmssSSS");

    File file = new File(application.getRealPath("que" + sdf.format(Calendar.getInstance().getTime())));
    file.setWritable(true);

    FileWriter objFr=new FileWriter(file);
    BufferedWriter objBr=new BufferedWriter(objFr);
    objBr.write(strTxt);
    objBr.write("\n");

    if (volume != null) {
      //write
      objBr.write(volume);
      objBr.write("\n");
    } else {
      objBr.write("70");
      objBr.write("\n");
    }

    objBr.close();
  }
 %>
    <br>
    <br>
    <a href="input.jsp">予約システムに移動</a>
  </body>
</html>
