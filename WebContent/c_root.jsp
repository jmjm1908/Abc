<% // InQuira Build Version: 8.5.1.5.4 %> 
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" language="java" %>

 
<%@ page import="java.text.*, java.util.*,java.awt.*,com.webobjects.eocontrol.*,com.inquira.client.configuration.Configuration, com.inquira.foundation.utilities.CVEncryption" errorPage="" %><%@ taglib uri="/IMTaglib" prefix="IM" %><%        
String widgetviewParam = request.getHeader("widgetview");
boolean widgetview = false;
if ("true".equals(widgetviewParam)) {
        widgetview = true;
} else {
    widgetviewParam = request.getParameter("widgetview");
        if ("true".equals(widgetviewParam)) {
                widgetview = true;
    }
}
        String strPage = request.getParameter("page");
        String answersPage = (String)session.getAttribute("answersPage");
    if (answersPage == null) {
            answersPage = request.getHeader("answersPage");
    }
        if(answersPage==null){answersPage="answers";}
        String strNewGuid = request.getParameter("newguid");
        String strGuid = request.getParameter("guid");
        if (strGuid==null){strGuid="";}
        String strPmv = request.getParameter("pmv");
        String strCat = request.getParameter("cat");
        String catParam = "";
        if(null != strCat){
                catParam = "&cat=" + strCat.replaceAll("\\s", "+");
        }
        boolean binPMV = (strPmv!= null);
        boolean printerFriendly = false;
        if(binPMV && strPmv.equals("print")) printerFriendly = true; 
        boolean binPortlet =(strPage!=null && strPage.equals("detail_pagelet"));
        boolean includeDraft = false;
        String showDraft = request.getParameter("showDraft");
        boolean impressions = true;
        String impressionStr = request.getParameter("impressions");
        String strVersion="";
        if ( impressionStr != null && impressionStr.equals("false")) {
            impressions = false;
        }
        if ( showDraft != null && showDraft.equals("true")) {
                includeDraft = true;
        }
        String homePrefix = (Configuration.getStringForKey("homePrefix")==null ? "":Configuration.getStringForKey("homePrefix") );
        String homePageURL = Configuration.getStringForKey("homePageURL");
        String homeAlias = (Configuration.getStringForKey("homeAlias")!=null&&!"".equals(Configuration.getStringForKey("homeAlias").trim()) ? Configuration.getStringForKey("homeAlias"):com.inquira.client.resources.MessageResources.get("Home"));
        String languageDirection = (String)session.getAttribute("languageDirection");
        if (!"rtl".equals(languageDirection)) {
                languageDirection = "ltr";
        }
        %><%!
public String fnBuildLink(String strLink) {
        String strOut = "";
        if(strLink!=null) {
                strOut = "<a href=\"";
                if(strLink.indexOf("http://")>-1 || strLink.indexOf("https://")>-1) {
                        strOut += strLink;
                } else {
                        strOut += "http://" + strLink;
                }
                strOut += "\">" + strLink +"</a>";
        }
        return strOut;
}
%><%@ include file="/apps/infocenter/system/methods/i_date.jsp"%><%@ include file="/apps/infocenter/system/methods/link.jsp" %><%@ include file="/apps/infocenter/system/methods/i_common_methods.jsp" %><%
boolean binUseViewFilter = false;
try {
        binUseViewFilter = Configuration.getBooleanForKey("useViewFilter");
} catch (Exception E) {}

String searchid = request.getParameter("searchid");
if (searchid == null){
        searchid = request.getHeader("searchid") == null? "" : request.getHeader("searchid");        
}

String strView = (String)session.getAttribute("userView");
String strID = request.getParameter("id");
boolean notRated = true;
String ratedValue = null;
boolean isContentOwner = false;
// if the content(docid) is rated, the docid will be store in ratedDocList(in session)
Object currentUser = session.getAttribute("user");
if(currentUser == null){
        // fetch the user rating information for user without login
        currentUser = "guest";
}
Map<Object, Map<String, String>> ratedUserMap = (Map<Object, Map<String, String>>)session.getAttribute("ratedUserMap");
if(ratedUserMap != null){
        Map<String, String> ratedDocMap = ratedUserMap.get(currentUser);
        if(ratedDocMap != null){
                ratedValue = ratedDocMap.get(strID);        
        }
}

// add configuration for allow user rating one content multiple times
notRated = Configuration.getBooleanForKey("allowMultiContentRating") || (ratedValue == null);

String strActivityType = request.getParameter("actp");
String strLocale = request.getParameter("viewlocale");
String strLocaleDefault = getDefaultLocaleStr(request,response);

