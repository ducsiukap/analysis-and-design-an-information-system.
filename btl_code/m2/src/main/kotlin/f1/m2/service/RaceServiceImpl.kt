package f1.m2.service

import f1.m2.dao.RaceDAO
import f1.m2.model.Race
import f1.m2.model.Tournament
import org.springframework.stereotype.Service

@Service
class RaceServiceImpl(private val rd: RaceDAO) : RaceService {
    override fun getSeasonRace(season: Tournament): ArrayList<Race> {
        val races = rd.findAllByTournamentId(season.id)
        //
        return races
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