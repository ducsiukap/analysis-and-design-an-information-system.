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
    <c:url var="basedUrl" value="/race"/>
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
        </div>

        <div class="btn-group">
            <button class="default-btn" onclick='navigate("${basedUrl}/new?first=true")'>Add new race</button>
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
                <c:when test="${empty races}">
                    <tr class="table-no-data">
                        <td colspan="7">There is no data for this race!</td>
                    </tr>
                </c:when>
                <%--else--%>
                <c:otherwise>
                    <c:forEach var="race" items="${races}" varStatus="loop">
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
                                            onclick="navigate('${basedUrl}/${race.id}/edit?first=true')">Edit
                                    </button>
                                    <button
                                            class="delete-btn"
                                            onclick="navigate('${basedUrl}/${race.id}/delete')">Delete
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
    function getRace() {
        let year = document.getElementById('tournament').value;
        navigate("${basedUrl}/" + year)
    }
</script>

</body>
</html>
