package f1.m2.service

import f1.m2.dao.RaceDAO
import f1.m2.model.Race
import f1.m2.model.Tournament
import org.springframework.stereotype.Service
import java.sql.SQLException

@Service
class RaceServiceImpl(private val rd: RaceDAO) : RaceService {
    override fun getSeasonRace(season: Tournament): ArrayList<Race> {
        try {
            val races = rd.findAllByTournamentId(season.id)
            //
            races.sortBy { race -> race.time }
            return races
        } catch (e: SQLException) {
            return ArrayList()
        }
    }

    override fun updateRace(race: Race): Boolean {
        val result = rd.updateRace(race)
        //
        return result
    }

    override fun deleteRace(race: Race): Boolean {
        val result = rd.deleteById(race.id)
        //
        return result
    }

    override fun getRace(rid: Int): Race? {
        val race = rd.findOneById(rid)
        //
        return race
    }
}