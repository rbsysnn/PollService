# PollService
Приложение для онлайн опросов и тестирований.
Вступительное задание от компании ООО "ИТЦ ИУС", в дальнейшем расширенное до дипломного проекта (4 курс бакалавриата).
Позволяет администратору добавлять и редактировать опросы, в которых могут участвовать посетители. По каждому добавленному опросу предоставляется статистика.

##<span style="color:red">Some warnings</span>

На данный момент некоторые из REST-методов в контроллерах из пакета net.imadness.controllers могут не работать по тем или иным причинам. Могут быть проблемы с кроссбраузерностью (формы опросов могут не отправляться на сервер в Firefox).
Помимо этого есть ещё запланированные функции, которые не были реализованы к моменту сдачи диплома:
- проверка на повторное голосование;
- captcha на голосованиях;
- полноценная аутентификация администратора сервсиа на основе сущности в БД (сейчас сделано на основе файла);


<i>Back-end:</i>
- Java
- Apache Tomcat 7.0.61
- Spring MVC (Spring 4.0.2)
- MyBatis
- PostgreSQL

<i>Front-end:</i>
- JSP
- Bootstrap
- jQuery

Для импорта базы данных необходимо воспользоваться файлом дампа <a href="https://github.com/i-madness/PollService/blob/master/create_poll_service_db.sql">create_poll_service_db.sql</a>
Модель базы данных:
<img src="http://i.imgur.com/vi4qrzG.png">

<!-- <h4>Интерфейс приложения</h4> (кликабельно)
<table>
  <tr>
    <td>Главная страница</td>
    <td><a target="_blank" href="http://imgur.com/yZ9qa1I"><img src="http://i.imgur.com/yZ9qa1Im.png" title="source: imgur.com" /></a></td>
  </tr>
  <tr>
    <td>Прохождение опроса</td>
    <td><a target="_blank" href="http://imgur.com/0La77YT"><img src="http://i.imgur.com/0La77YTm.png" title="source: imgur.com" /></a></td>
  </tr>
    <tr>
    <td>Управление опросами</td>
    <td><a target="_blank" href="http://imgur.com/4Gkr4pa"><img src="http://i.imgur.com/4Gkr4pam.png" title="source: imgur.com" /></a></td>
  </tr>
  <tr>
    <td>Статистика по опросам</td>
    <td><a target="_blank" href="http://imgur.com/LbiFgmQ"><img src="http://i.imgur.com/LbiFgmQm.png" title="source: imgur.com" /></a></td>
  </tr>
</table>
-->
