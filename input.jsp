<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"
 import="java.lang.*,java.io.*,java.util.*,java.text.*,java.nio.file.*" %>
<!DOCTYPE html>
<html lang="ja">
<head>
 <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
 <link rel="stylesheet" type="text/css" href="jcard.css?ver=201908132111" />
 <meta http-equiv="Pragma" content="no-cache">
 <meta http-equiv="Cache-Control" content="no-cache">
 <meta http-equiv="Expires" content="0">
 <meta http-equiv="content-style-type" content="text/css">
 <meta http-equiv="Content-Script-Type" content="text/javascript">
    <title>再生</title>
</head>
<body>
<script src="jquery.min.js"></script>
<script>
function submitForm(filename, vol, buttonid, oops) {
    $("button#" + buttonid).attr("disabled","true"); 
    //alert("予約 : " + filename);
    //alert(vol);<%@ page contentType="text/html; charset=UTF-8" %>
    var http = new XMLHttpRequest();
    http.open("POST", "kettei.jsp", true);
    http.setRequestHeader("Content-type","application/x-www-form-urlencoded");
    var params = "filename=" + encodeURIComponent(filename) + "&volume=" + vol + "&effect=" + oops ;
    http.send(params);
    http.onload = function() {
        //alert(http.responseText);
    }
}
function getLyric(artist, song) {
    //var ev = $("#pop11").get(0).onclick;
    //$("#pop11").get(0).onclick = "";
    
    $('input[name=modalPop]').attr('checked',false);
	$("#pop11").attr("checked", false);
	$("#pop12").attr("checked", false);
	$("#pop13").attr("checked", false);
   var ele = document.getElementsByName("modalPop");
   for(var i=0;i<ele.length;i++)
      ele[i].checked = false;
      
    setTimeout(function() {
    var http = new XMLHttpRequest();
    http.open("POST", "lyric.jsp", true);
    http.setRequestHeader("Content-type","application/x-www-form-urlencoded");
    var params = "artist=" + encodeURIComponent(artist) + "&title=" + encodeURIComponent(song) ;
    http.send(params);
    http.onload = function() {
    	try {
		k = ("\n---\n");
		var reta = http.responseText.split(k,2);
		var tita = reta[0].trim().split("\n",2)
		$(".modalTitle").html(tita[0] + "<br>" + tita[1]);
		
		if (reta[1].trim() != "" ) {
	        	$(".modalMain").html("<pre>\n" + reta[1].replace("&amp;","&") + "\n</pre>");
		} else {
			$(".modalMain").html("<p>歌詞の取得に失敗しました。</p>");
		}        	
	} catch (e) {
		$(".modalTitle").html("<p>Lyric</p>");
		$(".modalMain").html("<p>歌詞の取得に失敗しました!!</p>");
	}
	$("#pop11").attr("checked", true);
	   var ele = document.getElementById("pop11");
      	   ele.checked = true;
    }
    }, 500);
    
  //var win = window.open("https://search.yahoo.co.jp/search?p=" + encodeURIComponent("歌詞 " + artist + " " + song) + "&ei=UTF-8", '_blank');
  //win.focus();
}
</script>
<div id="header"><!-- ここはヘッダです -->

    <form method="GET" action="input.jsp">
<a href="input.jsp" target="_top">
<%
  //write
  FileWriter objFwS=new FileWriter(application.getRealPath("start"));
  BufferedWriter objBwS=new BufferedWriter(objFwS);
  objBwS.write("1");
  objBwS.close();

  int idx = 1;
  File dir = new File(application.getRealPath("."));
  File[] files = dir.listFiles();
  if (files != null) {
    Arrays.sort(files);
    for (int i = 0; i < files.length; i++) {
      File file = files[i];
      //out.println(file.toString());
      //out.println("<br>");
      if (file.toString().startsWith(application.getRealPath("./que"))) {
        if (file.exists()) {
          BufferedReader objBr = new BufferedReader(new InputStreamReader(new FileInputStream(file),"UTF-8"));
          String line = "";
          while((line = objBr.readLine()) != null){
            out.println((idx) + ":" + line.substring(line.lastIndexOf("/")+1,line.length()) + "<br>");
            idx++;
            break;
          }
          objBr.close();
        }
      }
    }
  } else {
    out.println("Empty...");
  }
