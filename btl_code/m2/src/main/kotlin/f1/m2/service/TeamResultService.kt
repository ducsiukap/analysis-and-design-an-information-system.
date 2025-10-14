package f1.m2.service

import f1.m2.model.Race
import f1.m2.model.TeamResult
import f1.m2.model.Tournament

interface TeamResultService {
    fun getTeamRanking(season: Tournament): ArrayList<TeamResult>
    fun getTeamRanking(race: Race): ArrayList<TeamResult>
}