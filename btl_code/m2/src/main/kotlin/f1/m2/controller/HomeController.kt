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

        if (user is Staff) {
            // get last name
            val lastName = user.fullName.split(" ").last()
            session.setAttribute("lastName", lastName)

            // send to view
            model.addAttribute("lastName", lastName)
            model.addAttribute("user", user)
            return "staff/homePage"
        } else {
            return "public/defaultHomePage"
        }
    }
}