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