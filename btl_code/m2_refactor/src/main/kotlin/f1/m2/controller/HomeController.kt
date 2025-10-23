package f1.m2.controller

import f1.m2.model.Staff
import f1.m2.model.User
import jakarta.servlet.http.HttpSession
import org.springframework.stereotype.Controller
import org.springframework.ui.Model
import org.springframework.web.bind.annotation.GetMapping

@Controller
class HomeController {

    @GetMapping("/", "")
    fun getHomePage(session: HttpSession, model: Model): Any {
        val user = session.getAttribute("user")

        return if (user is Staff)
            "staff/homePage" else
            "public/defaultHomePage"
    }
}