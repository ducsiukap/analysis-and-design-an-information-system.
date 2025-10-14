package f1.m2.service

import f1.m2.dao.DriverRaceResultDAO
import f1.m2.model.DriverRaceResult
import f1.m2.model.Race
import f1.m2.model.Team
import org.springframework.stereotype.Service

@Service
class DriverRaceResultServiceImpl(private val drrd: DriverRaceResultDAO) : DriverRaceResultService {
    override fun getRaceResult(race: Race, team: Team): ArrayList<DriverRaceResult> {
        val results = drrd.findAllByRaceAndTeam(race.id, team.id)
        //

        results.sortByDescending { result -> result.point }
        return results
    }
}