<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Confirm</title>
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/genernal.css'/> "/>
</head>
<body>
<%@include file="../appLayout.jsp" %>

<div class="page-body index">
    <c:url var="basedUrl" value="/race/management"/>

    <div class="box">
        <form class="form"
              action="${basedUrl}/${race_management_raceDelete.tournament.year}/${race_management_raceDelete.name}/delete"
              method="post">
            <div class="form-title">
                <h1>Confirm delete race: <i>${race_management_raceDelete.name}</i></h1>
            </div>


            <div class="form-group">
                <b>${race_management_raceDelete.tournament.name}
                    - ${race_management_raceDelete.circuit.name}, ${race_management_raceDelete.circuit.country} - </b>
                <input
                        type="datetime-local" readonly
                        style="border: none; font-size: 1rem; font-style: italic"
                        value="${race_management_raceDelete.time}">
            </div>

            <div class="form-group-multi">
                <div>
                    <label for="raceNumber">Race number: </label>
                    ${race_management_raceDelete.raceNum}
                </div>
                <div>
                    <label for="raceLaps">Laps: </label>
                    ${race_management_raceDelete.numberOfLaps}
                </div>
            </div>

            <%--            <div class="form-group">--%>
            <%--                <label for="raceName">Name: </label>--%>
            <%--                ${race_management_raceDelete.name}--%>
            <%--            </div>--%>

            <div class="btn-group">
                <button
                        type="button"
                        class="default-btn"
                        onclick="history.back()">Back
                </button>
                <button type="button" class="delete-btn" onclick="this.form.submit()">Delete</button>
            </div>
        </form>
    </div>
</div>

<%--link redirect.js--%>
<script src="<c:url value='/js/redirect.js'/>"></script>

<%-- alert--%>

<c:if test="${not empty race_management_deleteError}">
    <script>
        alert("${race_management_deleteError}")
    </script>
</c:if>

</body>
</html>
