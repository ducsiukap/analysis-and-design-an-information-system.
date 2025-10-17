<%@ page contentType="text/html;charset=UTF-8" %>
<%--JSP--%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<html>
<head>
    <title>Results</title>
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/general.css' />">
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/rankingform.css' />">
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/teamranking.css' />">
</head>
<body>

<%-- nav --%>
<%@include file="../appLayout.jsp" %>

<%--    body --%>
<div class="page-body">
    <%--        select tieu chi xep hang--%>
    <c:url var="basedUrl" value="/results/"/>
    <div class="sub-nav">
        <div id="form-ranking">
            <div class="form-group">
                <label for="tournament">Season: </label>
                <select name="tournament" id="tournament"
                        onchange="getTeamsAndRaces()">
                    <c:forEach var="season" items="${seasons}">
                        <option value="${season}"
                                <c:if test="${season eq selectedSeason}">selected</c:if>
                        >${season}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label for="race">Race: </label>
                <select name="race" id="race"
                        onchange="getResults()">
                    <c:forEach var="race" items="${races}">
                        <option value="${race.name}"
                                <c:if test="${race.name eq selectedRace}">selected</c:if>
                        >${race.name}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label for="team">Team: </label>
                <select name="team" id="team"
                        onchange="getResults()">
                    <c:forEach var="team" items="${teams}">
                        <option value="${team.name}"
                                <c:if test="${team.name eq selectedTeam}">selected</c:if>
                        >${team.name}</option>
                    </c:forEach>
                </select>
            </div>
        </div>
    </div>

    <%--        bangr xep hang--%>
    <div class="table-container">
        <table class="ranking-table">
            <colgroup>
                <col style="width:10%;">
                <col style="width:30%;">
                <col style="width:25%;">
                <col style="width:10%;">
                <col style="width:15%;">
                <col style="width:10%;">
            </colgroup>
            <thead>
            <tr>
                <th style="">Position</th>
                <th>Driver</th>
                <th>Team</th>
                <th>Lap</th>
                <th>Time</th>
                <th>Point</th>
            </tr>
            </thead>
            <c:choose>
                <%--                if--%>
                <c:when test="${empty results}">
                    <tr class="table-no-data">
                        <td colspan="6">There is no data for this race!</td>
                    </tr>
                </c:when>
                <%--else--%>
                <c:otherwise>
                    <c:forEach var="result" items="${results}" varStatus="loop">
                        <tr>
                                <%--                            <td>#${loop.index + 1}</td>--%>
                            <td>${result.position}</td>
                            <td>${result.driver.name}</td>
                            <td>${result.team.name}</td>
                            <td>${result.laps}</td>
                            <td>${result.time.toHours()}:${result.time.toMinutes()%60}:${result.time.toSeconds()%60}.${result.time.toMillis()%1000}</td>
                            <td>${result.point}</td>
                        </tr>
                    </c:forEach>
                </c:otherwise>
            </c:choose>

        </table>
    </div>
</div>


<%--link redirect.js--%>
<script src="<c:url value='/js/redirect.js'/>"></script>

<script>
    function getResults() {
        let year = document.getElementById('tournament').value
        let team = document.getElementById('team').value
        let race = document.getElementById('race').value
        navigate("${basedUrl}" + year + "/team/" + team + "/race/" + race)
    }

    function getTeamsAndRaces() {
        let year = document.getElementById('tournament').value
        navigate("${basedUrl}" + year);
    }
</script>


</body>
</html>
