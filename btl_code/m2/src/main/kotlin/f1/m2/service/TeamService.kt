package f1.m2.service

import f1.m2.model.Team
import f1.m2.model.Tournament

interface TeamService {
    fun getTeamOfSeason(season: Tournament): ArrayList<Team>
}