if(strLocale==null || "".equals(strLocale))
strLocale = strLocaleDefault;

String[] strs=null;
if(strLocale.contains("_"))
strs = strLocale.trim().split("_");
if(strLocale.contains("-"))
strs = strLocale.trim().split("-");        
Locale locale = new Locale(strs[0],strs[1]);
ComponentOrientation ce = ComponentOrientation.getOrientation(locale);

String[] strsDefault=null;
if(strLocaleDefault.contains("_"))
strsDefault = strLocaleDefault.trim().split("_");
if(strLocaleDefault.contains("-"))
strsDefault = strLocaleDefault.trim().split("-");        
Locale localeDefault = new Locale(strsDefault[0],strsDefault[1]);
ComponentOrientation ceDefault = ComponentOrientation.getOrientation(localeDefault);


String strLocaleAlign = "textleft";
String strLocaleHeader = "im-content-head-left";
String strLocaleContent1 = "im-content-head-left";
String strLocaleContent2 = "im-content-head-right";
String strLocaleTableAlign = "left";


if((ceDefault.isLeftToRight() && !ce.isLeftToRight()) || (!ceDefault.isLeftToRight() && ce.isLeftToRight()) )
{
 strLocaleAlign = "textright";
 strLocaleHeader = "im-content-head-right";
 strLocaleContent1 = "im-content-head-right";
 strLocaleContent2 = "im-content-head-left";
 strLocaleTableAlign = "right";
 }
String myCat = request.getParameter("cat");
String strAction = request.getParameter("act");
String strCase = request.getParameter("lbc");
String strCategories="";
String strCats="";
String strRepository = "";
String strResourcePath=Configuration.getStringForKey("appResources");
boolean showDiscussions=false;
boolean showRatings=false;
int numPlaceholder = 1;
boolean binNode  =false;
String strChannel = null;
boolean binFound  =false;
String strQS = request.getAttribute("queryString") == null? "": (String)request.getAttribute("queryString");
        strQS = strQS.replace("page=","");
        String strScheme =  request.getScheme();
String strURL = buildServerURL(request);
strURL += "index?page="+strQS;
String localeCode="";
String datemask="MMMM dd, yyyy";%>
<IM:get.session.locale.attribute.value id="local"><%
localeCode=local.code; 
String sessionDatemask=local.dateformatdisplay.replace('m', 'M');
if(sessionDatemask != null){
   datemask = sessionDatemask.trim().equals("")?datemask:sessionDatemask;
}
%></IM:get.session.locale.attribute.value>
<%
if(!binPMV){
        %><script language="javascript">
        function OpenEmailArticleWindow(querystring)
        {
                LeftPosition = (screen.width) ? (screen.width)/10 : 0;
                TopPosition = (screen.height) ? (screen.height)/10 : 0;
                settings = "menubar=no,height=424,width=600,resizable=no,scrollbars=yes"
                hWin = window.open(querystring, "SaveArticle", settings, true);
                hWin.focus();
                if (hWin.opener == null) hWin.opener = self;
        }
        </script><%
}
boolean binAdmin = false;
%><IM:is.admin><%binAdmin = true;%></IM:is.admin><%boolean binLogin = false;%><IM:is.loggedin><%binLogin = true;%></IM:is.loggedin><%
if(!binAdmin){ 
        if(strID!=null){
                strID=strID.toUpperCase().replace("S:","");
        }
}
if(!binLogin){
        includeDraft = false;
}
%><IM:get.repository.attribute.value systemattribute="refkey" id="idRepository"><%strRepository=idRepository.value;%></IM:get.repository.attribute.value> 
<IM:get.channel.record impressions="<%=impressions%>" documentid="<%=strID%>" id="cr" activitytype="<%=strActivityType%>" localecode="<%=strLocale%>" features="views+categories+security" uservisits="true" securedbyview="<%= binUseViewFilter %>" views="<%= strView %>" includedraft="<%= includeDraft %>"><% 
binFound=true;
if(strID==null){
        %><IM:get.channel.attribute.value attribute="DOCUMENTID" id="docid"><%  strID = docid.value; %></IM:get.channel.attribute.value><%
}
%><IM:get.channel.attribute.value attribute="TYPE" id="ch"><%  strChannel = ch.value; %></IM:get.channel.attribute.value>
<div class="node <%=strChannel%>"><% 
        String strNode="//"+strChannel;
        %><IM:get.metadata.record id="mrec" type="channel" referencekey="<%=strChannel%>"><%showDiscussions=mrec.hasdiscussion; showRatings=mrec.hasratings;%></IM:get.metadata.record><%
