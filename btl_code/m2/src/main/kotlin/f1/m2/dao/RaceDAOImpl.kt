package f1.m2.dao

import f1.m2.model.Race
import f1.m2.model.Tournament
import org.springframework.stereotype.Repository

@Repository
class RaceDAOImpl : DAO(), RaceDAO {
    override fun findAllByTournamentId(tid: Int): ArrayList<Race> {
        val races = ArrayList<Race>()
        //
        return races
    }

    override fun updateRace(race: Race): Boolean {

        //
        return true
    }

    override fun deleteById(rid: Int): Boolean {

        //
        return true
    }

    override fun findOneById(rid: Int): Race? {
        val race = Race()
        //
        return race
    }
}