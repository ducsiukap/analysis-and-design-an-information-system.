package f1.m2.dao

import f1.m2.model.Circuit
import org.springframework.stereotype.Repository

@Repository
class CircuitDAOImpl : DAO(), CircuitDAO {

    override fun findAll(): ArrayList<Circuit> {
        val circuits = ArrayList<Circuit>()
        //
        return circuits
    }
}