if((Configuration.getBooleanForKey("allowAnonymousRating") || binLogin) && !binPMV && cr.isPublished){ 
        if ((cr.islive)&&((strAction==null)||(!strAction.equals("RATE")))&&(showRatings&&notRated)) {
                if(binAdmin && !Configuration.getBooleanForKey("allowAnonymousRating")){
                        %><IM:get.channel.attribute.value attribute="OWNERID" id="owner"> <IM:get.user.record id="expert" generatexml="false"><%
                        if(expert.guid.equals(owner.value)){showRatings=false;isContentOwner=true;}
                        %></IM:get.user.record> </IM:get.channel.attribute.value><%
                }
                
        }
} else {
        showRatings = false;
}
if(!binPMV && !binPortlet){
        if(!widgetview){
        %>
        <div>
                <div class="left">
                        <div class="pagecrumbs">
                                <jsp:include flush="false" page="/apps/infocenter/system/components/categories/c_crumby_detail.jsp">
                                        <jsp:param name="page" value="<%= strPage %>" />
                                        <jsp:param name="channel" value="<%= strChannel %>" />
                                </jsp:include>
                        </div>
				<table border="0" cellpadding="3" cellspacing="0">
                                <tbody>
                                        <tr><td>
										<input class="back-image button-feature" style="background-image:url('<%=strResourcePath%>images/search.png');" value="<IM:get.localized.text key="Root.back"/>" alt="<IM:get.localized.text key="Back_to_Answers"/>" type="button" onclick=$(".search").slideToggle("1000");$("textarea.searchbox-example1,.searchbox").focus(); >
										<input class="back-image button-feature" style="background-image:url('<%=strResourcePath%>search/icon_cms-xml.gif');" value="<IM:get.localized.text key="Root.viewAll"/> <IM:get.localized.name type="CHANNEL" referencekey="<%=strChannel%>"/>" alt="<IM:get.localized.text key="Root.back2All"/>" type="button" onclick="location.href='index?page=<%=strPage%>&channel=<%=strChannel%>'" >
										<%if(cr.isPublished && binLogin){%>
                                                <IM:is.subscribed type="CONTENT" recordid="<%=strID%>" viewlocale="<%=strLocale%>" id="sub">
                                                        <input class="back-image button-feature" style="background-image:url('<%=strResourcePath%>forums/find_16x16_clearbg.gif');" value="<IM:get.localized.text key="Cancel_Subscription"/>" alt="<IM:get.localized.text key="Cancel_Subscription"/>" type="button" onclick="location.href='index?page=subscribe_toggle&return=content&type=CONTENT&unsubscribe=true&id=<%=strID%><%=catParam%>&viewlocale=<%=strLocale%>&subscriptionid=<%=sub.subscriptionid%>'" >
                                                </IM:is.subscribed>
                                                <IM:is.subscribed type="CONTENT" recordid="<%=strID%>" negate="true" viewlocale="<%=strLocale%>">
                                                        <input class="back-image button-feature" style="background-image:url('<%=strResourcePath%>forums/find_16x16_clearbg.gif');" value="<IM:get.localized.text key="List.subscribe"/>" alt="<IM:get.localized.text key="List.subscribe"/>" type="button" onclick="location.href='index?page=subscribe_toggle&return=content&type=CONTENT&id=<%=strID%><%=catParam%>&viewlocale=<%=strLocale%>'" >
                                                </IM:is.subscribed><%}%>
                                                        <input class="back-image button-feature" style="background-image:url('<%=strResourcePath%>images/printer3_16x16.png');" value="<IM:get.localized.text key="Root.printFriendly"/>" alt="<IM:get.localized.text key="Printer_friendly_version"/>" type="button" onclick="location.href='index?page=<%=strPage%>&id=<%=strID%>&pmv=print&impressions=false<%if(strLocale!=null){%>&viewlocale=<%=strLocale%><%}%>'" >
                                                <%
                                                if (Configuration.getBooleanForKey("displayMailButton") && (binLogin || Configuration.getBooleanForKey("allowAnonymousEmail"))) {
                                                %>
                                                        <input class="back-image button-feature" style="background-image:url('<%=strResourcePath%>images/mail_16x16.gif');" value="<IM:get.localized.text key="Root.emailPage"/>" alt="<IM:get.localized.text key="Root.emailPage"/>" type="button" onclick="OpenEmailArticleWindow('index?page=mailpage&sendcontent=<%=strPage%>&id=<%=strID%><%if(strLocale!=null){%>&viewlocale=<%=strLocale%><%}%>')" >
                                                <%}%>
										<input class="back-image button-feature" style="background-image:url('<%=strResourcePath%>images/star_yellow_16x16.png');" value="<IM:get.localized.text key="Root.ratePage"/>" alt="<IM:get.localized.text key="Rating.rateContent"/>" type="button" onclick="location.href = location.href.indexOf('#rate')>0 ? location.href : location.href + '#rate'" >										
										</td></tr>
                                </tbody>
                        </table>
                </div>
     
                <div class="right">
                        <table border="0" cellpadding="3" cellspacing="0">
                                <tbody>
                                        <tr><td class="text-align-right">
                                        </td></tr>
                                </tbody>
                        </table>
			
                </div>
        </div>

        <%}%>
		 		

        <div class="im-clearDiv"><div><jsp:include flush="false" page="/apps/infocenter/system/components/search/c_ask_box.jsp" />
        <%
}
%><h1 class="im-content-title"><IM:get.channel.attribute.value attribute="MASTERIDENTIFIER" id="myattribute" ><% if (myattribute.exists && myattribute.value!= null) { %><IM:encode.text text="<%= myattribute.value %>" isContentAttribute="true" /><% } %></IM:get.channel.attribute.value></h1><%
        if (!binPMV && !widgetview){
                %><IM:is.subscribed type="CONTENT" recordid="<%=strID%>" id="sub" viewlocale="<%=strLocale%>">
                  <div id="im-question-box" class="im-infobox">
                        <table border="0" cellpadding="2" cellspacing="0">
                        <tbody>
                          <tr>
                                <td width="24" valign="top"><img src="<%=strResourcePath%>forums/information_24x24.gif" alt="" border="0"></td>
                                <td> <% String[] timeResults = timeToConvert(sub.enddate, "Root.subscriptionDoc");
                                if("".equals(timeResults[0])){%>
                                        <IM:get.localized.text key="<%=timeResults[1] %>" parameters="<%=new String[]{strID} %>"/>
                                <%}else{%>
                                        <IM:get.localized.text key="<%=timeResults[1] %>" parameters="<%=new String[]{strID, timeResults[0]} %>"/>
                                <%}%> (<a href="index?page=subscribe_renew&id=<%=sub.subscriptionid%>" ><IM:get.localized.text key="Renew.Click"/></a>).&nbsp; <IM:get.localized.text key="List.cancelSubs"/>. </td>
                          </tr>
                        </tbody>
                        </table>
                  </div>
                </IM:is.subscribed>
                <%@ include file="/apps/infocenter/system/components/i_actions.jsp" %><%
        }
