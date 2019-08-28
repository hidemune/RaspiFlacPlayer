<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
 import="java.io.*,java.util.*,java.text.*,java.nio.file.*" %>

<!DOCTYPE html>
<html lang="ja">
<head>
 <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
 <link rel="stylesheet" type="text/css" href="jcard.css" />
 <meta http-equiv="Pragma" content="no-cache">
 <meta http-equiv="Cache-Control" content="no-cache">
 <meta http-equiv="Expires" content="0">
<title>カラオケ</title>
</head>

<body id="iframe">
　【音量】<br>

<%
    String vol = "";
    FileReader objFr=new FileReader(application.getRealPath("volume"));
    BufferedReader objBr=new BufferedReader(objFr);
    String line = "";
    while((line = objBr.readLine()) != null){
      vol = line;
    }
    objBr.close();

  for(int i=100;i >= 0;i = i - 10){
    String num = "    " + i;
    num = num.substring(num.length()-4,num.length()).replace(" ","&nbsp;");
%>

<a href="input.jsp?volume=<%=i%>" target="_top">
<button type="button" name="volume" value="<%=i%>">
<font size="5" color="#333399"><%=num%></font>
</button>
<%
  if (vol.equals("" + i)) {
    out.println("★");
  }
%>
</a>
<br>

<%
  }
%>

<a href="kettei.jsp?cancel=1" target="_top">
<button type="button" name="cancel" value="1">
<br>
<br>
<font size="5" color="#333399">&nbsp;&nbsp;次の曲&nbsp;&nbsp;</font>
</button>

<br>
<br>

<a href="volume.jsp?stop=1">
<button type="button" name="stop" value="1">
<br>
<br>
<font size="5" color="#333399">&nbsp;&nbsp;動画再生終了&nbsp;&nbsp;</font>
</button>
<%
  request.setCharacterEncoding("UTF-8");

  String stop = request.getParameter("stop");
  //write
  if (stop != null) {
    FileWriter objFw=new FileWriter(application.getRealPath("stop"));
    BufferedWriter objBw=new BufferedWriter(objFw);
    objBw.write("1\n");
    objBw.close();
  }
%>



<br>
</body>
</html>


