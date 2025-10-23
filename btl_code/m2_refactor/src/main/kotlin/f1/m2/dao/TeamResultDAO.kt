package f1.m2.dao

import f1.m2.model.TeamResult

interface TeamResultDAO {
    fun findAllByTournamentId(tid: Int): ArrayList<TeamResult>
    fun findAllByRaceId(rid: Int): ArrayList<TeamResult>
}