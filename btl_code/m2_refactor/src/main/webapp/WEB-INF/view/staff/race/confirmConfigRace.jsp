<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Confirm</title>
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/genernal.css'/> "/>
</head>
<body>
<%@include file="../appLayout.jsp" %>

<c:if test="${not empty race_management_updateError}">
    <script>
        alert("${race_management_updateError}")
    </script>
</c:if>

<div class="page-body" style="display: flex; align-items: center; justify-content: center;">
    <c:url var="basedUrl" value="/race/management/save"/>

    <div class="box">
        <form class="form" action="${basedUrl}" method="post">
            <%--            <input id="confirm" name="confirm" value="true" hidden/>--%>
            <div class="form-title">
                <h1>Race confirm</h1>
            </div>

            <div class="form-group">
                <%-- tournament--%>
                <h3>Tournament: ${race_management_raceUpdate.tournament.name}</h3>
                Year: ${race_management_raceUpdate.tournament.year}
            </div>

            <div class="form-group">
                <%-- circuit--%>
                <h3>Circuit: ${race_management_raceUpdate.circuit.name}</h3>
                Location: ${race_management_raceUpdate.circuit.city}, ${race_management_raceUpdate.circuit.country}<br>
                Lap length: ${race_management_raceUpdate.circuit.lapLength}km
            </div>

            <div class="form-group">
                <%-- race --%>
                <h3>Race name: ${race_management_raceUpdate.name}</h3>
                Laps: ${race_management_raceUpdate.numberOfLaps}<br>
                Time: <input type="datetime-local" readonly value="${race_management_formattedRaceTime}">
            </div>

            <div class="btn-group">
                <button
                        type="button"
                        class="default-btn"
                        onclick="history.back()">Back
                </button>
                <button type="submit">Save</button>
            </div>
        </form>
    </div>


</div>
</div>

<%--link redirect.js--%>
<script src="<c:url value='/js/redirect.js'/>"></script>

<%-- alert & navigate --%>
<c:if test="${not empty success}">
    <script>
        alert("${success}")
        navigate("<c:url value='/race'/>")
    </script>
</c:if>

<c:if test="${not empty error}">
    <script>
        alert("${error}")
    </script>
</c:if>

</body>
</html>
