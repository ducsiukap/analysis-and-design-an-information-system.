package f1.m2.dao

import f1.m2.model.User
import org.springframework.stereotype.Repository

@Repository
class UserDAOImpl : DAO(), UserDAO {
    override fun findOne(username: String, password: String): User? {
        val sql = """
            SELECT id, fullName, username, password, mail, type
            FROM tblUser where username=? and password=?
        """.trimIndent()

        conn.prepareStatement(sql).use { pstm ->
            pstm.setString(1, username)
            pstm.setString(2, password)

            pstm.executeQuery().use {
                if (it.next()) {
                    return User(
                        id = it.getInt("id"),
                        fullName = it.getString("fullName"),
                        username = it.getString("username"),
                        password = it.getString("password"),
                        mail = it.getString("mail"),
                        type = it.getString("type")
                    )
                }
            }
        }

        return null
    }
}