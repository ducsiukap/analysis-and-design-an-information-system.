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
        if (race.name.isEmpty()) throw Exception("race name is null")
        if (race.numberOfLaps <= 0) throw Exception("number of laps is invalid")
        if (race.raceNum <= 0) throw Exception("race number is invalid")
        if (race.time.year != race.tournament.year) throw Exception("race time not match season")

        val result = rd.updateRace(race)
        //
        return result
    }

    override fun deleteRace(race: Race): Boolean {
        return try {
            rd.deleteById(race.id)
        } catch (e: SQLException) {
            false
        }
    }

    override fun getRace(rid: Int): Race? {
        val race = rd.findOne(rid)
        //
        return race
    }
}