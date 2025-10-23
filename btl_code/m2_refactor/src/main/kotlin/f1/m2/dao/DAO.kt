package f1.m2.dao

import java.sql.Connection
import java.sql.DriverManager

open class DAO {
    companion object {
        private var _conn: Connection? = null
        val conn: Connection
            get() {
                if (_conn == null) {
                    try {
                        val dbUrl = "jdbc:mysql://localhost:3306/f1db?autoReconnect=true&useSSL=false&allowPublicKeyRetrieval=true"
                        val dbClass = "com.mysql.cj.jdbc.Driver"
                        val dbUser = "root"
                        val dbPassword = "vduczz#13304"
                        Class.forName(dbClass)
                        _conn = DriverManager.getConnection(dbUrl, dbUser, dbPassword)

                        println("Connected to db successfully")
                    } catch (e: Exception) {
                        throw RuntimeException("Connect to db error", e)
                    }
                }
                return _conn!!
            }
    }
}