%>
</a>
<%
  request.setCharacterEncoding("UTF-8");

  String volume = request.getParameter("volume");
  if (volume != null) {
    //write
    FileWriter objFw=new FileWriter(application.getRealPath("volume"));
    BufferedWriter objBw=new BufferedWriter(objFw);
    objBw.write(volume);
    objBw.close();
  }
  String strTxt0 = request.getParameter("textfield0");
  if (strTxt0 == null) {
    strTxt0 = "\t";
  }
  String strTxt1 = request.getParameter("textfield1");
  if (strTxt1 == null) {
    strTxt1 = "\t";
  }
  String strTxt2 = request.getParameter("textfield2");
  if (strTxt2 == null) {
    strTxt2 = "\t";
  }
  if ((strTxt0 + strTxt1 + strTxt2).equals("\t\t\t")) {
    strTxt0 = "\n";
  }
  //out.println("入力：" + strTxt0 + "：" + strTxt1 + "：" + strTxt2 + "：検索します<br>");
  //保存
  String add0 = strTxt0;
  String add1 = strTxt1;
  String add2 = strTxt2;

    String[] rrk = new String[20];
    File file=new File(application.getRealPath("rireki"));
    BufferedReader objBr = new BufferedReader(new InputStreamReader(new FileInputStream(file),"UTF-8"));

    String line = "";
    int i = 0;
    while((line = objBr.readLine()) != null){
      if ((!(line.equals(add0))) && (!(line.equals(add1))) && (!(line.equals(add2)))) {
        if ("".equals(line.trim())) {
          //OK
        }else{
          rrk[i] = line;
          i++;
          if (i == 19) {
            break;
          }
        }
      }
    }
    objBr.close();
    //write
    file=new File(application.getRealPath("rireki"));
    BufferedWriter objBw = new BufferedWriter(new OutputStreamWriter(new FileOutputStream(file),"UTF-8"));

    if (add0.trim().equals("")) {
      //no
    }else {
      objBw.write(add0);
      objBw.write("\n");
    }
    if (add1.trim().equals("")) {
      //no
    }else {
      objBw.write(add1);
      objBw.write("\n");
    }
    if (add2.trim().equals("")) {
      //no
    }else {
      objBw.write(add2);
      objBw.write("\n");
    }
    for (int j = 0; j < rrk.length; j++) {
      if (rrk[j] == null) {
        break;
      }
      if ("".equals(rrk[j])) {
        break;
      }
      objBw.write(rrk[j]);
      objBw.write("\n");
    }
    objBw.close();
%>



<!-- %=volume% -->
</div><!-- id="header" ここまでヘッダです -->


<div id="lt"><!-- ここは左メニューです -->
<iframe seamless src="volume.jsp" width="100%" height="99%" frameborder="0" scrolling="auto"></iframe>
</div> <!-- id="lt" ここまで左メニューです -->

<div id="main"><!-- ########## ここから本文です ########## -->
<div id="main2"><!-- 縁を 20px あけるためのものです -->

入力： <%=strTxt0%>：<%=strTxt1%>：<%=strTxt2%>：検索します<br>

      検索ワード？
      <input name="textfield0" type="text" class="textField" id="tField0">
      <select name="select0" class="selectBox" id="selBox0" onChange="getSelect(0);" >
      <option value=""></option>
<%
  file=new File(application.getRealPath("rireki"));
  objBr = new BufferedReader(new InputStreamReader(new FileInputStream(file),"UTF-8"));
  line = "";
while((line = objBr.readLine()) != null){
      out.println("<option value='" + line + "'>" + line + "</option>");
}
objBr.close();
%>
      </select>
<br>
      検索ワード？
      <input name="textfield1" type="text" class="textField" id="tField1">
      <select name="select1" class="selectBox" id="selBox1" onChange="getSelect(1)">
      <option value=""></option>
<%
file=new File(application.getRealPath("rireki"));
objBr = new BufferedReader(new InputStreamReader(new FileInputStream(file),"UTF-8"));
line = "";
while((line = objBr.readLine()) != null){
      out.println("<option value='" + line + "'>" + line + "</option>");
}
objBr.close();
%>
      </select>
