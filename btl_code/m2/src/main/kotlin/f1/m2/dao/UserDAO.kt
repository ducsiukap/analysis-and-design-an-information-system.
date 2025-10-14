package f1.m2.dao

import f1.m2.model.User

interface UserDAO {
    fun findOne(username: String, password: String): User?
}