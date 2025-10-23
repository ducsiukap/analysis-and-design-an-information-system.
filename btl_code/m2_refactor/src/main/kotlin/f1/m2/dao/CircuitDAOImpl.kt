package f1.m2.dao

import f1.m2.model.Circuit
import org.springframework.stereotype.Repository

@Repository
class CircuitDAOImpl : DAO(), CircuitDAO {

    override fun findAll(): ArrayList<Circuit> {
        val circuits = ArrayList<Circuit>()
        //
        val sql = """
            SELECT id, name, country, city, lapLength
            FROM tblCircuit
        """.trimIndent()
        conn.prepareStatement(sql).use { pstm ->
            pstm.executeQuery().use {
                while (it.next()) {
                    val circuit = Circuit(
                        id = it.getInt("id"),
                        name = it.getString("name"),
                        country = it.getString("country"),
                        city = it.getString("city"),
                        lapLength = it.getFloat("lapLength")
                    )
                    circuits.add(circuit)
                }
            }
        }

        return circuits
    }
}