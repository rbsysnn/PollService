<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="author" content="Romanov V.M.">
    <title>Poll Service: результаты опроса "${poll.name}"</title>
    <link href="/resources/css/bootstrap.css" rel="stylesheet">
    <script type="text/javascript" src="https://ajax.googleapis.com/ajax/libs/jquery/2.2.0/jquery.min.js"></script>
    <!-- HTML5 shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!--[if lt IE 9]>
    <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
    <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
</head>

<body>

<div class="navbar navbar-inverse navbar-fixed-top" role="navigation">
    <div class="container col-md-offset-2">
        <div class="navbar-header">
            <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
                <span class="sr-only">Toggle navigation</span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
                <span class="icon-bar"></span>
            </button>
            <a class="navbar-brand" href="/"><img height="35" src="/resources/img/sLogo_final.png"></a>
        </div>
        <div class="collapse navbar-collapse">
            <ul class="nav navbar-nav">
                <li class="active"><a href="/">Опросы</a></li>
                <li><a href="/results">Результаты</a></li>
                <li><a href="/manage">Управление</a></li>
                <li><a class="btn" id="clear" href="#"><span class="glyphicon glyphicon-log-out"></span></a></li>
            </ul>
        </div><!--/.nav-collapse -->
    </div>
</div>

<div class="container col-md-8 col-lg-offset-2" style="margin-top: 20px;">

    <div class="col-md-offset-1 col-md-10"><%--Container for questions--%>
        <c:forEach var="question" items="${poll.questions}">
            <div class="panel panel-default">
                <div class="panel-heading"><h4><c:out value="${question.name}"/></h4></div>
                <div class="panel-body">
                    <c:forEach var="option" items="${question.options}">
                        <div class="input-group">
                            <span class="input-group-addon"><input type="radio" name="${question.name}"></span>
                            <div class="form-control">${option.content}</div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </c:forEach>
    </div>
    <div align="center"><button id="complete-btn" class="btn btn-info">Завершить прохождение опроса</button></div>
</div>


<script>

</script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
<script src="/resources/js/bootstrap.min.js"></script>
</body>
</html>