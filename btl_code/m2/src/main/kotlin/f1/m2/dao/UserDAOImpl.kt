package f1.m2.dao

import f1.m2.model.User
import org.springframework.stereotype.Repository

@Repository
class UserDAOImpl : DAO(), UserDAO {
    override fun findOne(username: String, password: String): User? {

        return null
    }
}