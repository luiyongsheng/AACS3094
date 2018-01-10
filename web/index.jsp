<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ page import = "java.io.*,java.util.*" %>
        <!DOCTYPE html>

        <head>
                <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
                <meta name="viewport" content="initial-scale=1,maximum-scale=1,width=device-width,user-scalable=no">
                <meta name="HandheldFriendly" content="true">
            <meta charset="utf-8">
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <title>EventIO</title>
            <script src="https://code.jquery.com/jquery-3.2.1.min.js" integrity="sha256-hwg4gsxgFZhOsEEamdOYGBf13FyQuiTwlAQgxVSNgt4="
                crossorigin="anonymous"></script>
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/2.2.13/semantic.min.css" />
            <script src="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/2.2.13/semantic.min.js"></script>
            <link rel="stylesheet" href="css/ui.min.css" />
            <script src="https://cdnjs.cloudflare.com/ajax/libs/vue/2.5.13/vue.min.js"></script>
        </head>

        <body>
            <nav class="globalnav">
                <div class="content">
                    <a href="/Assignment" class="logo">event
                        <span>io</span>
                    </a>
                    <div class="right">
                        <%
                            Object username = (String)session.getAttribute("username");
                            if(username == null) {
                            %>
                            <a href="login.jsp">Login</a>
                            <a href="register.jsp">Register</a>
                            <% } else { %>
                            <a href="dashboard.jsp"><%=session.getAttribute("username")%></a>
                                <% } %>
                    </div>
                </div>
            </nav>
            <main id="app" class="content">
                <header class="hero">
                    <h1>
                        Upcoming events,
                        <br> find your next experience.
                    </h1>
                    <div class="searchbox ui grid">
                        <div class="one wide column">
                            <i class="icon search"></i>
                        </div>
                        <div class="thirteen wide column">
                            <input type="text" name="search" id="search" v-on:keyup.enter="searchK" v-model="keyword" placeholder="Try RE:SOURCE">
                        </div>
                        <div class="two wide column">
                            <a @click="searchK" class="ui button primary">Search</a>
                        </div>
                    </div>
                </header>
                <div class="ui four column grid events" style="min-height:300px;">
                    <div class="column" v-for="(item, index) in events">
                        <a class="card" :href="'event.jsp?id='+ item.eventId">
                            <div class="poster">
                                    <span class="price">
                                            <span v-if="item.price == 0">FREE</span>
                                            <span v-else>MYR {{item.price}}</span>
                                    </span>
                            </div>
                            <div class="info">
                                <time class="time">{{item.eventDate}}</time>
                                <h2 class="eventname">{{item.eventName}}</h2>
                                <h5 class="location">{{item.location}}</h5>
                            </div>
                        </a>
                    </div>
                </div>
            </main>
            <footer class="globalfooter">
                <div class="content">
                    <p>Copyright &copy; 2018.</p>
                </div>
            </footer>
        </body>
<script>
function xhrRequest(method, url, data, output) {
        $.ajax({
            type: method,
            url: url, // no cross-origin policy
            data: data,
            success: function (callback, status, xhr) {
                if (output != null) output(callback, status, xhr);
            },
            error: function (xhr) {
                console.log(xhr);
                if (output != null) output(xhr);
            }
        })
    }
    function loadEvents() {
        xhrRequest("GET","api/v1/events",null, function(data) {
            $.each(data,function(k,v) {
                home.$data.events.push(v);
                home.$data.buff.push(v);
            });
        });
    }
    var home = new Vue({
        el:"#app",
        data: {
            events: [],
            keyword: "",
            buff: []
        },
        methods: {
            searchK: function() {
                this.events = [];
                $.each(this.buff, function(k,v){
                    if(
                        v.eventName.toLowerCase().includes(home.$data.keyword.toLowerCase()) ||
                        v.location.toLowerCase().includes(home.$data.keyword.toLowerCase()) ||
                        v.description.toLowerCase().includes(home.$data.keyword.toLowerCase()) ||
                        
                        v.category.toLowerCase().includes(home.$data.keyword.toLowerCase())
                    ) {
                        
                    console.log(v.eventName);home.$data.events.push(v);
                    } 
                });
            }
        }
    });

    $(document).ready(function(){
        loadEvents();
    });
</script>
        </html>