if(!binPMV && !binPortlet){
        %><!--div class="im-buttons">
        <table border="0" cellpadding="3" cellspacing="0">
        <tbody>
          <tr><td><%
  if(!widgetview){
        if(strActivityType!=null && strActivityType.toUpperCase().equals("SEARCH")){%>
                        <input class="back-image button-feature" value="<IM:get.localized.text key="Root.back"/>" alt="<IM:get.localized.text key="Back_to_Answers"/>" type="button" onclick="location.href='index?page=<%=answersPage%>&type=currentpaging&searchid=<%=searchid%>'" >
                        <input class="back-image button-feature" value="<IM:get.localized.text key="Root.viewAll"/> <IM:get.localized.name type="CHANNEL" referencekey="<%=strChannel%>"/>" alt="<IM:get.localized.text key="Root.back2All"/>" type="button" onclick="location.href='index?page=<%=strPage%>&channel=<%=strChannel%>'" >
                <%
        }else if(strActivityType!=null && strActivityType.toUpperCase().equals("LIST_BY_CASE") && strCase!=null){
                %>
                        <input class="back-image button-feature" value="<IM:get.localized.text key="Root.back"/>" alt="<IM:get.localized.text key="Root.back2Articles"/>" type="button" onclick="location.href='index?page=<%=strPage%>&case=<%=strCase%>&id=<%=strID%>'" >
                        <input class="back-image button-feature" value="<IM:get.localized.text key="Root.viewAll"/> <IM:get.localized.name type="CHANNEL" referencekey="<%=strChannel%>"/>" alt="<IM:get.localized.text key="Root.back2All"/>" type="button" onclick="location.href='index?page=<%=strPage%>&channel=<%=strChannel%>'" >
                <%
        }else {
                %>
                        <input class="back-image button-feature" value="<IM:get.localized.text key="Root.back"/>" alt="<IM:get.localized.text key="Root.back2Category"/>" type="button" onclick="location.href='index?page=<%=answersPage%>'" >
                <%
        }
   }
        if(binAdmin && !widgetview){
                if(!cr.isLatestVersion){
                        %>
                                <input class="back-image button-feature" style="background-image:url('<%=strResourcePath%>images/document_refresh_16x16.gif');" value="<IM:get.localized.text key="Root.viewLatest"/>" alt="<IM:get.localized.text key="Root.viewLatest"/>" type="button" onclick="location.href='index?page=<%=strPage%>&id=S:<%= strID.replace("S:","") %>&actp=<%=strActivityType%><%if(strLocale!=null){%>&viewlocale=<%=strLocale%><%}%>'" >
                        <%
                } else {
                        if((strID.indexOf("S:")>=0) && !cr.isPublished){
                                %><IM:get.channel.record.exists documentid="<%= strID.replace(\"S:\",\"\")%>">
                                
                                        <input class="back-image button-feature" style="background-image:url('<%=strResourcePath%>images/document_certificate_16x16.gif');" value="<IM:get.localized.text key="Root.viewPublished"/>" alt="<IM:get.localized.text key="Root.viewPublished"/>" type="button" onclick="location.href='index?page=<%=strPage%>&id=<%= strID.replace("S:","") %>&actp=<%=strActivityType%>&publishedview=true<%if(strLocale!=null){%>&viewlocale=<%=strLocale%><%}%>'" >
                                
                                </IM:get.channel.record.exists><%
                        }
                }
        }
        if(cr.isPublished && showRatings && notRated){
                %>
                        <input class="back-image button-feature" style="background-image:url('<%=strResourcePath%>images/star_yellow_16x16.gif');" value="<IM:get.localized.text key="Root.ratePage"/>" alt="<IM:get.localized.text key="Rating.rateContent"/>" type="button" onclick="location.href = location.href.indexOf('#rate')>0 ? location.href : location.href + '#rate'" >
                <%
        }        
        if (cr.isPublished && !widgetview){
                if( showDiscussions && !binPortlet){
                        %>
                                <input class="back-image button-feature" style="background-image:url('<%=strResourcePath%>forums/message_add_16x16.gif');" value="<IM:get.localized.text key="Root.postComment"/>" alt="<IM:get.localized.text key="Root.postComment"/>" type="button" onclick="location.href='index?page=feedback&id=<%=(((strID)==null)?(strID):java.net.URLEncoder.encode(strID))%>&parent=<%=cr.recordid%>'" >
                        <%
                }
                if(binLogin){
                        if(binAdmin){
                                %>
                                        <input class="back-image button-feature" style="background-image:url('<%=strResourcePath%>images/document_info_16x16.gif');" value="<IM:get.localized.text key="Root.recommendChange"/>" alt="<IM:get.localized.text key="Root.recommendChange"/>" type="button" onclick="location.href='index?page=recommend&id=<%=(((strID)==null)?(strID):java.net.URLEncoder.encode(strID))%>&rp=content'" >
                                <%
                        } else {
                                if(Configuration.getBooleanForKey("displayContentRecommendationsForWebUsers")){
                                        %>
                                                <input class="back-image button-feature" style="background-image:url('<%=strResourcePath%>images/document_info_16x16.gif');" value="<IM:get.localized.text key="Root.recommendChange"/>" alt="<IM:get.localized.text key="Root.recommendChange"/>" type="button" onclick="location.href='index?page=recommend&id=<%=(((strID)==null)?(strID):java.net.URLEncoder.encode(strID))%>&rp=content'" >
                                        <%
                                }
                        }
                }
        }
        if(Configuration.getBooleanForKey("displayManageLink") && !widgetview){
                if(binAdmin){
                                %><IM:get.privileges><IM:get.privileges.value privilege="EDIT">
                                        <input class="back-image button-feature" style="background-image:url('<%=strResourcePath%>images/document_gear_16x16.gif');" value="<IM:get.localized.text key="Root.manageDoc"/>" alt="<IM:get.localized.text key="Root.manageDoc"/>" type="button" onclick="window.open('<IM:get.management.console.url/>?<IM:manage.content action="MANAGE" success="<%=strURL%>" error="<%=strURL%>" localecode="<%=strLocale%>" />', '_management')" >
                                </IM:get.privileges.value></IM:get.privileges><%
                }
        }
        %></td></tr>
        </tbody>
        </table>
        </div--><%
}
%>

