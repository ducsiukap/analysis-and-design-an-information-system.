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
    <c:url var="basedUrl" value="/rankings/"/>
    <div class="sub-nav">
        <div id="form-ranking">
            <div class="form-group">
                <label for="tournament">Season: </label>
                <select name="tournament" id="tournament"
                        onchange="getRace()">
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
                        onchange="getRankings()">
                    <option value="all">All</option>
                    <c:forEach var="race" items="${races}">
                        <option value="${race.name}"
                                <c:if test="${race.name eq selectedRace}">selected</c:if>
                        >${race.name}</option>
                    </c:forEach>
                </select>
            </div>
        </div>
    </div>

    <%--        bangr xep hang--%>
    <div class="table-container">
        <table class="ranking-table">
            <colgroup>
                <col style="width:15%;">
                <col style="width:60%;">
                <col style="width:25%;">
            </colgroup>
            <thead>
            <tr>
                <th style="">Rank</th>
                <th>Team</th>
                <th>Point</th>
            </tr>
            </thead>
            <c:choose>
                <%--                if--%>
                <c:when test="${empty rankings}">
                    <tr class="table-no-data">
                        <td colspan="3">There is no data for this race!</td>
                    </tr>
                </c:when>
                <%--else--%>
                <c:otherwise>
                    <c:forEach var="team" items="${rankings}" varStatus="loop">
                        <tr onclick="navigate('<c:url value="/results/${selectedSeason}/team/${team.name}"/>')">
                            <td>#${loop.index + 1}</td>
                            <td>${team.name}</td>
                            <td>${team.totalPoint}</td>
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
    function getRace() {
        let year = document.getElementById('tournament').value;
        navigate("${basedUrl}" + year + "/team")
    }

    function getRankings() {
        let year = document.getElementById('tournament').value;
        let race = document.getElementById('race').value;
        navigate("${basedUrl}" + year + "/team/" + race);
    }
</script>


</body>
</html>
