package f1.m2.service

import f1.m2.dao.TeamRaceStatDAO
import f1.m2.model.Team
import f1.m2.model.TeamRaceStat
import f1.m2.model.Tournament
import org.springframework.stereotype.Service

@Service
class TeamRaceStatServiceImpl(private val trsd: TeamRaceStatDAO) : TeamRaceStatService {
    override fun getTeamSeasonResult(season: Tournament, team: Team): ArrayList<TeamRaceStat> {
        val stats = trsd.findAllBySeasonTeam(season.id, team.id)
        //
        stats.sortBy { result -> result.raceNum }
        return stats
    }
}