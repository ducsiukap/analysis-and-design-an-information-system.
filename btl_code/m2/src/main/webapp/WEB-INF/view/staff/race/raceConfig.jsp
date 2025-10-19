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

<%--    body --%>
<div class="page-body index">
    <c:url var="basedUrl" value="/race"/>

    <div class="form-container">
        <form class="form" action="${basedUrl}/confirm" method="post">
            <div class="form-title">
                <h1>Race configuration</h1>
            </div>

            <div class="form-group-multi">
                <div>
                    <label for="tournament">Season: </label>
                    <select id="tournament" name="tournament" onchange="changeSeason(this.value)">
                        <option value="${race.tournament.id}">2026</option>
                        <c:forEach var="tournament" items="${seasons}">
                            <option value="${tournament.id}"
                                    <c:if test="${tournament.id eq race.tournament.id}">selected</c:if>
                            >${tournament.year}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div>
                    <label for="circuit">Circuit: </label>
                    <select id="circuit" name="circuit">
                        <c:forEach var="circuit" items="${circuits}">
                            <option value="${circuit.id}"
                                    <c:if test="${circuit.id eq race.circuit.id}">selected</c:if>
                            >${circuit.name}, ${circuit.country}
                            </option>
                        </c:forEach>
                    </select>
                </div>

                <div>
                    <label for="raceNumber">Race number: </label>
                    <select id="raceNumber" name="raceNumber">
                        <c:forEach var="raceNumber" items="${raceNumbers}">
                            <option value="${raceNumber}"
                                    <c:if test="${raceNumber eq race.raceNum} ">selected</c:if>
                            >${raceNumber}
                            </option>
                        </c:forEach>
                    </select>
                </div>
            </div>

            <div class="form-group">
                <label for="raceName">Name: </label>
                <input type="text" id="raceName" name="raceName" value="${race.name}" required/>
            </div>

            <div class="form-group-multi">
                <div>
                    <label for="raceLaps">Laps: </label>
                    <input type="number" id="raceLaps" name="raceLaps" value="${race.numberOfLaps}" required/>
                </div>

                <div>
                    <label for="raceTime">Time: </label>
                    <input type="datetime-local" id="raceTime" name="raceTime"
                           value="${formattedRaceTime}" required/>
                </div>
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


<%--link redirect.js--%>
<script src="<c:url value='/js/redirect.js'/>"></script>

<script>
    function changeSeason(season) {
        const circuit = document.getElementById('circuit').value;
        const raceName = document.getElementById('raceName').value;
        const raceLaps = document.getElementById('raceLaps').value;
        const raceTime = document.getElementById('raceTime').value;
        console.log(season, circuit, raceName, raceLaps, raceTime);

        const currentURL = window.location.pathname
        navigate("${basedUrl}/config/" + season + "/" + circuit +
            "?raceName=" + raceName + "&raceTime=" + raceTime + "&raceLaps=" + raceLaps +
            "&from=" + currentURL);
    }
</script>

</body>
</html>
