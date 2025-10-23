package f1.m2.service

import f1.m2.dao.CircuitDAO
import f1.m2.model.Circuit
import org.springframework.stereotype.Service

@Service
class CircuitServiceImpl(private val cd: CircuitDAO) : CircuitService {

    override fun getAllCircuits(): ArrayList<Circuit> {
        val circuits = cd.findAll()
        //
        circuits.sortBy { it.name }
        return circuits
    }
}