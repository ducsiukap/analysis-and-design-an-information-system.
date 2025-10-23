package f1.m2.controller

import f1.m2.model.User
import org.springframework.boot.web.servlet.error.ErrorController
import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.RequestMapping
import jakarta.servlet.http.HttpSession
import org.springframework.ui.Model

@Controller
class ErrorPage : ErrorController {

    @RequestMapping("/error")
    fun handleError(
        session: HttpSession,
        model: Model,
    ): String {
        val user = session.getAttribute("user") as? User

        val error = model.getAttribute("error") ?: "404 not found..."

        model.addAttribute("message", error)

        return if (user == null) "public/error"
        else {
            if (user.type == "staff") "staff/error"
            else "public/error"
        }

    }

}
