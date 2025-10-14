package f1.m2.dao

import f1.m2.model.DriverRaceResult

interface DriverRaceResultDAO {
    fun findAllByRaceAndTeam(rid: Int, tid: Int): ArrayList<DriverRaceResult>
}