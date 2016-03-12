/**
 * Основные идентификаторы DOM-элементов:
 * #poll-link - кликабельный элемент списка опросов
 * #new-poll - кнопка добавления нового опроса
 * #poll-panel - панель опроса
 * #poll-name - название опроса
 * #poll-description - описание опроса
 * #delete-poll - кнопка удаления опроса
 * #edit-poll - кнопка редактирования опроса
 * #save-poll - кнопка созранения опроса
 * #add-quest - кнопка для добавления вопроса
 * #question-body - контейнер для всех панелей вопросов
 * .question-panel - панель вопроса
 * .floating-title - название опроса
 * .opt-panel - панель ответа
 * .add-opt - кнопка для добавления ответа
 * .delete-quest - кнопка для удаления вопроса
 * .delete-opt - кнопка для удаления ответа
 */
var currentPoll;
var questions;
var deletedQuestions = [];
var deletedOptions   = [];
var editState = false;

// оборачивает вопрос в html-код
var wrapQuestion = function(Question) {
    var options = Question.options;
    var wrappedQuestion = '<div data-id="'+Question.id+
        '" class="panel panel-default question-panel"><div class="panel-heading"><span class="floating-title">'+
        Question.name+'</span><div class="floating-button btn-group">' +
        '<button class="btn btn-info add-opt"><span class="glyphicon glyphicon-plus"></span></button>'+
        '<button class="delete-quest btn btn-danger"><span class="glyphicon glyphicon-trash"></span></button>' +
        '</div></div><div class="panel-body">';
    if (options != null) {
        for (var i = 0; i < options.length; i++) {
            wrappedQuestion += wrapOption(options[i],Question.name);
        }
    }
    wrappedQuestion +='</div></div>';
    return wrappedQuestion;
};

// оборачивает вариант ответа в html-код
var wrapOption = function(Option, questionName) {
    var wrappedOption = '<div data-id="'+Option.id+'" class="input-group opt-panel"><span class="input-group-addon">'+
        '<input class="is-right" name="'+questionName+'" type="radio" ';
    if (Option.right) wrappedOption += 'checked';
    wrappedOption += '></span><input value="'+Option.content+
        '" type="text" class="form-control"><span class="delete-opt input-group-addon btn-danger"><span class="glyphicon glyphicon-remove"></span></span></div> ';
    return wrappedOption;
}

// собирает данные об опросе со страницы
var parsePollForm = function() {
    var questionPanels = $('.question-panel');
    var questions = [];
    for (var i = 0; i < $('.question-panel').length; i++) {
        var optionPanels = $(questionPanels[i]).find('.opt-panel');
        var _options = [];
        for (var j = 0; j < optionPanels.length; j++) {
            _options.push({
                id: $(optionPanels[j]).data('id') === undefined ? null :  $(optionPanels[j]).data('id'),
                content: $(optionPanels[j]).children('input').eq(0).val(),
                right: $(optionPanels[j]).children('span').eq(0).children('input').prop('checked'),
                respondents: null
            })
        }
        questions.push({
            id: $(questionPanels[i]).data('id') === undefined ? null : $(questionPanels[i]).data('id'),
            name: $('.floating-title').eq(i).html(),
            options: _options,
            //poll: currentPoll
        });
    }
    return JSON.stringify({
        id: currentPoll == null ? null : currentPoll.id,
        name: $('#poll-name').html(),
        description: $('#poll-description').html(),
        questions: questions,
        respondents: null
    });
}

// добавление нового опроса
$('body').on('click','#new-poll',function(){
    if (!editState || editState && confirm("Вы действительно хотите прервать редактирование опроса "+$('#poll-name').html()+"? Несохранённые изменения будут потеряны")) {
        deletedOptions = []; deletedQuestions = [];
        currentPoll = null; questions = null;
        $('#poll-panel').hide();
        $('#question-body').hide();
        $('#save-poll').hide();
        $('#add-quest').hide();
        $('#question-body').empty();
        var pollName = prompt("Введите название опроса");
        if (pollName == "") {
            alert("Название опроса не может быть пустым!")
            return;
        }
        $('#poll-name').html(pollName.trim());
        var pollDescription = prompt("Введите описание опроса");
        $('#poll-description').html(pollDescription.trim());
        $('#poll-panel').show();
        $('#question-body').show();
        editState = false;
    }
})

