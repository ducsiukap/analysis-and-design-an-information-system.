package f1.m2.dao

import f1.m2.model.Tournament

interface TournamentDAO {
    fun findAll(): ArrayList<Tournament>
    fun findFreeSeasonRaceNums(tid: Int): ArrayList<Int>
}