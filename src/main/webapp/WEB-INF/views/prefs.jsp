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
    <title>Poll Service: управление опросами / просмотр статистики</title>
    <link href="/resources/css/bootstrap.css" rel="stylesheet">
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
                <li><a href="/">Опросы</a></li>
                <li><a href="/manage">Управление</a></li>
                <li><a href="#">Статистика</a></li>
                <li class="active"><a href="#">Настройки</a></li>
            </ul>
        </div><!--/.nav-collapse -->
    </div>
</div>

<div class="container col-md-8 col-lg-offset-2" style="margin-top: 20px;">
    <div class="panel panel-default">
        <div class="panel-heading"><h3>Настройки доступа</h3></div>
        <div class="panel-body">
            <div class="alert alert-warning">Расположение файла настроек<br><b>${settingsPath}</b></div>
            <div class="input-group input-sm">
                <label class="input-group-addon" for="username">Логин</label>
                <input type="text" class="form-control" id="username" name="ssoId" placeholder="Введите логин" value="${settings.login}">
            </div>
            <div class="input-group input-sm">
                <label class="input-group-addon" for="password">Пароль</label>
                <input type="password" class="form-control" id="password" name="password" placeholder="Введите пароль" value="${settings.password}">
                <a id="change-passwd" class="input-group-addon">Изменить..</a>
            </div>
            <div class="col-md-8 col-md-offset-2" id="chg-passwd" style="border-bottom-color: #2a6496; display: none">
                <h4>Изменение пароля:</h4>
                <div class="input-group input-sm">
                    <label class="input-group-addon" for="password">Новый пароль</label>
                    <input type="password" class="form-control" id="password" name="password">
                </div>
                <div class="input-group input-sm">
                    <label class="input-group-addon" for="password">Повтор пароля</label>
                    <input type="password" class="form-control" id="password" name="password">
                </div>
                <button id="chg-passwd-confirm" class="btn btn-primary col-md-4 col-md-offset-4">Изменить пароль</button>
            </div>
        </div>
    </div>
</div>

<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.11.0/jquery.min.js"></script>
<script src="/resources/js/view-scripts/prefs.js"></script>
<script src="/resources/js/bootstrap.min.js"></script>
</body>
</html>
