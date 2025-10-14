package f1.m2.service

import f1.m2.model.Staff
import f1.m2.model.User

interface StaffService {
    fun getStaff(user: User): Staff?
}