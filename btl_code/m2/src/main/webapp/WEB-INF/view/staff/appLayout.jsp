<%@ page import="java.time.LocalDate" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<%--JSP--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--current-year--%>
<% int year = LocalDate.now().getYear();
    request.setAttribute("year", year);%>

<html>
<head>
    <title></title>
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/nav.css' />">
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/general.css' />">
</head>
<body>

<div>
    <nav class="top-nav">
        <%-- logo --%>
        <div class="top-nav-page-logo">
            <a href="<c:url value='/' />"><img class="page-logo" src="<c:url value='/image/page-logo.png'/>" alt=""></a>
        </div>

        <%-- menu navigate --%>
        <ul class="top-nav-link">
            <%-- Home Page --%>
            <li class="navlink-item"><a href="<c:url value='/'/>">Home</a></li>
            <li class="navlink-item">|</li>

            <%-- Rankings --%>
            <li class="navlink-item dropdown">
                <button class="dropdown-toggle">Ranking</button>
                <ul class="dropdown-items">
                    <li><a href="<c:url value='/rankings/${year}/team'/>">Team rankings</a></li>
                </ul>
            </li>
            <li class="navlink-item">|</li>

            <li class="navlink-item"><a href="<c:url value='/race'/>">Race</a></li>
            <li class="navlink-item">|</li>

            <li class="navlink-item"><a href="<c:url value='/race/update-score' />">Update race result</a></li>
        </ul>

        <%-- account, login, logout --%>
        <ul class="top-nav-link">
            <li class="navlink-item dropdown">
                <button class="dropdown-toggle">${lastName}</button>
                <ul class="dropdown-items">
                    <li><a href="<c:url value='/logout'/>">Logout</a></li>
                </ul>
            </li>
        </ul>
    </nav>
</div>

<%--nav dropdown--%>
<script src="<c:url value='/js/navToggle.js' />"></script>

</body>
</html>
