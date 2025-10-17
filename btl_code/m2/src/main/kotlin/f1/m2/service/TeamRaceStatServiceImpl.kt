package f1.m2.service

import f1.m2.dao.TeamRaceStatDAO
import f1.m2.model.Team
import f1.m2.model.TeamRaceStat
import f1.m2.model.Tournament
import org.springframework.stereotype.Service
import java.time.LocalDateTime

@Service
class TeamRaceStatServiceImpl(private val trsd: TeamRaceStatDAO) : TeamRaceStatService {
    override fun getTeamSeasonResult(season: Tournament, team: Team): ArrayList<TeamRaceStat> {
        val stats = trsd.findAllBySeasonTeam(season.id, team.id)
        //
        stats.add(TeamRaceStat(name = "AAA grandprix", totalPoint = 100, time = LocalDateTime.now()))
        stats.add(TeamRaceStat(name = "HN grandprix", totalPoint = 13, time = LocalDateTime.of(2025, 8, 18, 0, 0)))
        stats.sortBy { result -> result.time }
        return stats
    }
}