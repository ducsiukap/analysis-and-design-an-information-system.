package f1.m2.dao

import f1.m2.model.TeamRaceStat

interface TeamRaceStatDAO {
    fun findAllBySeasonTeam(ssid: Int, tid: Int): ArrayList<TeamRaceStat>
}