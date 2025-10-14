package f1.m2.service

import f1.m2.dao.TournamentDAO
import f1.m2.model.Tournament
import org.springframework.stereotype.Service

@Service
class TournamentServiceImpl(private val td: TournamentDAO) : TournamentService {
    override fun getAllSeason(): ArrayList<Tournament> {
        val seasons = td.findAll()
        //
        return seasons
    }

    override fun getAvailableRaceNumbers(season: Tournament): ArrayList<Int> {
        val raceNums = td.findFreeSeasonRaceNums(season.id)
        //
        return raceNums
    }
}