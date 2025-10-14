package f1.m2.dao

import f1.m2.model.Team
import org.springframework.stereotype.Repository

@Repository
class TeamDAOImpl : DAO(), TeamDAO {
    override fun findAllByTournamentId(tid: Int): ArrayList<Team> {
        val teams = ArrayList<Team>()
        //
        return teams
    }
}