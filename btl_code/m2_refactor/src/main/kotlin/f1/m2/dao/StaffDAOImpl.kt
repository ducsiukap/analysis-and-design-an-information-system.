package f1.m2.dao

import f1.m2.model.Staff
import org.springframework.stereotype.Repository

@Repository
class StaffDAOImpl : DAO(), StaffDAO {
    override fun findOneByUser(uid: Int): Staff? {
        val sql = """
            SELECT position
            FROM tblStaff
            WHERE tblUserId=?
        """.trimIndent()

        conn.prepareStatement(sql).use { pstm ->
            pstm.setInt(1, uid)
            pstm.executeQuery().use {
                return if (it.next()) Staff(position = it.getString("position"))
                else null
            }
        }
    }
}