package f1.m2.dao

import f1.m2.model.Staff

interface StaffDAO {
    fun findOneByUser(uid: Int): Staff?
}