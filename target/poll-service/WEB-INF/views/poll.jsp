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
    <title>Poll Service: опрос "${poll.name}"</title>
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

<div class="page-header" style="display: none">
    Результат прохождения опроса ${poll.name}:
    <div class="progress progress-striped">
        <div class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="0" aria-valuemin="0" aria-valuemax="100" style="width: 40%">

        </div>
    </div>
</div>

<div class="container col-md-8 col-lg-offset-2" style="margin-top: 20px;">
    <div class="panel panel-default">
        <div class="panel-heading"><h3><c:out value="${poll.name}"/></h3></div>
        <div class="panel-body"><c:out value="${poll.description}"/></div>
    </div>
    <div class="col-md-offset-1 col-md-10"><%--Container for questions--%>
        <c:forEach var="question" items="${poll.questions}">
            <div data-id="${question.id}" class="question-panel panel panel-default">
                <div class="panel-heading"><h4><c:out value="${question.name}"/></h4></div>
                <div class="panel-body">
                    <c:forEach var="option" items="${question.options}">
                        <div class="input-group">
                            <span class="input-group-addon"><input data-id="${option.id}" class="answer" type="radio" name="${question.name}"></span>
                            <div class="form-control">${option.content}</div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </c:forEach>
    </div>
    <div align="center">
        <form action="/poll/${id}/results" method="get">
            <input id="complete-btn" class="btn btn-info" value="Завершить прохождение опроса"/>
        </form>
    </div>


<div class="modal fade" id="respondent-modal" tabindex="-1" role="dialog"  aria-hidden="true">
    <div class="modal-dialog modal-sm">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title" id="myModalLabel">Представьтесь, пожалуйста</h4>
            </div>
            <div class="modal-body">
                <form id="aaa">
                <div class="input-group">
                    <span class="input-group-addon">Имя:</span>
                    <input class="form-control" id="respondent-name">
                </div>
                <div class="input-group">
                    <span class="input-group-addon">E-mail:</span>
                    <input type="email" class="form-control" id="respondent-email">
                </div>
                </form>
            </div>
            <div class="modal-footer">
                <button id="accept-data" type="button" class="btn btn-primary">ОК</button>
            </div>
        </div>
    </div>
</div>

<script>
    var respondent = null; var answers = []; var rightAnswers = []
    var rightCount = 0;

    $(document).ready(function () {
        $('#respondent-modal').modal({
            keyboard: false,
            backdrop: "static"
        });
    });

    $('body').on('click','#accept-data',function(){
        var respondentName = $('#respondent-name').val();
        var email = $('#respondent-email').val();

        respondent = { id: 0, name: respondentName, email: email, /*ipaddress: null,*/ polls: null, answers: null };
        $('#respondent-modal').modal('hide');
    });

    // завершение прохождения опроса: отправка данных на сервер, получение правильных ответов и отображение результатов
    $('body').on('click','#complete-btn',function(){
        if(respondent == null)
            location.reload();
        else {
            $('.answer').each(function(){
                if($(this).prop('checked'))
                    answers.push($(this).data('id'))
            });
            var holder = { respondent: respondent, options: answers };
            $.ajax({
                type: 'POST',
                url: "/poll/${id}/save",
                contentType: 'application/json',
                data: JSON.stringify(holder),
                success: function() {
                    $.get("/poll/${id}/getAnswers",function(rightAns) {
                        // если успешно получили данные об ответах - проводим нужные изменения на странице
                        $('.page-header').show();
                        rightAnswers = rightAns;
                        $('.answer').each(function(){ // для каждого вопроса отображаем, правильный ли ответ
                            $(this).addClass('disabled');
                            if($(this).prop('checked') && $.inArray($(this).data('id'),rightAnswers)) {
                                $(this).parent().parent().parent().parent().addClass('panel-success');
                                rightCount++;
                            }
                            else $(this).parent().parent().parent().parent().addClass('panel-danger');
                        })
                        $('.progress-bar').html(rightCount+"/"+answers.length);
                        $('.progress-bar').prop('aria-valuenow',rightCount/answers.length);
                        $('html,body').animate({scrollTop: 0},'slow')
                    });
                }
            });
        }
    });
</script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
<script src="/resources/js/bootstrap.min.js"></script>
</body>
</html>