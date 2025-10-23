<%@ page contentType="text/html;charset=UTF-8" %>
<%--JSP--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Error</title>
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/general.css' />">
</head>
<body>
<%--nav--%>
<%@include file="appLayout.jsp" %>

<%--body--%>
<div class="page-body index">
    <h3>${message}</h3>
</div>


<%--link redirect.js--%>
<script src="<c:url value='/js/redirect.js' />"></script>

</body>
</html>
