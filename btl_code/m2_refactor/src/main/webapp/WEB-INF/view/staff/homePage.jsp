<%@ page contentType="text/html;charset=UTF-8" %>
<%--JSP--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Home</title>
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/general.css' />">
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/nav.css' />">
</head>
<body>

<%@include file="appLayout.jsp" %>

<%--body --%>
<div class="page-body index">
    <h1>Hello, <i>${user.fullName}</i></h1>
</div>

<%--link redirect.js--%>
<script src="<c:url value='/js/redirect.js' />"></script>

</body>
</html>
