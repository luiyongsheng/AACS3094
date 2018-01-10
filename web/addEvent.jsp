<%-- 
    Document   : addEvent
    Created on : Jan 8, 2018, 11:24:01 PM
    Author     : sheng
--%>

    <%@page contentType="text/html" pageEncoding="UTF-8"%>
        <!DOCTYPE html>
        <html>

        <head>
                <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
                <meta name="viewport" content="initial-scale=1,maximum-scale=1,width=device-width,user-scalable=no">
                <meta name="HandheldFriendly" content="true">
            <meta charset="utf-8">
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <title>Create Event</title>
            <script src="https://code.jquery.com/jquery-3.2.1.min.js" integrity="sha256-hwg4gsxgFZhOsEEamdOYGBf13FyQuiTwlAQgxVSNgt4="
                crossorigin="anonymous"></script>
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/2.2.13/semantic.min.css" />
            <script src="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/2.2.13/semantic.min.js"></script>
            <link rel="stylesheet" href="css/ui.min.css" />
            <script src="https://cdnjs.cloudflare.com/ajax/libs/vue/2.5.13/vue.min.js"></script>
        </head>

        <body>
            <style>
                * {
                    transition: color 256ms ease-out
                }

                body {
                    height: auto;
                    background:#fff;
                }

                main {
                    max-width: 780px;
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
            <main style="margin-top:100px;" id="app">
                <h1 style="text-align:center;margin-bottom:30px">Create Event</h1>
                <form class="ui form" action="api/v1/createEvent" method="post" accept-charset="utf-8">
                    <div class="two fields">
                    <div class="fourteen wide field">
                            <label>Organization</label>
                            <select required id="organization" name="organization" class="ui dropdown">
                                    <option value=""></option>
                                    <option v-for="(item,index) in orgs" :value="item.id">{{item.name}}</option>
                            </select>
                    </div>
                    <div class="four wide field">
                            <label>&nbsp;</label>
                            <a id="addorgbtn" class="ui button basic"><i class="icon add"></i> Organization</a>
                    </div></div>
                    <div id="un" class="field">
                        <label for="eventname">Event Name</label>
                        <input type="text" maxlength="256" required placeholder="Make it outstanding" name="eventname" id="eventname">
                    </div>
                    <div id="vcp" class="two fields">
                        <div class="eight wide field">
                            <label for="captcha">Category</label>
                            <select id="category" required name="category" class="ui dropdown">
                                    <option value=""></option>
                                    <option value="Charity">Charity</option>
                                    <option value="Fair">Fair</option>
                                    <option value="Workshop">Workshop</option>
                                    <option value="Courses">Course</option>
                                    <option value="Fundraising">Fundraising</option>
                                    <option value="Trip">Trip</option>
                                    <option value="Others">Others</option>
                            </select>
                        </div>
                        <div class="eight wide field">
                            <label for="captcha">Price (RM)</label>
                            <input type="number" maxlength="4" min="0" max="1000" required name="price" id="price" value="0">
                        </div>
                    </div>
                    <div id="un" class="field">
                        <label for="eventname">Venue</label>
                        <input type="text" maxlength="100" required placeholder="Where is the event held on" name="location" id="location">
                    </div>
                    <div id="pf" class="two fields">
                        <div class="field">
                            <label for="eventdate">Date</label>
                            <input type="date" value="2018-01-10" required name="eventdate" id="eventdate">
                        </div>
                        <div class="field">
                            <label for="eventdate">Time</label>
                            <input type="time" required name="eventtime" id="eventtime">
                        </div>
                    </div>
                    <div id="pfc" class="field">
                        <label for="passworddc">Description</label>
                        <textarea maxlength="2000" required name="description" id="description"></textarea>
                    </div>
                    <button type="submit" class="ui button primary">Create</button>
                </form>
                <div class="footnote">Please ensure the description doesn't contains illegal characters.</div>
            </main>
            <div class="ui modal" id="orgMod">
                    <div class="header">Add Organization</div>
                    <div class="scrolling content">
                      <form id="oForm" class="ui form">
                          <div class="field">
                              <label>Name</label>
                              <input type="text" name="name" id="name" required>
                          </div>
                          <div class="field">
                              <label>Contact</label>
                              <input type="text" name="contact" id="contact" required>
                          </div>
                          <div class="field">
                              <a id="addO" class="ui button primary">Add</a>
                          </div>
                      </form>
                    </div>
                  </div>
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
    function getAllOrg() {
        xhrRequest('GET','api/v1/orgs',null, function(data){
            frm.$data.orgs = data
        });
    }
    var frm = new Vue({
        el: "#app",
        data: {
            orgs: [],
            eventName: null,
            price: 0,
            category: null,
            description: "",
            date: null,
            time: null,
        },
        methods: {
           
        }
    });
    getAllOrg();
    $('.ui.dropdown').dropdown();
    $('#addorgbtn').click(function(){
        $("#orgMod").modal('show');
    });
    $('#addO').click(function(){
        xhrRequest('POST','api/v1/createOrg', $('#oForm').serialize(), function(data){
            window.location.href=""
        });
    })
</script>
        </html>
