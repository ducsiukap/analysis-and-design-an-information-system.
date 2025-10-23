package f1.m2.service

import f1.m2.dao.StaffDAO
import f1.m2.model.Staff
import f1.m2.model.User
import org.springframework.stereotype.Service

@Service
class StaffServiceImpl(private val sd: StaffDAO) : StaffService {

    override fun getStaff(user: User): Staff? {
        val staff = sd.findOneByUser(user.id)

        if (staff != null) {
            staff.id = user.id
            staff.fullName = user.fullName
            staff.username = user.username
            staff.password = user.password
            staff.type = user.type
            staff.mail = user.mail
        }
//        return staff
        return staff
    }
}