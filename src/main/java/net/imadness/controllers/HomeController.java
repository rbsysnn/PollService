package net.imadness.controllers;

import net.imadness.entities.Poll;
import net.imadness.services.dal.PollService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.List;

/**
 * Контроллер для главной страницы приложения
 */
@Controller
public class HomeController {

    @Autowired
    private PollService pollService;

    /**
     * Помещает опросы и их описание на главную страницу в виде списка
     */
	@RequestMapping("/")
	public String prepareHomePageView(ModelMap model) {
        List<Poll> polls = pollService.getAllPollsWithoutFetch();
        model.addAttribute("pollList",polls);
        return "home";
	}

    /**
     * Задаёт маппинг для страницы логина для администратора сервиса
     */
    @RequestMapping("/auth")
	public String prepareLoginPageView(ModelMap model) {
        return "auth";
	}

    @RequestMapping("/logout")
    public String logout(HttpServletRequest request, HttpServletResponse response) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null){
            new SecurityContextLogoutHandler().logout(request, response, auth);
        }
        return "redirect:/login?logout";
    }

    @ResponseBody
    @RequestMapping("/ud")
    public ResponseEntity<String> getUserData(HttpServletRequest request, HttpServletResponse response) {

        response.addCookie(new Cookie("p12","true"));
        response.addCookie(new Cookie("user", "71"));
        return new ResponseEntity<>(HttpStatus.OK);
    }
}