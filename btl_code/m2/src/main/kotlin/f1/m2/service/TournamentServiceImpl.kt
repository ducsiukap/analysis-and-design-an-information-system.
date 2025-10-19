package f1.m2.service

import f1.m2.dao.TournamentDAO
import f1.m2.model.Tournament
import org.eclipse.tags.shaded.org.apache.xpath.operations.Bool
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
        val data = td.findFreeSeasonRaceNums(season.id)
        //
        val mark = ArrayList<Boolean>()
        mark.add(false)
        for (i in 1..data[0]) mark.add(true)
        for (i in 1..<data.size) mark[data[i]] = false
        val raceNums = ArrayList<Int>()
        for (i in 1..data[0]) {
            if (mark[i]) raceNums.add(i)
        }

        return raceNums
    }
}