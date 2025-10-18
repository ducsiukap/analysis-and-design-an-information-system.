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
                        onchange="getTeams()">
                    <c:forEach var="season" items="${seasons}">
                        <option value="${season}"
                                <c:if test="${season eq selectedSeason}">selected</c:if>
                        >${season}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label for="team">Team: </label>
                <select name="team" id="team"
                        onchange="getStats()">
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
                <c:when test="${empty stats}">
                    <tr class="table-no-data">
                        <td colspan="3">There is no data for this race!</td>
                    </tr>
                </c:when>
                <%--else--%>
                <c:otherwise>
                    <c:forEach var="raceResult" items="${stats}" varStatus="loop">
                        <tr onclick="navigate('<c:url
                                value="/results/${selectedSeason}/team/${selectedTeam}/race/${raceResult.name}"/>')">
                                <%--                            <td>#${loop.index + 1}</td>--%>
                            <td>${raceResult.name}</td>
                            <td>${raceResult.time.getDayOfMonth()} ${raceResult.time.getMonth().name().substring(0, 3)}</td>
                            <td>${raceResult.totalPoint}</td>
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
    function getTeams() {
        let year = document.getElementById('tournament').value;
        navigate("${basedUrl}" + year + "/team")
    }

    function getRankings() {
        let year = document.getElementById('tournament').value;
        let team = document.getElementById('team').value;
        navigate("${basedUrl}" + year + "/team/" + team);
    }
</script>


</body>
</html>
