<%-- 
    Document   : profile
    Created on : Jan 9, 2018, 5:47:41 PM
    Author     : sheng
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import = "java.io.*,java.util.*" %>
<%
    Object username = session.getAttribute("username");
    if(username == null) response.sendRedirect("login.jsp");
    else {
        int memberLevel = 0;
        Object lvl = session.getAttribute("memberLevel");
        if(lvl != null) {
            memberLevel = Integer.parseInt(lvl.toString());
    }
    %>
<!DOCTYPE html>

<head>
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
        <meta name="viewport" content="initial-scale=1,maximum-scale=1,width=device-width,user-scalable=no">
        <meta name="HandheldFriendly" content="true">
    <meta charset="utf-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Profile</title>
    <script src="https://code.jquery.com/jquery-3.2.1.min.js" integrity="sha256-hwg4gsxgFZhOsEEamdOYGBf13FyQuiTwlAQgxVSNgt4="
        crossorigin="anonymous"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/2.2.13/semantic.min.css" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/2.2.13/semantic.min.js"></script>
    <link rel="stylesheet" href="css/flex.css" />
    <link rel="stylesheet" href="css/ui.min.css" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/vue/2.5.13/vue.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/jsbarcode/3.8.0/JsBarcode.all.min.js"></script><link rel='stylesheet prefetch' href='https://fonts.googleapis.com/css?family=Lato:400,700'>
</head>
    <body>
        <%
            eventio.domain.Member m = eventio.controller.MemberController.getMember(username.toString());
            if(m == null) response.sendRedirect("login.jsp");
        %>
    <nav class="globalnav">
        <div class="content">
            <a href="/Assignment" class="logo">event
                <span>io</span>
            </a>
            <div class="right">
                <a href="api/v1/logout">Logout</a>
            </div>
        </div>
    </nav>
    <main class="content profile">
        <figure class="avatar">
            <i class="icon user"></i>
            <% if(m.getPicture().length() > 0) {%><img src="<%=m.getPicture()%>"><%}%>
        </figure>
        <form class="ui form" method="post" action="api/v1/updateProfile" style="max-width:640px;margin:20px auto 0;">
            <input type="hidden" name="id" value="<%=m.getId()%>">
            <input type="hidden" name="username" value="<%=m.getUsername()%>">
            <div class="field">
                    <label for="lastName">Picture</label>
                    <input type="text" name="picture" id="picture" placeholder="You profile picture link, can be local">
                </div>
                <div class="field">
                        <label for="lastName">Name</label>
                        <div class="two fields">
                            <div class="field">
                                <input type="text" required name="fistName" maxlength="20" id="fistName" placeholder="Given Name" value="<%=m.getFirstName()%>">
                            </div>
                            <div class="field">
                                <input type="text" required class="error" name="lastName" maxlength="20" id="lastName" value="<%=m.getLastName()%>" placeholder="Family Name">
                            </div>
                        </div>
                    </div>
                    <div id="pf" class="field">
                        <label for="password">Password</label>
                        <input type="password" required placeholder="Make it hard to guess" name="password" id="password"  v-on:keyup="passwordCheck">
                    </div>
                    <div id="pfc" class="field">
                        <label for="passworddc">Confirm Password</label>
                        <input type="password" required name="passworddc" id="passworddc" v-on:keyup="passwordCheck">
                    </div>
                    <button type="submit" class="ui button primary" :disabled="!valid">Update Profile</button>
        </form>
    </main>
    </body>
</html>
<% } %>
