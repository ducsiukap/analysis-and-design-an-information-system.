package f1.m2.service

import f1.m2.dao.UserDAO
import f1.m2.model.User
import org.springframework.stereotype.Service

@Service
class UserServiceImpl(private val ud: UserDAO) : UserService {
    override fun checkLogin(user: User): User? {
        return try {
            ud.findOne(user.username, user.password)
        } catch (_: Exception) {
            null
        }
    }
}