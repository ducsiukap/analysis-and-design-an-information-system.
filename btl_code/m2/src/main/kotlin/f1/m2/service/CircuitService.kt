package f1.m2.service

import f1.m2.model.Circuit

interface CircuitService {
    fun getAllCircuits(): ArrayList<Circuit>
}