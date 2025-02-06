<div class="header">
    <% 
        String role = (String) session.getAttribute("role");
    %>
    <% if ("manager".equals(role)) { %>
    <div class="manager-nav">
        <ul class="manager-menu">
            <li class="menu-item"><a href="customers.jsp" class="menu-link">Customer Lookup</a></li>
            <li class="menu-item"><a href="sales.jsp" class="menu-link">Sales Reports</a></li>
            <li class="menu-item"><a href="adminReservationsList.jsp" class="menu-link">Reservations</a></li>
            <li class="menu-item">
                <form action="logout.jsp" method="POST" class="logout-form">
                    <input type="submit" value="Logout" class="logout-button" />
                </form>
            </li>
        </ul>
    </div>
    <% } else if ("representative".equals(role)) { %>
    <div class="representative-nav">
        <ul class="representative-menu">
            <li class="menu-item"><a href="support.jsp" class="menu-link">Support</a></li>
            <li class="menu-item"><a href="trainSchedules.jsp" class="menu-link">Train Schedules</a></li>
            <li class="menu-item"><a href="customerReservations.jsp" class="menu-link">Customer Reservations</a></li>
            <li class="menu-item"><a href="stationSchedules.jsp" class="menu-link">Station Schedules</a></li>
            <li class="menu-item">
                <form action="logout.jsp" method="POST" class="logout-form">
                    <input type="submit" value="Logout" class="logout-button" />
                </form>
            </li>
        </ul>
    </div>
    <% } else if ("customer".equals(role)) { %>
    <div class="customer-nav">
        <ul class="customer-menu">
            <li class="menu-item"><a href="book.jsp" class="menu-link">Book Tickets</a></li>
            <li class="menu-item"><a href="reservations.jsp" class="menu-link">Reservations</a></li>
            <li class="menu-item"><a href="support.jsp" class="menu-link">Support</a></li>
            <li class="menu-item">
                <form action="logout.jsp" method="POST" class="logout-form">
                    <input type="submit" value="Logout" class="logout-button" />
                </form>
            </li>
        </ul>
    </div>
    <% } %>
</div>
