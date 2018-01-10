<%-- 
    Document   : register
    Created on : Dec 20, 2017, 10:06:51 PM
    Author     : sheng
--%>
<%
Object username = session.getAttribute("username");
if(username != null) response.sendRedirect("index.jsp");
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
            <title>Register</title>
            <script src="https://code.jquery.com/jquery-3.2.1.min.js" integrity="sha256-hwg4gsxgFZhOsEEamdOYGBf13FyQuiTwlAQgxVSNgt4="
                crossorigin="anonymous"></script>
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/2.2.13/semantic.min.css" />
            <script src="https://cdnjs.cloudflare.com/ajax/libs/semantic-ui/2.2.13/semantic.min.js"></script>
            <link rel="stylesheet" href="css/ui.min.css" />
            <script src="https://cdnjs.cloudflare.com/ajax/libs/vue/2.5.13/vue.min.js"></script>
        </head>

        <script>
            function getHash() {
                $.ajax({
                    url: 'Captcha?hash=t',
                    dataType: 'text',
                    type: 'GET',
                    async: true,
                    statusCode: {
                        200: function (response) {
                            cpd = response
                        }
                    }
                });
            }
            var check = function () {
            }

            function loadCaptcha() {
                var i = document.getElementById("cap");
                i.src = 'Captcha?ts=' + new Date().getTime();
            }

            var cpd = "";

            var sha256=function c(d){function f(H,I){return H>>>I|H<<32-I}for(var m,n,g=Math.pow,h=g(2,32),l='length',o='',p=[],q=8*d[l],r=c.h=c.h||[],s=c.k=c.k||[],t=s[l],u={},v=2;64>t;v++)if(!u[v]){for(m=0;313>m;m+=v)u[m]=v;r[t]=0|g(v,.5)*h,s[t++]=0|g(v,1/3)*h}for(d+='\x80';d[l]%64-56;)d+='\0';for(m=0;m<d[l];m++){if(n=d.charCodeAt(m),n>>8)return;p[m>>2]|=n<<8*((3-m)%4)}for(p[p[l]]=0|q/h,p[p[l]]=q,n=0;n<p[l];){var x=p.slice(n,n+=16),y=r;for(r=r.slice(0,8),m=0;64>m;m++){var A=x[m-15],B=x[m-2],C=r[0],D=r[4],E=r[7]+(f(D,6)^f(D,11)^f(D,25))+(D&r[5]^~D&r[6])+s[m]+(x[m]=16>m?x[m]:0|x[m-16]+(f(A,7)^f(A,18)^A>>>3)+x[m-7]+(f(B,17)^f(B,19)^B>>>10)),F=(f(C,2)^f(C,13)^f(C,22))+(C&r[1]^C&r[2]^r[1]&r[2]);r=[0|E+F].concat(r),r[4]=0|r[4]+E}for(m=0;8>m;m++)r[m]=0|r[m]+y[m]}for(m=0;8>m;m++)for(n=3;n+1;n--){var G=255&r[m]>>8*n;o+=(16>G?0:'')+G.toString(16)}return o};
        </script>

        <body onload="loadCaptcha()">
            <style>
                * {
                    transition: color 256ms ease-out
                }

                body {
                    height: auto;
                    background:#fff;
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
            <main style="margin-top:100px;" id="app">
                <h1 style="text-align:center;margin-bottom:30px">Register</h1>
                <form class="ui form" action="api/v1/register" method="post">
                    <div class="field">
                        <label for="lastName">Name</label>
                        <div class="two fields">
                            <div class="field">
                                <input type="text" required name="fistName" maxlength="20" id="fistName" placeholder="Given Name">
                            </div>
                            <div class="field">
                                <input type="text" required class="error" name="lastName" maxlength="20" id="lastName" placeholder="Family Name">
                            </div>
                        </div>
                    </div>
                    <div id="un" class="field">
                        <label for="username">Username</label>
                        <input type="text" id="und" maxlength="12" required v-on:keyup="nameCollision" placeholder="Use a unique username" name="username" id="username">
                    </div>
                    <div id="pf" class="field">
                        <label for="password">Password</label>
                        <input type="password" required placeholder="Make it hard to guess" name="password" id="password"  v-on:keyup="passwordCheck">
                    </div>
                    <div id="pfc" class="field">
                        <label for="passworddc">Confirm Password</label>
                        <input type="password" required name="passworddc" id="passworddc" v-on:keyup="passwordCheck">
                    </div>
                    <div id="vcp" class="field">
                        <div class="eight wide field">
                            <label for="captcha">Captcha</label>
                            <input type="text"  maxlength="6" required name="captcha" id="capt" v-on:keyup="captchaValidate" placeholder="Click the image to reload">
                        </div>
                    </div>
                    <div class="field">
                        <img id="cap" alt="captcha data" title="Click to reload" onclick="loadCaptcha()">
                    </div>
                    <button type="submit" class="ui button primary" :disabled="!valid">Continue</button>
                </form>
                <div class="footnote">Have an account?
                    <a href="login.jsp">Login</a> now.</div>
            </main>
        </body>
<script>
    var frm = new Vue({
        el: "#app",
        data: {
            error: [0,0,0],
            valid: false
        },
        methods: {
            formValid: function() {
                this.valid = this.error[0] == 1 && this.error[1] == 1 && this.error[2] == 1;
            },
            nameCollision: function() {
                $.ajax({
                    url: "api/v1/username?u=" + $("#und").val(),
                    dataType: "text",
                    type: "GET",
                    async: true,
                    statusCode: {
                        200: function(response) {
                            if(response == "false") {
                                $('#un').removeClass("error");
                                $("#und").removeAttr("invalid");
                                frm.$data.error[0] = 1;
                            }
                            else {
                                $('#un').addClass("error");
                                $("#und").attr("invalid","true");
                                frm.$data.error[0] = 0;
                            }
                            frm.formValid();
                        }
                    }
                })
            },
            passwordCheck: function() {
                if (document.getElementById('password').value ==
                    document.getElementById('passworddc').value) {
                    document.getElementById('pf').classList.remove('error');
                    $("#password").removeAttr("invalid");
                    document.getElementById('pfc').classList.remove('error');
                    $("#passworddc").removeAttr("invalid");
                    this.error[1] = 1;
                } else {
                    document.getElementById('pf').classList.add('error');
                    $("#password").attr("invalid", "true");
                    document.getElementById('pfc').classList.add('error');
                    $("#passworddc").attr("invalid", "true");
                    this.error[1] = 0;
                }
                this.formValid();
            },
            captchaValidate: function() { 
                getHash();
                var cx = sha256(document.getElementById("capt").value);
                if (cx !== cpd) {
                    document.getElementById("vcp").classList.add("error");
                    this.error[2] = 0;
                }
                else {
                    document.getElementById("vcp").classList.remove("error");
                    this.error[2] = 1;
                }
                this.formValid();
            }
        }
    })

</script>
        </html>