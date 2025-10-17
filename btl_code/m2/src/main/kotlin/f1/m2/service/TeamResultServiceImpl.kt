package f1.m2.service

import f1.m2.dao.TeamResultDAO
import f1.m2.model.Race
import f1.m2.model.TeamResult
import f1.m2.model.Tournament
import org.springframework.stereotype.Service

@Service
class TeamResultServiceImpl(private val trd: TeamResultDAO) : TeamResultService {
    override fun getTeamRanking(race: Race): ArrayList<TeamResult> {
        val rankings = trd.findAllByRaceId(race.id)
        //

        rankings.add(TeamResult(name = "VN", totalPoints = 100))
        rankings.add(TeamResult(name = "TQ", totalPoints = 52))
        rankings.add(TeamResult(name = "USA", totalPoints = 53))
        rankings.add(TeamResult(name = "UK", totalPoints = 49))
        rankings.add(TeamResult(name = "dcmm aaaa", totalPoints = 50))
        rankings.sortByDescending { r -> r.totalPoints }
        return rankings
    }

    override fun getTeamRanking(season: Tournament): ArrayList<TeamResult> {
        val rankings = trd.findAllByTournamentId(season.id)
        //
        rankings.sortByDescending { r -> r.totalPoints }
        return rankings
    }
}