<div class = "<%=strLocaleAlign%>">

<div class="<%=strLocaleHeader%>">
<!--div class="<%=strLocaleContent1%>">
<%-- get channel from content record --%>
<table border="0" cellpadding="2" cellspacing="0" class = "<%=strLocaleAlign%>" width="100%" align="<%=strLocaleTableAlign%>">
  <tr>                                                        <%-- minor issue fix: change the channel name to "Doc" here --%>
    <td class="textright"><strong><IM:get.localized.text key="Doc.ID"/></strong></td>
    <td>&nbsp;&nbsp;</td>
    <td><IM:get.channel.attribute attribute="DOCUMENTID"/></td>
  </tr>
  <tr>
    <td class="textright"><strong><IM:get.localized.text key="Version"/></strong></td>
    <td>&nbsp;&nbsp;</td>
    <td><IM:get.channel.attribute attribute="VERSION"/></td>
  </tr><%
  if (cr.isPublished){ %>
  <tr>
    <td class="textright"><strong><IM:get.localized.text key="Status"/></strong></td>
    <td>&nbsp;&nbsp;</td>
    <td><IM:get.localized.text key="Root.published"/></td>
  </tr>
   <tr>
    <td class="textright"><strong><IM:get.localized.text key="Published_date"/></strong></td>
    <td>&nbsp;&nbsp;</td>
    <td><IM:get.channel.attribute attribute="PUBLISHEDTIMESTAMP" mask="<%=datemask%>" type="date"/></td>
  </tr>	
  <%} else {%>
  <tr>
    <td class="textright"><strong><IM:get.localized.text key="Status"/></strong></td>
    <td>&nbsp;&nbsp;</td>
    <td><IM:get.localized.text key="Root.unpublished"/></td>
  </tr>
  <%} %>
  <IM:get.channel.attribute.value attribute="VERSION" id="version"><%
  strVersion = version.value;
  if(!strVersion.equals("1.0")){
          %><tr>
    <td class="textright"><strong><IM:get.localized.text key="Updated"/></strong></td>
    <td>&nbsp;&nbsp;</td>
    <td><IM:get.channel.attribute attribute="LASTMODIFIEDTIMESTAMP" mask="<%=datemask%>" type="date"/></td>
          </tr><%
  }
  %></IM:get.channel.attribute.value>
