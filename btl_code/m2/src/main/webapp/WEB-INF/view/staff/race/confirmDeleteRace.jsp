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
    <c:url var="basedUrl" value="/race"/>

    <div class="form-container">
        <form class="form" action="${basedUrl}/${race.id}/delete" method="get">
            <input id="confirm" name="confirm" value="true" hidden/>
            <div class="form-title">
                <h1>Race confirm</h1>
            </div>

            <div class="form-group-multi">
                <div>
                    <label for="tournament">Season: </label>
                    <input type="text" value="${race.tournament.name}" readonly/>
                    <input type="text" id="tournament" name="tournament" value="${race.tournament.id}" hidden/>
                </div>

                <div>
                    <label for="circuit">Circuit: </label>
                    <input type="text" value="${race.circuit.name}, ${race.circuit.country}"
                           readonly/>
                    <input type="text" id="circuit" name="circuit" value="${race.circuit.id}"
                           hidden/>
                </div>

                <div>
                    <label for="raceNumber">Race number: </label>
                    <input type="text" id="raceNumber" name="raceNumber" value="${race.raceNum}" readonly/>
                </div>
            </div>

            <div class="form-group">
                <label for="raceName">Name: </label>
                <input type="text" id="raceName" name="raceName" value="${race.name}" readonly/>
            </div>

            <div class="form-group-multi">
                <div>
                    <label for="raceLaps">Laps: </label>
                    <input type="number" id="raceLaps" name="raceLaps" value="${race.numberOfLaps}" readonly/>
                </div>

                <div>
                    <label for="raceTime">Time: </label>
                    <input type="datetime-local" id="raceTime" name="raceTime"
                           value="${formattedRaceTime}" readonly/>
                </div>
            </div>

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
