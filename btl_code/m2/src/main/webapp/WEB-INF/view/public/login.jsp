<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Login</title>
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/general.css' />">
</head>
<body>

<%--nav--%>
<%@include file="appLayout.jsp" %>

<%--page body--%>
<div class="form-container">
    <form class="form" action="<c:url value='/login' />" method="post">
        <div class="form-title">
            <h1>Login</h1>
        </div>
        <div class="form-group">
            <label for="username">Username:</label>
            <input type="text" id="username" name="username" value="${username}" required/>
        </div>

        <div class="form-group">
            <label for="password">Password:</label>
            <input type="password" name="password" id="password" required/>
        </div>

        <c:if test="${not empty(error)}">
            <%--                <div class="error">--%>
            <%--                    <label>${error}</label>--%>
            <%--                </div>--%>
            <script>
                alert("Login status: ${error}")
            </script>
        </c:if>

        <div class="btn-group">
            <button type="submit">Submit</button>
        </div>

    </form>
</div>

<%--link redirect.js--%>
<script src="<c:url value='/js/redirect.js' />"></script>
</body>
</html>
