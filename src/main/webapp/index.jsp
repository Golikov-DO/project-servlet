<%@ page import="com.tictactoe.Sign" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<c:if test="${data == null}">
    <c:set var="url" value="/start" />
    <c:redirect url="${url}"/>
</c:if>

<!DOCTYPE html>
<html>
<head>
    <link href="<c:url value='/static/main.css'/>" rel="stylesheet">
    <script src="<c:url value="/static/jquery-3.6.0.min.js"/>"></script>
    <title>Tic-Tac-Toe</title>
</head>
<body>
<h1>Tic-Tac-Toe</h1>

<table>
    <c:set var="winList" value="${sessionScope.winnerOffsets}" />
    <c:forEach var="row" begin="0" end="2">
        <tr>
            <c:forEach var="col" begin="0" end="2">
                <c:set var="idx" value="${row * 3 + col}" />

                <c:set var="isWin" value="false" />
                <c:forEach var="w" items="${winList}">
                    <c:if test="${w == idx}"><c:set var="isWin" value="true" /></c:if>
                </c:forEach>

                <td class="${isWin ? 'winner-cell' : ''}"
                        <c:if test="${winner == null && draw == null}">
                            onclick="window.location='/logic?click=${idx}'"
                        </c:if>>
                        <%-- ВАЖНО: проверьте эту строку --%>
                        ${data[idx].sign}
                </td>
            </c:forEach>
        </tr>
    </c:forEach>
</table>

<hr>
<c:set var="CROSSES" value="<%=Sign.CROSS%>"/>
<c:set var="NOUGHTS" value="<%=Sign.NOUGHT%>"/>

<c:if test="${winner == CROSSES}">
    <h1>CROSSES WIN!</h1>
    <button onclick="restart()">Start again</button>
</c:if>
<c:if test="${winner == NOUGHTS}">
    <h1>NOUGHTS WIN!</h1>
    <button onclick="restart()">Start again</button>
</c:if>
<c:if test="${draw}">
    <h1>IT'S A DRAW</h1>
    <button onclick="restart()">Start again</button>
</c:if>

<script>
    function restart() {
        $.ajax({
            url: '/restart',
            type: 'POST',
            contentType: 'application/json;charset=UTF-8',
            async: false,
            success: function () {
                location.reload();
            }
        });
    }
</script>

</body>
</html>