// полная загрузка опроса с сервера и отображение на странице после выбора опроса
$('body').on('click','.poll-link',function(){
    if (!editState || editState && confirm("Вы действительно хотите прервать редактирование опроса "+$('#poll-name').html()+"? Несохранённые изменения будут потеряны")) {
        deletedOptions = []; deletedQuestions = [];
        var id = $(this).data('id');
        editState = false;
        $.get("/manage/getpoll/" + id, function (Poll) {
            currentPoll = Poll;
            questions = currentPoll.questions;
            $('#poll-panel').show();
            $('#poll-name').html(currentPoll.name);
            $('#poll-description').html(currentPoll.description);
            $('#question-body').empty();
            $('#save-poll').hide();
            $('#add-quest').hide();
        })
    }
});
// редактирование опроса
$('body').on('click','#edit-poll', function(){
    editState = true;
    $('#poll-name').prop('disabled',false);
    $('#poll-descriprion').prop('disabled',false);
    $('#question-body').empty();
    $('#save-poll').show();
    $('#add-quest').show();
    $('#poll-name').addClass('editing-data');
    $('#poll-description').addClass('editing-data');
    if (questions !== undefined && questions != null)
        for (var i = 0; i < questions.length; i++) {
            $('#question-body').append(wrapQuestion(questions[i]));
        }

    $('#question-body').show();
});

// сохранение опроса: отправка данных на сервер
$('body').on('click','#save-poll', function(){
    for (var i = 0; i < deletedQuestions; i++) {
        $.get('/manage/deletequestion/'+deletedQuestions[i])
    }
    for (var i = 0; i < deletedOptions; i++) {
        $.get('/manage/deleteoption/'+deletedOptions[i])
    }
    $.ajax({
        type: 'POST',
        url: '/manage/save',
        contentType: 'application/json',
        data: parsePollForm(),
        success: location.href = "/manage"
    });
    deletedOptions = []; deletedQuestions = [];
});

// удаление варианта ответа
$('body').on('click','.delete-opt', function(){
    deletedOptions.push($(this).parent().data('id'));
    $(this).parent().remove();
})

// удаление вопроса
$('body').on('click','.delete-quest', function(){
    deletedQuestions.push($(this).parent().parent().parent().data('id'))
    $(this).parent().parent().parent().remove();
})

// удаление опроса
$('body').on('click','#delete-poll', function(){
    if (confirm("Вы действительно хотите удалить опрос "+$('#poll-name').html()+"?")) {
        if (currentPoll!=null) {
            $.get("/manage/deletepoll/"+currentPoll.id, location.reload() )
        }
        $('#poll-panel').hide();
        $('#question-body').hide();
        $('#poll-name').removeClass('editing-data');
        $('#poll-description').removeClass('editing-data');
        editState = false;
    }
})

// изменение названия опроса
$('body').on('click','#poll-name',function(){
    if (editState) {
        $('#poll-name').html(prompt("Изменение названия опроса:",$('#poll-name').html()))
    }
})

// изменение описания опроса
$('body').on('click','#poll-description',function(){
    if (editState) {
        var pollName = prompt("Изменение описания опроса:",$('#poll-description').html())
        if (pollName = "") pollName = "(описание отсутствует)"
        $('#poll-description').html(pollName)
    }
})

// изменение названия вопроса
$('body').on('click','.floating-title',function(){
    if (editState) {
        var questionName = prompt("Изменение названия вопроса:",$(this).html())
        if (questionName == "") {
            alert("Название вопроса не может быть пустым!")
            return
        }
        $(this).html(questionName)
    }
})

// добавление нового опроса
$('body').on('click','#add-quest',function(){
    var newQuestion = prompt("Введите название вопроса:")
    if (newQuestion == "") {
        alert("Название вопроса не может быть пустым!")
        return;
    }
    $('#question-body').append(wrapQuestion({ name: newQuestion, id: 0, options: null}))
})

// добавление нового варианта ответов
$('body').on('click','.add-opt',function(){
    var newOption = prompt("Введите название варианта:")
    if (newOption == "") {
        alert("Название варианта не может быть пустым!")
        return;
    }
    $(this).parent().parent().parent().children('.panel-body').
    append(wrapOption({ content: newOption, id: 0, right: false },$(this).parent().parent().children('.floating-title').html() ))
})