<br>
      検索ワード？
      <input name="textfield2" type="text" class="textField" id="tField2">
      <select name="select2" class="selectBox" id="selBox2" onChange="getSelect(2)">
      <option value=""></option>
<%
file=new File(application.getRealPath("rireki"));
objBr = new BufferedReader(new InputStreamReader(new FileInputStream(file),"UTF-8"));
line = "";
while((line = objBr.readLine()) != null){
      out.println("<option value='" + line + "'>" + line + "</option>");
}
objBr.close();
%>
      </select>
<br>

      <input type="submit" value="検索" />
    </form>
<script type="text/javascript">
function getSelect(unit) {
  //alert($("#selBox" + unit).val());
  document.getElementById("tField" + unit).value = $("#selBox" + unit).val();    
}

function getText(unit) {
  var s = document.getElementById("tField" + unit).value;
  alert(s);
}
</script>

 <%
file=new File(application.getRealPath("all.csv"));
objBr = new BufferedReader(new InputStreamReader(new FileInputStream(file),"UTF-8"));

line = "";
out.println("<table border='1' >");
        out.println("<tr>");
        //out.println("<td>" + cols[0] + "</td>");
        out.println("<td>アーティスト</td>");
        out.println("<td>アルバム</td>");
        out.println("<td>タイトル</td>");
        out.println("<td>Play</td>");
        out.println("<td>Vocal Off</td>");
        out.println("<td>歌詞</td>");
        //out.println("<td>Volume</td>");
        out.println("</tr>");
int buttonid = 0;
while((line = objBr.readLine()) != null){
    StringTokenizer objTkn=new StringTokenizer(line,"\n");
    while(objTkn.hasMoreTokens()){
      String csvLine = objTkn.nextToken();
      boolean flg = true;
      if (csvLine.toLowerCase().indexOf(strTxt0.toLowerCase()) < 0) {
        flg = false;
      }
      if (csvLine.toLowerCase().indexOf(strTxt1.toLowerCase()) < 0) {
        flg = false;
      }
      if (csvLine.toLowerCase().indexOf(strTxt2.toLowerCase()) < 0) {
        flg = false;
      }
      if (flg) {
        String[] cols = csvLine.split("\t", -1);
        out.println("<tr>");
        //out.println("<td>" + cols[0] + "</td>");
        out.println("<td>" + cols[1] + "</td>");
        out.println("<td>" + cols[2] + "</td>");
        out.println("<td>" + cols[3] + "</td>");
        buttonid = buttonid + 1;
        out.println("<td><button id='" + buttonid + "' onClick='submitForm(\"" + cols[0].replace("\'","&#39") + "\"," + cols[4] + "," + buttonid +",\"\")' style='width:100px; height:4em; '>Play</button> </td>");
        buttonid = buttonid + 1;
        out.println("<td><button id='" + buttonid + "' onClick='submitForm(\"" + cols[0].replace("\'","&#39") + "\"," + cols[4] + "," + buttonid +",\"oops\")' style='width:100px; height:4em; '>カラオケ</button> </td>");

        out.println("<td><button onClick='getLyric(\"" + cols[1].replace("\'","&#39") + "\",\"" + cols[3].replace("\'","&#39") + "\")' style='width:100px; height:4em; '>歌詞表示</button> </td>");
        //out.println("<td>" + cols[4] + "</td>");
        out.println("</tr>");
      }
    }
}
out.println("</table>");
objBr.close();
 %>
<div class="popupModal1">
 <input type="radio" name="modalPop" id="pop11" />
 <label for="pop11">クリックでポップアップ</label>
 <input type="radio" name="modalPop" id="pop12" />
 <label for="pop12">CLOSE</label>
 <input type="radio" name="modalPop" id="pop13" />
 <label for="pop13">×</label>
 <div class="modalPopup2">
  <div class="modalPopup3">
   <h2 class="modalTitle">--- Lyric ---</h2>
   <div class="modalMain">
   </div>
  </div>
 </div>
</div>
  </body>
</html>
