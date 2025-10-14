package f1.m2.dao

import f1.m2.model.TeamRaceStat
import org.springframework.stereotype.Repository

@Repository
class TeamRaceStatDAOImpl : DAO(), TeamRaceStatDAO {
    override fun findAllBySeasonTeam(ssid: Int, tid: Int): ArrayList<TeamRaceStat> {
        val stats = ArrayList<TeamRaceStat>()

        //

        return stats
    }
}