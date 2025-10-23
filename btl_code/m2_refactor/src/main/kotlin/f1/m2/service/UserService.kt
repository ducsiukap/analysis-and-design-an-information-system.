package f1.m2.service

import f1.m2.model.User

interface UserService {
    fun checkLogin(user: User): User?

}