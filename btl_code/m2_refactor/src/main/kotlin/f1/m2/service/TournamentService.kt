package f1.m2.service

import f1.m2.model.Tournament

interface TournamentService {
    fun getAllSeason(): ArrayList<Tournament>
    fun getAvailableRaceNumbers(season: Tournament): ArrayList<Int>
}