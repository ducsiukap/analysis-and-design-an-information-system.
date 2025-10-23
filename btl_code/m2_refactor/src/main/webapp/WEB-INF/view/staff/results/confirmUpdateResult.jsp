<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>Update result</title>
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/general.css'/>"/>
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/rankingform.css'/>"/>
    <link rel="stylesheet" type="text/css" href="<c:url value='/css/teamranking.css'/>"/>

</head>
<body>

<c:url var="basedUrl" value="/results/update"/>

<script src="<c:url value='/js/redirect.js'/>"></script>
<%@include file="../appLayout.jsp" %>

<%--// display the error--%>
<c:if test="${not empty updateResult_error}">
    <script>
        alert("${updateResult_error}")
        navigate("${basedUrl}?season=${updateResult_season.year}&race=${updateResult_race.name}")
    </script>
</c:if>

<div class="page-body">
    <h3>Update result of Race: ${updateResult_race.name}</h3>
    <div style="display: flex">
        <div>
            Tournament: ${updateResult_race.tournament.name}<br>
            Circuit: ${updateResult_race.circuit.name}<br>
            <br>
        </div>

        <div style="flex-grow: 1"></div>
        <div class="sub-nav-row">
            <form id="confirm-form" method="POST"
                  action="${basedUrl}/save?season=${updateResult_season.year}&race=${updateResult_race.name}"></form>
            <div class="btn-group">
                <button class="default-btn"
                        onclick="navigate('${basedUrl}?season=${updateResult_season.year}&race=${updateResult_race.name}')">
                    Back
                </button>
                <button class="accept-btn" onclick="confirm()">Save</button>
            </div>
        </div>
    </div>

    <div class="table-container">
        <div id="update-results-form">
            <table class="ranking-table">
                <colgroup>
                    <col style="width: 5%;">
                    <col style="width: 25%;">
                    <col style="width: 25%;">
                    <col style="width: 10%;">
                    <col style="width: 10%;">
                    <col style="width: 15%;">
                    <col style="width: 10%;">
                </colgroup>
                <thead>
                <tr>
                    <th>Pos.</th>
                    <th>Driver</th>
                    <th>Team</th>
                    <th>Starting pos.</th>
                    <th>Lap</th>
                    <th>Time</th>
                    <th>Point</th>
                </tr>
                </thead>

                <c:choose>
                    <%--if--%>
                    <c:when test="${empty updateResult_results.results}">
                        <tr class="table-no-data">
                            <td colspan="7">There is no data for this race!</td>
                        </tr>
                    </c:when>
                    <%--else--%>
                    <c:otherwise>
                        <c:forEach var="result" items="${updateResult_results.results}" varStatus="idx">
                            <tr>
                                <td style="font-weight: bold">#${result.position}</td>
                                <td style="font-weight: bold">${result.driver.name}</td>
                                <td>${result.team.name}</td>
                                <td>${result.startingPos}</td>
                                <td>${result.laps}</td>
                                <td>${updateResult_hours[idx.index]}:${updateResult_minutes[idx.index]}:${updateResult_seconds[idx.index]}:${updateResult_millis[idx.index]}</td>
                                <td style="font-weight: bold; color: darkred; font-size: 1.1rem">${result.point}</td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </table>
        </div>
    </div>
</div>

<script>
    function confirm() {
        const form = document.getElementById("confirm-form");
        form.submit()
    }
</script>
</body>
</html>
