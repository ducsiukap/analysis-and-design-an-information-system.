package f1.m2.service

import f1.m2.dao.TournamentDAO
import f1.m2.model.Tournament
import org.springframework.stereotype.Service

@Service
class TournamentServiceImpl(private val td: TournamentDAO) : TournamentService {
    override fun getAllSeason(): ArrayList<Tournament> {
        val seasons = td.findAll()
        //
        val ss = ArrayList<Tournament>()
        ss.add(Tournament(year = 2021))
        ss.add(Tournament(year = 2023))
        ss.add(Tournament(year = 2025))
        ss.sortByDescending { t -> t.year }
        return ss
    }

    override fun getAvailableRaceNumbers(season: Tournament): ArrayList<Int> {
        val raceNums = td.findFreeSeasonRaceNums(season.id)
        //
        return raceNums
    }
}