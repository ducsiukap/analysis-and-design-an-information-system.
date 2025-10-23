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
    <c:url var="basedUrl" value="/rankings"/>
    <div class="sub-nav-row">
        <form id="nav-form" class="nav-form" method="get">
            <%-- de submit --%>
            <input type="hidden" name="season" id="params-season" value="${ranking_team_season.year}"/>

            <div class="form-group">
                <label for="season">Season: </label>
                <select id="season" onchange="changeSeason(this.value)">
<%--                    <option value="2025">2026</option>--%>
                    <c:forEach var="season" items="${ranking_team_seasons}">
                        <option value="${season.year}"
                                <c:if test="${season.year eq ranking_team_season.year}">selected</c:if>
                        >${season.year}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label for="race">Race: </label>
                <select id="race" onchange="getResults()">
<%--                    <option value="">All</option>--%>
                    <c:forEach var="race" items="${ranking_team_races}">
                        <option value="${race.name}"
                                <c:if test="${race.name eq ranking_team_race.name}">selected</c:if>
                        >${race.name}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label for="team">Team: </label>
                <select id="team" onchange="getResults()">
                    <%--                    <option value="">All</option>--%>
                    <c:forEach var="team" items="${ranking_team_teams}">
                        <option value="${team.name}"
                                <c:if test="${team.name eq ranking_team_team.name}">selected</c:if>
                        >${team.name}</option>
                    </c:forEach>
                </select>
            </div>
        </form>
    </div>

    <%--        bangr xep hang--%>
    <div class="table-container">
        <table class="ranking-table">
            <colgroup>
                <col style="width:10%;">
                <col style="width:30%;">
                <col style="width:30%;">
                <col style="width:10%;">
                <col style="width:10%;">
                <col style="width:10%;">
            </colgroup>
            <thead>
            <tr>
                <th>Pos.</th>
                <th>Driver</th>
                <th>Team</th>
                <th>Lap</th>
                <th>Time</th>
                <th>Point</th>
            </tr>
            </thead>
            <c:choose>
                <%--                if--%>
                <c:when test="${empty ranking_team_results}">
                    <tr class="table-no-data">
                        <td colspan="6">There is no data for this race!</td>
                    </tr>
                </c:when>
                <%--else--%>
                <c:otherwise>
                    <c:forEach var="result" items="${ranking_team_results}" varStatus="loop">
                        <tr>
                            <td style="font-size: 1.2rem; font-weight: bold">
                                    <%--                            <td>#${loop.index + 1}</td>--%>
                                <c:choose>
                                    <c:when test="${result.position eq 0}">
                                        NC
                                    </c:when>
                                    <c:otherwise>
                                        #${result.position}
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td style="font-size: 1.2rem; font-weight: bold">${result.driver.name}</td>
                            <td>${result.team.name}</td>
                            <td>${result.laps}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${result.time eq 0}">
                                        DNF
                                    </c:when>
                                    <c:otherwise>
                                        ${ranking_team_resultTimes[loop.index]}
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td style="color: darkred; font-size: 1.2rem; font-weight: bold">${result.point}</td>
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
    function changeSeason(season) {
        const form = document.getElementById('nav-form');

        form.action = "${basedUrl}/team/_/race/_"
        document.getElementById("params-season").value = season;

        form.submit()
    }

    function getResults() {
        const form = document.getElementById('nav-form');
        const race = document.getElementById('race').value;
        const team = document.getElementById('team').value;

        form.action = "${basedUrl}/team/" + team + "/race/" + race
        // document.getElementById("params-season").value = season;
        form.submit()
    }
</script>


</body>
</html>
