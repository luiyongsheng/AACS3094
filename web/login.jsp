<%-- 
    Document   : register
    Created on : Dec 20, 2017, 10:06:51 PM
    Author     : sheng
--%>
<%
Object username = session.getAttribute("username");
if(username != null) response.sendRedirect("index.jsp");
%>
<%@ page import = "java.io.*,java.util.*,eventio.Captcha,java.util.Random,javax.servlet.http.Cookie" %>
<%
String param = request.getParameter("error");
%>
    <%@page contentType="text/html" pageEncoding="UTF-8"%>
        <!DOCTYPE html>
        <html>

        <head>
                <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
                <meta name="viewport" content="initial-scale=1,maximum-scale=1,width=device-width,user-scalable=no">
                <meta name="HandheldFriendly" content="true">
            <meta charset="utf-8">
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <title>Login</title>
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/2.2.13/semantic.min.css" />
            <script src="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/2.2.13/semantic.min.js"></script>
            <link rel="stylesheet" href="css/ui.min.css" />
        </head>

        <script>
            
        </script>

        <body>
            <style>
                * {
                    transition: color 256ms ease-out
                }
                body {
                    height: auto;
                    background:#fff
                }

                main {
                    max-width: 480px;
                    margin: 40px auto;
                    height: auto
                }

                form {
                    background: white;
                    padding: 20px;
                    border-radius: 3px;
                }

                img {
                    cursor: pointer
                }

                .footnote {
                    text-align: center;
                    margin: 20px;
                    color: #867888;
                }
            </style>
            <nav class="globalnav">
                <div class="content">
                    <a href="/Assignment" class="logo">event
                        <span>io</span>
                    </a>
                </div>
            </nav>
            <main style="margin-top:100px">
                <h1 style="text-align:center;margin-bottom:30px">Login</h1>
                <form class="ui form" action="api/v1/login" method="post">
                    <div class="field">
                        <label for="username">Username</label>
                        <input type="text" required placeholder="" maxlength="12" name="username" id="username">
                    </div>
                    <div id="pf" class="field">
                        <label for="password">Password</label>
                        <input type="password" required name="password" id="password" onkeyup="check()">
                    </div>
                    <button type="submit" class="ui button primary">Login</button>
                </form>
                <% if(param != null) {%>
                <div class="ui message error">
                    <p><i class="icon warning"></i> Login failed, invalid credentials.</p>
                </div> <%}%>
                <div class="footnote">New user? <a href="register.jsp">Register</a> now.</div>
            </main>
        </body>

        </html>