</table>
</div-->

<div class="<%=strLocaleContent2%>">
<%
        if(binAdmin){
%>
<table border="0" cellpadding="2" cellspacing="0" class = "<%=strLocaleAlign%>" align="<%=strLocaleTableAlign%>">
    <tbody>   
            <IM:get.channel.attribute.exists attribute="CATEGORIES/CATEGORY/REFERENCE_KEY">
                    <%boolean splitFlag = false;%>
                    <tr>
                            <td class="textright"><strong><IM:get.localized.text key="ContentRC.Category"/>:</strong></td>
                            <td>&nbsp;&nbsp;</td>
                            <td>
                                    <IM:iterate.channel.records node="CATEGORIES/CATEGORY" id="test">
                                            <IM:get.channel.record id="mycat" impressions="false">
                                                        <%if(splitFlag){%>,<%}else{
                                                                splitFlag = true;
                                                        }%>
                                                        
                                                        <%if(!widgetview){%><a href="index?page=content&channel=<%=strChannel%>&cat=<IM:get.channel.attribute attribute="REFERENCE_KEY"/>"><%}%>
                                                                <IM:get.channel.attribute attribute="NAME"/>
                                                        <%if(!widgetview){%></a><%}%>
                                            </IM:get.channel.record>
                                    </IM:iterate.channel.records>
                            </td>
                    </tr>
                </IM:get.channel.attribute.exists>
    
            <IM:get.channel.attribute.value id="fisrtug" attribute="SECURITY/USERGROUP/REFERENCE_KEY"><%
                    if(fisrtug!=null && !fisrtug.value.equals("NULLTAG")){%>
                            <tr>
                                    <td class="textright"><strong><IM:get.localized.text key="ContentRC.Available"/>:</strong></td>
                                    <td>&nbsp;&nbsp;</td>
                                    <td>
                                            <%boolean splitFlag = false;%>
                                                <IM:iterate.channel.records node="SECURITY/USERGROUP" id="test">
                                                    <IM:get.channel.record id="mycat" impressions="false">
                                                            <%
                                                                    if(splitFlag){
                                                                            %>,<%
                                                                    }else{
                                                                            splitFlag = true;
                                                                    }
                                                            %>
                                                                <IM:get.channel.attribute attribute="NAME"/>
                                                        </IM:get.channel.record>
                                                </IM:iterate.channel.records>
                                    </td>
                            </tr>
                   <%}%>
                </IM:get.channel.attribute.value>
            
    
        <tr>
            <td class="textright"><strong><IM:get.localized.text key="ContentRC.Author"/>:</strong></td>
            <td>&nbsp;&nbsp;</td>
            <td>
                          <IM:get.channel.attribute.value attribute="AUTHORID" id="author">
                              <IM:get.user.record id="expert" recordid="<%=author.value%>" generatexml="false">
                                          <table border="0" cellpadding="1" cellspacing="0">
                                                <tbody>
                                                  <tr>
                                                        <td><%if(!widgetview){%><a href="index?page=user_profile&user=<%=expert.guid%>&rp=<%= strQS %>"><%}
                                                                if(expert.showName){
                                                                        %><%=expert.firstname%> <%=expert.lastname%><%
                                                                }else{
                                                                        if(expert.alias!=null){
                                                                                %><%=expert.alias%><%
                                                                        }else{
                                                                                %><%=expert.firstname%> <%=expert.lastname%><%
                                                                        }
                                                                }
                                                                if(!widgetview){%></a><%}%> </td>
                                                  </tr>
                                                </tbody>
                                            </table>
                              </IM:get.user.record>
                          </IM:get.channel.attribute.value>
                        </td> 
                </tr> 
        </tbody>
</table>        
<%} else {
        if(Configuration.getBooleanForKey("displayAuthorForWebUsers")){%>
                <table border="0" cellpadding="2" cellspacing="0" class = "<%=strLocaleAlign%>" align="<%=strLocaleTableAlign%>"> 
                        <tbody>
                                <IM:get.channel.attribute.exists attribute="CATEGORIES/CATEGORY/REFERENCE_KEY">
                                        <%boolean splitFlag = false;%>
                                        <tr>
                                                <td class="textright"><strong><IM:get.localized.text key="ContentRC.Category"/>:</strong></td>
                                                <td>&nbsp;&nbsp;</td>
                                    <td>
                                                        <IM:iterate.channel.records node="CATEGORIES/CATEGORY" id="test">
                                                                <IM:get.channel.record id="mycat" impressions="false">
                                                                        <%if(splitFlag){%>
                                                                                ,
                                                                        <%}else{
                                                                                splitFlag = true;
                                                                        }%>
                                                                        <%if(!widgetview){%><a href="index?page=content&channel=<%=strChannel%>&cat=<IM:get.channel.attribute attribute="REFERENCE_KEY"/>"><%} %>
                                                                                <IM:get.channel.attribute attribute="NAME"/>
                                                                        <%if(!widgetview){%></a><%} %>
                                                                </IM:get.channel.record>
                                                        </IM:iterate.channel.records>
                                                  </td>
                                                
                                        </tr>
                          </IM:get.channel.attribute.exists></div>
                        
                                <tr>
                                        <td class="textright"><strong><IM:get.localized.text key="ContentRC.Author"/>:</strong></td>
                                        <td>&nbsp;&nbsp;</td>
                            <td>
                                    <IM:get.channel.attribute.value attribute="AUTHORID" id="author">
                                            <IM:get.user.record id="expert" recordid="<%=author.value%>" generatexml="false">
                                                                  <table border="0" cellpadding="1" cellspacing="0">
                                                                        <tbody>
                                                                          <tr>
                                                                                <td><%if(!widgetview){%><a href="index?page=user_profile&user=<%=expert.guid%>&rp=<%= strQS %>"><%}
                                                                                if(expert.showName){
                                                                                                  %><%=expert.firstname%> <%=expert.lastname%><%
                                                                                        }else{
                                                                                                if(expert.alias!=null){
                                                                                                        %><%=expert.alias%><%
                                                                                                }else{
                                                                                                        %><%=expert.firstname%> <%=expert.lastname%><%
                                                                                                }
                                                                                        }
                                                                                        %><%if(!widgetview){%></a><%} %></td>
                                                                          </tr>
                                                                        </tbody>
                                                                </table>
                                                        </IM:get.user.record>
                                                </IM:get.channel.attribute.value>
                            </td>
                                </tr>
                        </tbody>
                </table>
        <%}
}%>
</div>
</div>

