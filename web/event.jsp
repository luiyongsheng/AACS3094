<%@page import="java.text.SimpleDateFormat"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import = "java.io.*,java.util.*,eventio.*,java.util.Random" %>
<%
    ArrayList<eventio.domain.Ticket> allTickets = null;
    eventio.domain.Ticket selfTicket = new eventio.domain.Ticket();
    eventio.domain.Member self = new eventio.domain.Member();
    int memberLevel = 0;
    Object lvl = session.getAttribute("memberLevel");
    if(lvl != null) {
        memberLevel = Integer.parseInt(lvl.toString());
    }
    Object id = request.getParameter("id");
    int eventid = 0;
    if(id != null) {
        eventid = Integer.parseInt((String)id);
        eventio.domain.Event e = eventio.controller.EventController.getEvent(eventid);
        int organizer = e.getOrganizer();
        eventio.domain.Organization org = eventio.controller.OrganizationController.getOrganizer(organizer);
        allTickets = eventio.controller.TicketController.AllTickets(eventid);
        
%>
<!DOCTYPE html>

<head>
        <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
        <meta name="viewport" content="initial-scale=1,maximum-scale=1,width=device-width,user-scalable=no">
        <meta name="HandheldFriendly" content="true">
    <meta charset="utf-8">
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title><%=e.getEventName()%></title>
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
    <nav class="globalnav">
        <div class="content">
            <a href="/Assignment" class="logo">event
                <span>io</span>
            </a>
            <div class="right">
                <%
                    String username = (String)session.getAttribute("username");
                    if(username == null) { 
                    
                    %>
                    <a href="login.jsp">Login</a>
                    <a href="register.jsp">Register</a>
                    <% } else { 
                        self = eventio.controller.MemberController.getMember(username);
                        selfTicket = eventio.controller.TicketController.TicketLookup(eventid, self.getId());
%>
                    <a href="dashboard.jsp"><%=session.getAttribute("username")%></a>
                        <% } %>
            </div>
        </div>
    </nav>
    <main id="app" class="content eventPage">
        <div class="ui container">
            <div class="eventdate">
                            <%
                            String prix = "FREE";
                            if(e.getPrice() > 0) prix = "MYR " + String.format("%.2f", e.getPrice());
                            %>
                <p class="month"><%=new SimpleDateFormat("MMM").format(e.getEventDate())%></p>
                <p class="day"><%=(e.getEventDate().getDate())%></p>
            </div>
            <h1><%=e.getEventName()%></h1>
            <h3>by <%=org.getName()%></h3>
            <div class="ui label basic blue">#<%=e.getCategory()%></div>
            <div class="ui label basic teal"><i class="icon marker"></i> <%=e.getLocation()%></div>
            <%if(memberLevel >= 5) {%><a class="ui button small red basic" id="del" style="border-color: transparent;box-shadow:none!important">Delete Event</a><%}%>
            <div style="position:relative" id="desc">
                    <p class="description"><%
                    String[] descBreak = e.getDescription().split("\n");
                    for(String desc : descBreak) {
                        desc.replaceAll("\t", "");
                        desc.replaceAll("\n", "");
                    
                        if(desc != "") {
                    %>
                    <%=desc%><br>
                    <%}}%></p>
                    <textarea style="border:0;outline:0;width:100%;display:none;resize:none;font-family:inherit;color:inherit;font-size:inherit;line-height:inherit;min-height:300px" id="editor"><%=e.getDescription()%></textarea>
                    <% if (memberLevel >=5) { %><button class="circular ui icon button basic right floated">
                            <i id="pen" class="icon pencil"></i>
                    </button><%}%>
            </div>
            <% if(username == null) {
                %>
                <div class="ui message teal" style="display:inline-block;margin-bottom:12px;">
                    <p><i class="icon info circle"></i> Login now to get your ticket!</p>
                </div>
            <%
            }else { 
if(selfTicket == null) {
%>
<p></p>
            <a id="booking" class="ui labeled button large" tabindex="0">
                    <div id="attend" class="ui green button large">
                      <i class="ticket icon"></i> ATTEND
                    </div>
                    <div class="ui basic green left pointing label large"><%=prix%>
                    </div>
            </a><%}}%>
            <% 
                if(memberLevel >= 5) {
            %>
            
            <%}%>

            <div id="ticketWidget" class="ticket" <% if(selfTicket == null || username == null) { %> style="display:none;" <%}%>>
                    <widget type="ticket" class="--flex-column"> 
                            <div class="top --flex-column">
                               <div class="-bold"><%=e.getEventName()%></div>
                               <div class=""><%=e.getCategory()%></div>
                               <div class="deetz --flex-row-j!sb">
                                  <div class="event --flex-column">
                                     <div class="date"><%=new SimpleDateFormat("DD MMM YYYY").format(e.getEventDate())%></div>
                                     <div class="location -bold"><%=e.getLocation()%></div>
                                  </div>
                                  <div class=" --flex-column">
                                     <div class="label">Price</div>
                                     <div class="cost price -bold"><%=prix%></div>
                                  </div> 
                               </div> 
                            </div>
                            <div class="rip"></div>
                            <div class="bottom --flex-row-j!sb">
                               <svg id="barcode"></svg>
                            </div>
                         </widget>
            </div>
            <p></p>
            <%
            if(allTickets.size() > 0) {%>
            <div class="ui message yellow tiny" style="display:inline-block;margin:22px 0;">
                <p><i class="icon announcement"></i> <%=allTickets.size()%> others is joining this event.</p>
            </div>
            <%}%>
        </div>
        <div class="ui basic modal tiny">
                <div class="ui icon header">
                  <i class="delete calendar icon"></i>
                  <p style="margin-top:12px">Delete This Event</p>
                </div>
                <div class="content">
                  <p>Are you sure to perform this delete action? Deleted event cannot be recovered.</p>
                </div>
                <div class="actions">
                  <div class="ui green basic cancel inverted button">
                    <i class="ban icon"></i>
                    CANCEL
                  </div>
                  <div id="perfDel" class="ui red ok inverted button">
                    <i class="trash outline icon"></i>
                    DELETE
                  </div>
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
function edit() {
    xhrRequest('POST','api/v1/editdesc', {"desc":$('#editor').val(),"id":<%=e.getEventId()%>},function() 
    {
        window.location = '';
    });
}
var editmode = false;
$('.circular').click(function(){
    if(editmode == false) {
        $('#editor').val($('.description').text().trim().replace('\t\t','','g'));
        $('#editor').show();
        $('.description').hide();
        $("#pen").removeClass("pencil");
        $("#pen").addClass("save");
        $('.description').focus();
        editmode = true;
    }
    else {
        $('#editor').hide();
        $('.description').text('Saving...');
        $("#pen").addClass("pencil");
        $("#pen").removeClass("save");
        $('.description').show();
        editmode = false;
        edit();
    }
});
$("#booking").click(function(){
    $('#attend').addClass("loading");
    xhrRequest('POST', 'api/v1/buyticket', {e:<%=e.getEventId()%>}, function(data){
        JsBarcode("#barcode", data, {
        lineColor: "#222425",
        height: 30,
        });
        $("#booking").hide();
        $('#ticketWidget').show();
    });
})
<% if(selfTicket != null) { %>
JsBarcode("#barcode", <%=selfTicket.getId()%>, {
        lineColor: "#222425",
        height: 30,
        });
        <%}%>
    $('#del').click(function(){
        $('.ui.modal').modal('show');
    });
    $("#perfDel").click(function(){
        $('#app').addClass('disabled');
        xhrRequest('POST','api/v1/delEvent', {e:<%=e.getEventId()%>}, function(callback){
            if(callback == "true") window.location.href='/Assignment';
            else $('#app').removeClass('disabled');
        });
    })
</script>
</html>
<%}%>