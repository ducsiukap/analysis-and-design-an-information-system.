package f1.m2.service

import f1.m2.dao.TournamentDAO
import f1.m2.model.Tournament
import org.springframework.stereotype.Service
import java.sql.SQLException

@Service
class TournamentServiceImpl(private val td: TournamentDAO) : TournamentService {
    override fun getAllSeason(): ArrayList<Tournament> {
        try {
            val seasons = td.findAll()
            //
            seasons.sortByDescending { t -> t.year }
            return seasons
        } catch (err: SQLException) {
            return ArrayList<Tournament>()
        }
    }

    override fun getAvailableRaceNumbers(season: Tournament): ArrayList<Int> {
        val raceNums = td.findFreeSeasonRaceNums(season.id)
        //
        return raceNums
    }
}