package f1.m2.dao

import f1.m2.model.Circuit

interface CircuitDAO {
    fun findAll(): ArrayList<Circuit>
}