package f1.m2.service

import f1.m2.dao.DriverRaceResultDAO
import f1.m2.model.DriverRaceResult
import f1.m2.model.Race
import f1.m2.model.Team
import org.springframework.stereotype.Service

@Service
class DriverRaceResultServiceImpl(private val drrd: DriverRaceResultDAO) : DriverRaceResultService {
    override fun getRaceResult(race: Race, team: Team): ArrayList<DriverRaceResult> {
        return try {
            val results = drrd.findAllByRaceAndTeam(race.id, team.id)
            //
            results.sortWith(compareBy<DriverRaceResult> { it.position == 0 }.thenBy { it.position })
            results
        } catch (e: Exception) {
            ArrayList()
        }
    }

    override fun getRaceResult(race: Race): ArrayList<DriverRaceResult> {
        return try {
            val results = drrd.findAllByRace(race.id)
//            for (result in results) {
//                result.startingPos =
//            }
            //
            results.sortWith(compareBy<DriverRaceResult> { it.position == 0 }.thenBy { it.position })
            results
        } catch (e: Exception) {
            ArrayList()
        }
    }

    override fun updateRaceResult(results: ArrayList<DriverRaceResult>): Boolean {
        for (r in results) {
            if (r.startingPos < 0) throw Exception("Invalid starting position of driver ${r.driver.name}")
            if (r.laps < 0 || r.laps > r.race.numberOfLaps) throw Exception("Invalid laps of driver ${r.driver.name}")
            if (r.time < 0) throw Exception("Invalid time of driver ${r.driver.name}")
        }

        val ok = drrd.updateN(results)
        //
        return ok
    }
}