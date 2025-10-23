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
    <c:url var="basedUrl" value="/rankings/team"/>
    <div class="sub-nav-row">
        <form id="nav-form" class="nav-form" method="get">
            <%-- de submit --%>
            <input type="hidden" name="season" id="params-season" value="${ranking_team_season.year}"/>
            <%--            <input type="hidden" name="race" id="params-race"/>--%>

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
                <label for="team">Team: </label>
                <select id="team" onchange="changeTeam(this.value)">
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
                <col style="width:60%;">
                <col style="width:20%;">
                <col style="width:20%;">
            </colgroup>
            <thead>
            <tr>
                <th>Race</th>
                <th>Date</th>
                <th>Point</th>
            </tr>
            </thead>
            <c:choose>
                <%--                if--%>
                <c:when test="${empty ranking_team_stats}">
                    <tr class="table-no-data">
                        <td colspan="3">There is no data for this race!</td>
                    </tr>
                </c:when>
                <%--else--%>
                <c:otherwise>
                    <c:forEach var="raceResult" items="${ranking_team_stats}" varStatus="loop">
                        <tr onclick="navigate('${basedUrl}/${ranking_team_team.name}/race/${raceResult.name}?season=${ranking_team_season.year}')">
                                <%--                            <td>#${loop.index + 1}</td>--%>
                            <td>${raceResult.name}</td>
                            <td>${raceResult.time.getDayOfMonth()} ${raceResult.time.getMonth().name().substring(0, 3)}</td>
                            <td style="color: darkred; font-size: 1.2rem; font-weight: bold">${raceResult.totalPoint}</td>
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
        const form = document.getElementById('nav-form')

        document.getElementById("params-season").value = season
        // document.getElementById("params-race").value = ""

        form.action = "${basedUrl}/_"
        form.submit()
    }

    function changeTeam(team) {
        const form = document.getElementById('nav-form')

        const season = document.getElementById('season').value
        document.getElementById("params-season").value = season
        // document.getElementById("params-race").value = race

        form.action = "${basedUrl}/" + team
        form.submit()
    }
</script>


</body>
</html>
