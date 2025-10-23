package f1.m2.service

import f1.m2.model.Team
import f1.m2.model.TeamRaceStat
import f1.m2.model.Tournament

interface TeamRaceStatService {
    fun getTeamSeasonResult(season: Tournament, team: Team): ArrayList<TeamRaceStat>
}