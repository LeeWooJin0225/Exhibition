<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp" %>
<!DOCTYPE html>
<html>
<head>

<%@ include file="/WEB-INF/views/include/head.jsp" %>

<script type="text/javascript">
$(function(){
   
   if(icia.common.type(window.opener) == "object")
   {
      if(icia.common.type(window.opener.fn_kakaoPayResult) == "function")
      {
         window.opener.fn_kakaoPayResult(${code}, "${msg}", "${orderId}");
      }
      else
      {
         alert("${msg}");
         window.close();
      }
   }
   else
   {
      alert("${msg}");
      window.close();
   }
   
});
</script>
</head>
<body>

</body>
</html>