package f1.m2.service

import f1.m2.model.Race
import f1.m2.model.Tournament

interface RaceService {
    fun getSeasonRace(season: Tournament): ArrayList<Race>
    fun updateRace(race: Race): Boolean
    fun getRace(rid: Int): Race?
    fun deleteRace(race: Race): Boolean
}