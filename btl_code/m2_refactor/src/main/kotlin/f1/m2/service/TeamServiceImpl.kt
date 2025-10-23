package f1.m2.service

import f1.m2.dao.TeamDAO
import f1.m2.model.Team
import f1.m2.model.Tournament
import org.springframework.stereotype.Service

@Service
class TeamServiceImpl(private val td: TeamDAO) : TeamService {

    override fun getTeamOfSeason(season: Tournament): ArrayList<Team> {
        val teams = td.findAllByTournamentId(season.id)
        //
        teams.sortBy { t -> t.name }
        return teams
    }
}