<div class="line_dash im-clearDiv">&nbsp; </div>

<IM:get.schema.data type="CHANNEL" referencekey="<%=strChannel%>"  dataset="sd"/><IM:iterate.dataset dataset="sd" id="it"><IM:get.schema.item id="si"><%
if(!si.ismasteridentifier){
        %><%@ include file="c_attribute.jsp" %><%
}
if (si.isnode ){
        %><div class="<%= si.referencekey %>">
          <jsp:include flush="false" page="c_recordnode.jsp"><jsp:param name="parent" value="<%=si.xpath%>"/>
          <jsp:param name="id" value="<%=strID%>"/>
          <jsp:param name="schemaDataType" value="CHANNEL"/>
          <jsp:param name="binNode" value="true"/>
          </jsp:include>
        </div><%
}
%></IM:get.schema.item></IM:iterate.dataset>
<%-- display META schema --%>
<IM:get.schema.data type="META" referencekey="<%=strChannel%>"  dataset="sdm"/>
 <IM:iterate.dataset dataset="sdm" id="itsdm">
   <IM:get.schema.item id="si"><%
           pageContext.setAttribute("isMeta","true",pageContext.PAGE_SCOPE);
                if(!si.ismasteridentifier){
                        %><%@ include file="c_attribute.jsp" %><%
                }
                if (si.isnode ){
                        %><div class="<%= si.referencekey %>">
                          <jsp:include flush="false" page="c_recordnode.jsp"><jsp:param name="parent" value="<%=si.xpath%>"/>
                          <jsp:param name="id" value="<%=strID%>"/>
                          <jsp:param name="schemaDataType" value="META"/>
                          <jsp:param name="binNode" value="true"/>
                          </jsp:include>
                        </div><%
                }
   %></IM:get.schema.item>
