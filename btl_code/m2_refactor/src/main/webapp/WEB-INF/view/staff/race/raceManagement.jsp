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

<c:if test="${not empty race_management_updateSuccess}">
    <script>
        alert("${race_management_updateSuccess}")
    </script>
</c:if>

<c:if test="${not empty race_management_deleteSuccess}">
    <script>
        alert("${race_management_deleteSuccess}")
    </script>
</c:if>

<%--    body --%>
<div class="page-body">
    <%--        select tieu chi xep hang--%>
    <c:url var="basedUrl" value="/race/management"/>
    <div class="sub-nav-row">
        <form id="nav-form" action="${basedUrl}" class="nav-form" method="get">
            <%-- de submit --%>
            <input type="hidden" name="season" id="params-season" value="${race_management_season.year}"/>

            <div class="form-group">
                <label for="season">Season: </label>
                <select id="season" onchange="changeSeason(this.value)">
                    <%--                    <option value="2025">2026</option>--%>
                    <c:forEach var="season" items="${race_management_seasons}">
                        <option value="${season.year}"
                                <c:if test="${season.year eq race_management_season.year}">selected</c:if>
                        >${season.year}</option>
                    </c:forEach>
                </select>
            </div>
        </form>

        <div class="btn-group">
            <button class="accept-btn" onclick="navigate('${basedUrl}/new')">New</button>
        </div>
    </div>

    <%--        bang cac Race--%>
    <div class="table-container">
        <table class="ranking-table">
            <colgroup>
                <col style="width:5%;">
                <col style="width:30%;">
                <col style="width:10%;">
                <col style="width:25%;">
                <col style="width:10%;">
                <col style="width:5%;">
                <col style="width:15%;">
            </colgroup>
            <thead>
            <tr>
                <th>No.</th>
                <th>Race</th>
                <th>Tournament</th>
                <th>Circuit</th>
                <th>Date</th>
                <th>Laps</th>
                <th>Action</th>
            </tr>
            </thead>
            <c:choose>
                <%--                if--%>
                <c:when test="${empty race_management_races}">
                    <tr class="table-no-data">
                        <td colspan="7">There is no data for this race!</td>
                    </tr>
                </c:when>
                <%--else--%>
                <c:otherwise>
                    <c:forEach var="race" items="${race_management_races}" varStatus="loop">
                        <tr>
                            <td>${loop.index + 1}</td>
                            <td>${race.name}</td>
                            <td>${race.tournament.year}</td>
                            <td>${race.circuit.country}</td>
                            <td>${race.time.getDayOfMonth()} ${race.time.getMonth().name().substring(0, 3)}</td>
                            <td>${race.numberOfLaps}</td>
                            <td>
                                <div class="btn-group">
                                    <button
                                            class="modify-btn"
                                            onclick="navigate('${basedUrl}/${race.tournament.year}/${race.name}/edit')">
                                        Edit
                                    </button>
                                    <button
                                            class="delete-btn"
                                            onclick="navigate('${basedUrl}/${race.tournament.year}/${race.name}/delete')">Delete
                                    </button>
                                </div>
                            </td>
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

        document.getElementById("params-season").value = season;
        form.submit()
    }
</script>

</body>
</html>
