package f1.m2.dao

import f1.m2.model.Team

interface TeamDAO {
    fun findAllByTournamentId(tid: Int): ArrayList<Team>
}