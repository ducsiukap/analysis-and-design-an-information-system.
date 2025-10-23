package f1.m2.authentication

import f1.m2.model.User
import jakarta.servlet.http.HttpServletRequest
import jakarta.servlet.http.HttpServletResponse
import org.springframework.stereotype.Component
import org.springframework.web.servlet.HandlerInterceptor

@Component
class StaffAuthInterceptor : HandlerInterceptor {

    // check user
    override fun preHandle(
        request: HttpServletRequest,
        response: HttpServletResponse,
        handler: Any
    ): Boolean {
        return when (val user = request.session.getAttribute("user")) {
            // chua login
            null -> {
                response.sendRedirect(request.contextPath + "/login")
                false
            }

            // khong phai User
            !is User -> {
                request.session.removeAttribute("user")
                response.sendRedirect(request.contextPath + "/login")
                false
            }

            // la user
            else -> {
                when (user.type) {
                    // la staff
                    "staff" -> true
                    // khong phai staff
                    else -> {
                        response.sendRedirect(request.contextPath + "/")
                        false
                    }
                }
            }
        }
    }
}