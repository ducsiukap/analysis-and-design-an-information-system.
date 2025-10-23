package f1.m2.controller

import f1.m2.model.User
import f1.m2.service.StaffService
import f1.m2.service.UserService
import jakarta.servlet.http.HttpSession
import org.springframework.stereotype.Controller
import org.springframework.ui.Model
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestParam

@Controller
class UserController(private val userService: UserService, private val staffService: StaffService /*DI*/) {

    @GetMapping("/login")
    fun getLoginPage(session: HttpSession): String {
        val user = session.getAttribute("user")

        // is logged
        when (user) {
            null -> return "public/login"
            else -> return "redirect:/"
        }
    }

    @PostMapping("/login")
    fun doLogin(
        @RequestParam("username") username: String,
        @RequestParam("password") password: String,
        session: HttpSession,
        model: Model
    ): String {

        // service
        session.setAttribute("username", username)
        val user: User? = userService.checkLogin(User(username = username, password = password))

        // log
        val logStatus = when (user) {
            null -> "Failed"
            else -> "Success"
        }
        println(
            "Login request for user with: {username = $username, password = $password}, status: $logStatus"
        )

        // result checking
        if (user == null) {
            model.addAttribute("login_error", "login failed")
            return "/public/login"
        } else {

            val firstName = user.fullName.split(" ")[0]
            session.setAttribute("firstName", firstName)

            if (user.type == "staff") {
                val staff = staffService.getStaff(user)
                session.setAttribute("user", staff)
            } else {
                session.setAttribute("user", user)
            }
            return "redirect:/"
        }
    }

    // logout
    @GetMapping("/logout")
    fun logout(session: HttpSession): String {
        session.removeAttribute("user")
        session.removeAttribute("firstName")
        return "redirect:/login"
    }
}