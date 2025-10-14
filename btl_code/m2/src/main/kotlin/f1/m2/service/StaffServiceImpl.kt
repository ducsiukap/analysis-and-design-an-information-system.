package f1.m2.service

import f1.m2.dao.StaffDAO
import f1.m2.model.Staff
import f1.m2.model.User
import org.springframework.stereotype.Service

@Service
class StaffServiceImpl(private val sd: StaffDAO) : StaffService {

    override fun getStaff(user: User): Staff? {
        val staff = sd.findOneByUser(user.id)
        //
        return staff
    }
}