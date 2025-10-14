package f1.m2.dao

import f1.m2.model.Staff
import org.springframework.stereotype.Repository

@Repository
class StaffDAOImpl : DAO(), StaffDAO {
    override fun findOneByUser(uid: Int): Staff? {

        return null
    }
}