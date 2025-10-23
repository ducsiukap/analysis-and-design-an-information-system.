<%@ page contentType="text/html;charset=UTF-8" %>
<%--JSP--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Config race</title>
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/general.css' />">
</head>
<body>

<%-- nav --%>
<%@include file="../appLayout.jsp" %>

<c:if test="${not empty race_management_validateError}">
    <script>
        alert("${race_management_validateError}")
    </script>
</c:if>

<%-- body --%>
<div class="page-body index">
    <c:url var="basedUrl" value="/race/management"/>

    <div class="box">
        <form id="race-to-post" class="form" action="${basedUrl}/new?action=post" method="post">
            <div class="form-title">
                <h1>Race configuration</h1>
            </div>

            <div class="form-group-multi">
                <div>
                    <label for="tournament">Season: </label>
                    <select id="tournament" name="tournament.year" onchange="changeSeason()">
                        <option value="${2025}">2026</option>
                        <c:forEach var="season" items="${race_management_seasons}">
                            <option value="${season.year}"
                                    <c:if test="${season.year eq race_management_raceUpdate.tournament.year}">selected</c:if>
                            >${season.year}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div>
                    <label for="circuit">Circuit: </label>
                    <select id="circuit" name="circuit.name">
                        <c:forEach var="circuit" items="${race_management_circuits}">
                            <option value="${circuit.name}"
                                    <c:if test="${circuit.name eq race_management_raceUpdate.circuit.name}">selected</c:if>
                            >${circuit.name}, ${circuit.country}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div>
                    <label for="raceNumber">Race number: </label>
                    <select id="raceNumber" name="raceNum">
                        <c:forEach var="raceNumber" items="${race_management_raceNumbers}">
                            <option value="${raceNumber}"
                                    <c:if test="${raceNumber eq race_management_raceUpdate.raceNum} ">selected</c:if>
                            >${raceNumber}
                            </option>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <div class="form-group">
                <label for="raceName">Name: </label>
                <input style="font-size: 20px; font-weight: bold" type="text" id="raceName" name="name"
                       value="${race_management_raceUpdate.name}" required/>
            </div>

            <div class="form-group-multi">
                <div>
                    <label for="raceLaps">Laps: </label>
                    <input type="number" id="raceLaps" name="numberOfLaps" value="${race_management_raceUpdate.numberOfLaps}"
                           required/>
                </div>

                <div>
                    <label for="raceTime">Time: </label>
                    <input type="datetime-local" id="raceTime" name="time"
                           value="${race_management_formattedRaceTime}" required/>
                </div>
            </div>

            <div class="btn-group">
                <button
                        type="button"
                        class="default-btn"
                        onclick="history.back()">Back
                </button>
                <button onclick="submitForm()">Save</button>
            </div>
        </form>
    </div>
</div>


<%--link redirect.js--%>
<script src="<c:url value='/js/redirect.js'/>"></script>

<script>
    function changeSeason() {
        const form = document.getElementById("race-to-post");

        form.action = "${basedUrl}/new"
        form.submit()
    }
</script>

</body>
</html>
