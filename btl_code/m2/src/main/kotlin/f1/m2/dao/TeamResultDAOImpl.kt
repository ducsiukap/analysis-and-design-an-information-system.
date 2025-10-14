package f1.m2.dao

import f1.m2.model.TeamResult
import org.springframework.stereotype.Repository

@Repository
class TeamResultDAOImpl : DAO(), TeamResultDAO {
    override fun findAllByTournamentId(tid: Int): ArrayList<TeamResult> {
        val results = ArrayList<TeamResult>()
        //
        return results
    }

    override fun findAllByRaceId(rid: Int): ArrayList<TeamResult> {
        val results = ArrayList<TeamResult>()
        //
        return results
    }
}