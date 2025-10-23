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

<c:if test="${not empty updateResult_success}">
    <script>
        alert("${updateResult_success}")
    </script>
</c:if>

<div class="page-body">
    <div class="sub-nav-row">
        <form id="nav-form" action="${basedUrl}" class="nav-form" method="get">
            <%-- de submit --%>
            <input type="hidden" name="season" id="params-season"/>
            <input type="hidden" name="race" id="params-race"/>

            <div class="form-group">
                <label for="season">Season: </label>
                <select id="season" onchange="changeSeason(this.value)">
                    <option value="2025">2026</option>
                    <c:forEach var="season" items="${updateResult_seasons}">
                        <option value="${season.year}"
                                <c:if test="${season.year eq updateResult_season.year}">selected</c:if>
                        >${season.year}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label for="race">Race: </label>
                <select id="race" onchange="changeRace(this.value)">
                    <c:forEach var="race" items="${updateResult_races}">
                        <option value="${race.name}"
                                <c:if test="${race.name eq updateResult_race.name}">selected</c:if>
                        >${race.name}</option>
                    </c:forEach>
                </select>
            </div>
        </form>

        <div class="btn-group">
            <button class="accept-btn" onclick="submitForm()">Update</button>
        </div>
    </div>

    <div class="table-container">
        <form id="update-results-form"
              action="${basedUrl}?season=${updateResult_season.year}&race=${updateResult_race.name}" method="post">
            <table class="ranking-table">
                <colgroup>
                    <col style="width: 10%;">
                    <col style="width: 25%;">
                    <col style="width: 25%;">
                    <col style="width: 10%;">
                    <col style="width: 10%;">
                    <col style="width: 20%;">
                </colgroup>
                <thead>
                <tr>
                    <th>No.</th>
                    <th>Driver</th>
                    <th>Team</th>
                    <th>Starting pos.</th>
                    <th>Lap
                        <label class="th-note">Race laps:${updateResult_race.numberOfLaps}</label>
                    </th>
                    <th>Time
                        <label class="th-note">HH:MM:SS.sss</label>
                    </th>
                </tr>
                </thead>

                <c:choose>
                    <%--if--%>
                    <c:when test="${empty updateResult_results.results}">
                        <tr class="table-no-data">
                            <td colspan="6">There is no data for this race!</td>
                        </tr>
                    </c:when>
                    <%--else--%>
                    <c:otherwise>
                        <c:forEach var="result" items="${updateResult_results.results}" varStatus="idx">
                            <tr>
                                <td>${result.driver.number}</td>
                                <td>${result.driver.name}</td>
                                <td>${result.team.name}</td>
                                <td><input type="number" name="results[${idx.index}].startingPos"
                                           value="${result.startingPos}" required></td>
                                <td><input type="number" name="results[${idx.index}].laps"
                                           value="${result.laps}" required></td>
                                <td>
                                        <%-- hours --%>
                                    <select id="h${idx.index}" onchange="updateTime(${idx.index})">
                                        <c:forEach begin="0" end="100" var="i">
                                            <option
                                                    <c:if test="${i eq updateResult_hours[idx.index]}">selected</c:if>>${i}
                                            </option>
                                        </c:forEach>
                                    </select> :
                                        <%-- minutes --%>
                                    <select id="m${idx.index}" onchange="updateTime(${idx.index})">
                                        <c:forEach begin="0" end="60" var="i">
                                            <option
                                                    <c:if test="${i eq updateResult_minutes[idx.index]}">selected</c:if>>${i}
                                            </option>
                                        </c:forEach>
                                    </select> :
                                        <%-- second --%>
                                    <select id="s${idx.index}" onchange="updateTime(${idx.index})">
                                        <c:forEach begin="0" end="60" var="i">
                                            <option
                                                    <c:if test="${i eq updateResult_seconds[idx.index]}">selected</c:if>>${i}
                                            </option>
                                        </c:forEach>
                                    </select> :
                                        <%-- ms --%>
                                    <select id="ms${idx.index}" onchange="updateTime(${idx.index})">
                                        <c:forEach begin="0" end="1000" var="i">
                                            <option
                                                    <c:if test="${i eq updateResult_millis[idx.index]}">selected</c:if>>${i}
                                            </option>
                                        </c:forEach>
                                    </select>
                                    <input type="hidden" id="time${idx.index}"
                                           name="results[${idx.index}].time"
                                           value="${result.time}"/>
                                </td>
                            </tr>
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
            </table>
        </form>
    </div>
</div>


<%--// display the error--%>
<c:if test="${not empty updateResult_error}">
    <script>
        alert("${updateResult_error}")
    </script>
</c:if>

<script>
    function changeSeason(season) {
        const form = document.getElementById("nav-form");
        document.getElementById("params-season").value = season
        document.getElementById("params-race").value = ""
        form.submit()
    }

    function changeRace(race) {
        const season = document.getElementById("season").value

        const form = document.getElementById("nav-form");

        document.getElementById("params-season").value = season
        document.getElementById("params-race").value = race

        form.submit()
    }

    function submitForm() {
        const form = document.getElementById("update-results-form")
        form.submit()
    }

    function updateTime(idx) {
        const h = +document.getElementById("h" + idx).value
        const m = +document.getElementById("m" + idx).value
        const s = +document.getElementById("s" + idx).value
        const mi = +document.getElementById("ms" + idx).value

        const raceTime = document.getElementById("time" + idx)
        raceTime.value = mi + s * 1000 + m * 60 * 1000 + h * 60 * 60 * 1000

        // alert("change value at row: " + idx + " - raceTime: " + raceTime.value)
    }
</script>
</body>
</html>
