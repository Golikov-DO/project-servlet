<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.tictactoe.Sign" %>
<%
    if (session.getAttribute("data") == null) {
        response.sendRedirect("start");
        return;
    }
%>

<%
    @SuppressWarnings("unchecked")
    List<Sign> data = (List<Sign>) session.getAttribute("data");

    @SuppressWarnings("unchecked")
    List<Integer> winnerOffsets =
            (List<Integer>) session.getAttribute("winnerOffsets");

    Sign winner = (Sign) session.getAttribute("winner");
    Boolean draw = (Boolean) session.getAttribute("draw");
%>

<!DOCTYPE html>
<html>
<head>
    <title>Крестики-нолики</title>

    <!-- CSS -->
    <link rel="stylesheet"
          href="<%= request.getContextPath() %>/static/main.css">

</head>
<body>
<h2 style="text-align:center">
    Нолик ходит автоматически.
</h2>
<%
    int crossCount = 0;
    int noughtCount = 0;

    for (Sign s : data) {
        if (s == Sign.CROSS) crossCount++;
        if (s == Sign.NOUGHT) noughtCount++;
    }

    boolean crossTurn = crossCount == noughtCount;
%>
<h2 style="text-align:center">
    <% if (winner != null) { %>
    Победил: <%= winner.getSign() %>
    <% } else if (Boolean.TRUE.equals(draw)) { %>
    Ничья
    <% } else if (crossTurn) { %>
    Ход крестика
    <% } else { %>
    Ход нолика
    <% } %>
</h2>

<div class="board-wrapper">

    <!-- SVG для линии победы -->
    <svg id="win-svg"
         width="300"
         height="300"
         viewBox="0 0 300 300"
         xmlns="http://www.w3.org/2000/svg">
    </svg>

    <table>
        <%
            for (int row = 0; row < 3; row++) {
        %>
        <tr>
            <%
                for (int col = 0; col < 3; col++) {
                    int i = row * 3 + col;
                    Sign sign = data.get(i);

                    String cssClass = "";
                    if (sign == Sign.CROSS) {
                        cssClass = "cross";
                    } else if (sign == Sign.NOUGHT) {
                        cssClass = "nought";
                    }
            %>
            <td class="<%= cssClass %>"
                onclick="location.href='logic?click=<%= i %>'">
                <%= sign == Sign.EMPTY ? "&nbsp;" : sign.getSign() %>
            </td>
            <%
                }
            %>
        </tr>
        <%
            }
        %>
    </table>
</div>

<br>

<div style="text-align:center">
    <a href="restart">Начать заново</a>
</div>

<%-- ===== SVG линия победы ===== --%>
<% if (winnerOffsets != null) { %>
<script>
    const a = <%= winnerOffsets.get(0) %>;
    const b = <%= winnerOffsets.get(1) %>;
    const c = <%= winnerOffsets.get(2) %>;
</script>
<script>
    const svg = document.getElementById("win-svg");
    const cell = 100;
    const size = 300;

    let x1, y1, x2, y2;

    // Горизонталь
    if (a + 1 === b && b + 1 === c) {
        const row = Math.floor(a / 3);
        x1 = 0;
        x2 = size;
        y1 = y2 = row * cell + cell / 2;
    }

    // Вертикаль
    else if (a + 3 === b && b + 3 === c) {
        const col = a % 3;
        y1 = 0;
        y2 = size;
        x1 = x2 = col * cell + cell / 2;
    }

    // Диагональ \
    else if (a === 0 && b === 4 && c === 8) {
        x1 = 0;
        y1 = 0;
        x2 = size;
        y2 = size;
    }

    // Диагональ /
    else if (a === 2 && b === 4 && c === 6) {
        x1 = size;
        y1 = 0;
        x2 = 0;
        y2 = size;
    }

    svg.innerHTML = ""; // очистка на всякий случай

    const line = document.createElementNS("http://www.w3.org/2000/svg", "line");
    line.setAttribute("x1", x1);
    line.setAttribute("y1", y1);
    line.setAttribute("x2", x2);
    line.setAttribute("y2", y2);
    line.setAttribute("stroke", "red");
    line.setAttribute("stroke-width", "6");
    line.setAttribute("stroke-linecap", "round");

    svg.appendChild(line);

</script>
<% } %>

</body>
</html>
