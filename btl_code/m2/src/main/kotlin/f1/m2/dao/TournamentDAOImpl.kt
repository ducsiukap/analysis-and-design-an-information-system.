package f1.m2.dao

import f1.m2.model.Tournament
import org.springframework.stereotype.Repository

@Repository
class TournamentDAOImpl : DAO(), TournamentDAO {
    override fun findAll(): ArrayList<Tournament> {
        val seasons = ArrayList<Tournament>()
//        seasons.add(Tournament())
        return seasons
    }

    override fun findFreeSeasonRaceNums(tid: Int): ArrayList<Int> {
        val raceNums = ArrayList<Int>()
        //
        return raceNums
    }
}