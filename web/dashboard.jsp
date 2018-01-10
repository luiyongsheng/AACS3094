<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import = "java.io.*,java.util.*,eventio.Captcha,java.util.Random" %>
<%
    Object lvl = session.getAttribute("memberLevel");
    if(lvl == null) {
        response.sendRedirect("profile.jsp");
%>

<% } else
{ 
    int memlvl = Integer.parseInt(lvl.toString());
    if(memlvl >= 5) {
%>
<!doctype html>
<html>

<head>
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
        <meta name="viewport" content="initial-scale=1,maximum-scale=1,width=device-width,user-scalable=no">
        <meta name="HandheldFriendly" content="true">
    <title>Dashboard - Exco Member</title>
    <script src="https://code.jquery.com/jquery-3.2.1.min.js" integrity="sha256-hwg4gsxgFZhOsEEamdOYGBf13FyQuiTwlAQgxVSNgt4="
        crossorigin="anonymous"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/2.2.13/semantic.min.css" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/2.2.13/semantic.min.js"></script>
    <link rel="stylesheet" href="css/ui.min.css" />
    <script src="https://cdnjs.cloudflare.com/ajax/libs/vue/2.5.13/vue.min.js"></script>
</head>

<body class="dashboard">
    <nav class="globalnav">
        <div class="content">
            <a href="/Assignment" class="logo">event
                <span>io</span>
            </a>
        </div>
    </nav>
    <main id="app" class="main ui container content">

        <h1 class="title" style="padding-right: 1.5rem;">Dashboard <div class="ui label">
                <i class="user icon"></i> <%=session.getAttribute("username")%>
              </div></h1>

        <div class="ui grid">
            <div class="three wide column">
                <ul class="sidemenu">
                    <li><a href="#" @click="changePresenter(1)" :class="(presenting == 1) ? 'active' : ''"><i class="address book outline icon"></i> Members</a></li>
                    <li><a href="#" @click="changePresenter(2)" :class="(presenting == 2) ? 'active' : ''" ><i class="browser icon"></i> Events</a></li>
                    
                    <li><a href="profile.jsp"><i class="user icon"></i> Profile</a></li>
                </ul>
            </div>
            <div class="thirteen wide column">
                <section class="dashner">
                    <div class="model">
                        <div class="ui grid clearfix">
                            <div class="eight wide column"><h2>We found {{presenter.length}} of them</h2></div>
                            <div class="eight wide column clearfix">
                                  <a v-if="presenting == 2" href="addEvent.jsp" class="ui button primary icon right floated"><i class="icon add"></i></a>
                                </div>
                        </div>

                        <section class="results ui grid container">
                            <div class="four wide column" :id="item.id" v-for="(item, index) in presenter">
                                <a @click="details(index)" :class="((presenting == 1) ? 'mem' : 'event') + ' box'">
                                    <span v-if="presenting == 1">
                                    <figure class="avatar">
                                        <i class="icon user"></i>
                                        <img v-if="item.picture != ''" :src="item.picture">
                                    </figure>
                                    <div class="username">{{item.lastName}} {{item.firstName}}</div>
                                    <label :class="((item.memberLevel >= 5) ? 'exco' : '') + ' ui basic label'"><span v-if="item.memberLevel >= 5">Exco Member</span><span v-else>Member</span></label></span>

                                    <span v-if="presenting == 2">
                                        <div class="time">{{item.eventDate}}</div>
                                        <div class="name">{{item.eventName}}</div>
                                        <div class="venue">{{item.location}}</div>
                                        <div class="price">
                                            <span v-if="item.price == 0">FREE</span>
                                            <span v-else>MYR {{item.price}}</span>
                                        </div>
                                    </span>
                                </a>
                            </div>
                        </section>
                    </div>
                </section>
            </div>
        </div>
    </main>
    <div class="ui modal" id="memMod">
            <div class="header">Manage Member</div>
            <div class="scrolling content">
                <div class="ui grid">
                    <div class="four wide column">
                            <figure class="avatar">
                                <i class="icon user"></i>
                                <img v-if="member.picture != ''" :src="member.picture">
                            </figure>
                    </div>
                    <div class="twelve wide column">
                        <h3>{{member.lastName}} {{member.firstName}}</h3>
                        <p>@{{member.username}}</p>
                        <p>
                            <div class="ui label basic blue"><span v-if="member.memberLevel >= 5">Exco Member</span><span v-else>Member</span></div>
                            <a @click="unsubs" v-if="member.memberLevel < 5" class="ui button basic tiny red" :style="(delConfirm == 0) ? 'box-shadow:none !important;':''">
                                <span v-if="delConfirm == 0">Delete Member</span>
                                <span v-else>Confirm Delete</span>
                            </a>
                        </p>
                    </div>
                </div>
                <section class="memdata" style="margin:24px auto; max-width: 780px" v-if="subs.id != ''">
                        <div class="ui grid">
                            <div class="thirteen wide column">
                                <h4 style="margin:0">Member Subscription</h4>
                                <p>Expiry : {{subs.expiry}}</p>
                            </div>
                            <div class="three wide column">
                                <button @click="pay" v-if="!subs.paid" class="ui button right floated">SET PAID</button>
                                <button v-else class="ui button basic green right floated"><i class="icon check"></i> PAID</button>
                            </div>
                        </div>
                </section>
            </div>
    </div>
</body>
<script>
</script>
<script>
    var locmem = [];
    var locsubs = [];
    var locevent = [];
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
            Array.prototype.swap = function (x, y) {
                var b = this[x];
                this[x] = this[y];
                this[y] = b;
                return this;
            }

            function sleep(time) {
                return new Promise((resolve) => setTimeout(resolve, time))
            }
            function loadEvents() {
                xhrRequest("GET","api/v1/events",null, function(data) {
                    $.each(data,function(k,v) {
                        locevent.push(v);
                        console.log(v);
                    });
                });
            }
            function loadMembers() {
                xhrRequest("GET","api/v1/users",null, function(data) {
                    $.each(data,function(k,v) {
                        locmem.push(v);
                        console.log(v);
                    });
                        $.each(dashboard.$data.members, function(k,v){
                            xhrRequest('GET','api/v1/subs?n='+v.username, null, function(data){
                                locsubs.push(data);
                            })
                        })
                });
            }

            
        loadMembers();
        loadEvents();
    var dashboard = new Vue({
        el: "#app",
        data: {
            members: locmem,
            events:  locevent,
            subslist: locsubs,
            presenter: [],
            presenting: 1,
        },
        methods: {
            details: function(i) {
                if(this.presenting == 1) {
                    memberMvc.$data.arrIndex = i;
                    memberMvc.$data.member = this.members[i];
                    memberMvc.$data.subs = this.subslist[i];
                    memberMvc.$data.foc = 1;
                    memberMvc.$data.delConfirm = 0;
                    sleep(1000);
                    $('#memMod').modal('show');
                }
                else {
                    $('#memMod').modal('hide');
                    var e = this.events[i].eventId;
                    window.location = 'event.jsp?id='+e;
                }
            },
            changePresenter: function(i) {
                this.presenting = i;
                if(i == 1) this.presenter = this.members;
                else if(i == 2) this.presenter = this.events;
            }
        }
    });
    var memberMvc = new Vue({
        el: "#memMod",
        data: {
            member: {},
            subs: {expiry:"",id:"",member:"",paid:false},
            arrIndex : 0,
            delConfirm: 0,
            foc: 0
        },
        methods: {
            pay: function() {
                xhrRequest("POST",'api/v1/pay',{n:this.member.username}, function(callback) {
                    memberMvc.$data.subs.paid = callback;
                })
            },
            unsubs: function() {
                if(this.delConfirm == 0) {
                    this.delConfirm += 1;
                }
                else {
                    xhrRequest("POST", 'api/v1/unsubs', {n:this.member.username}, function(callback) {
                        $('#memMod').modal('hide');
                        memberMvc.$data.delConfirm = 0;
                        if(callback == "true") {
                            dashboard.$data.members.splice(memberMvc.$data.arrIndex, 1);
                            dashboard.$data.presenter = dashboard.$data.members;
                        }
                    })
                }
            }
        }
    });
    sleep(1000);
    dashboard.$data.presenter = dashboard.$data.members;
    $(document).ready(function(){
        $('.ui.dropdown').dropdown();
    })
</script>
</html>
<%}
else 
        response.sendRedirect("profile.jsp");
}%>