</IM:iterate.dataset>

<%

        if(isContentOwner){
                // show user that the owner of the content is himself        
        %>
                <span class="im-rating-title-bold">
                        <IM:get.localized.text key="root.RatedLabel"/>
                </span>
                <IM:get.localized.text key="root.RatingForOwner"/>
        <%
        }else if(cr.isPublished && showRatings &&!binPMV){
                %>
                <IM:cache id="<%=strChannel%>" idonlykey="true" disablelogin="true" disablecache="true">
                <%@ include file="/apps/infocenter/system/components/ratings/m_rating.jsp"%>
                </IM:cache><%
        }

        if( cr.isPublished && showDiscussions && !binPortlet &&!binPMV && !widgetview){
                %><a name="comments"></a>
                <h2>
                <% String strChannelName = ""; %>
                <IM:get.localized.name.value type="CHANNEL" referencekey="<%=strChannel%>" id="strChannelID"><% strChannelName = strChannelID.value; %></IM:get.localized.name.value><IM:get.localized.text key="Root.discussThis" parameters="<%=new String[]{strChannelName} %>"/></h2>
                <%-- START: Top user options --%>
                <div class="im-buttons">
                  <table border="0" cellpadding="0" cellspacing="0">
                        <tbody>
                          <tr>
                                <%if(printerFriendly) { %>
                                <td class="in-icon"><img src="<%=strResourcePath%>forums/message_add_16x16.gif" alt="<IM:get.localized.text key="Root.postComment"/>" border="0" height="16" width="16"></td>
                                <td class="im-icon-label"><IM:get.localized.text key="Root.postComment"/></td>
                                <%} else { %>
                                <td>
                                        <input class="back-image button-feature" style="background-image:url('<%=strResourcePath%>forums/message_add_16x16.gif');" value="<IM:get.localized.text key="Root.postComment"/>" alt="<IM:get.localized.text key="Root.postComment"/>" type="button" onclick="location.href='index?page=feedback&id=<%=(((strID)==null)?(strID):java.net.URLEncoder.encode(strID))%>&parent=<%=cr.recordid%>'" >
                                </td><%}%>
                          </tr>
                        </tbody>
                  </table>
                </div>
                <%-- END: Top user options --%><%
        
        %><jsp:include flush="false" page="/apps/infocenter/system/components/discussions/c_displaymessages.jsp">
           <jsp:param name="id" value="<%=strID%>" />
           <jsp:param name="guid" value="<%=cr.recordid%>" />
           <jsp:param name="showreply" value="true" />
        </jsp:include>
        <p>&nbsp;</p><%
}
%></div>
</div>
</IM:get.channel.record><%
if(!binFound){
        %><div class="node norecordfound">
        <h1><IM:get.localized.text key="Root.articleNotFound"/><%if(!binLogin){%>; <IM:get.localized.text key="Root.tryLogin"/><%}%></h1>
        <div id="im-question-box" class="im-infobox">
          <table border="0" cellpadding="2" cellspacing="0">
                <tbody>
                  <tr>
                        <td width="24" valign="top"><img src="<%=strResourcePath%>images/warning_24x24.gif" alt="" border="0"></td>
                        <td><IM:get.localized.text key="Root.articleNotFoundDet"/>.  <%if(!binLogin){%><strong><IM:get.localized.text key="Root.needLogin2View"/></strong><%}%></td>
                  </tr>
                </tbody>
          </table>
        </div>
        </div></div><%
}%>