package f1.m2.dao

import f1.m2.model.Race

interface RaceDAO {
    fun findAllByTournamentId(tid: Int): ArrayList<Race>
    fun updateRace(race: Race): Boolean
    fun findOne(rid: Int): Race?
    fun deleteById(rid: Int): Boolean
}