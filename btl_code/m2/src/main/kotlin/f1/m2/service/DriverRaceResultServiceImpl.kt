package f1.m2.service

import f1.m2.dao.DriverRaceResultDAO
import f1.m2.model.Driver
import f1.m2.model.DriverRaceResult
import f1.m2.model.Race
import f1.m2.model.Team
import org.springframework.stereotype.Service
import java.time.Duration

@Service
class DriverRaceResultServiceImpl(private val drrd: DriverRaceResultDAO) : DriverRaceResultService {
    override fun getRaceResult(race: Race, team: Team): ArrayList<DriverRaceResult> {
        val results = drrd.findAllByRaceAndTeam(race.id, team.id)
        //

        results.add(
            DriverRaceResult(
                position = 1,
                point = 25,
                time = Duration.parse("PT1H30M"),
                race = race,
                team = team,
                driver = Driver(name = "vduczz"),
                laps = 52
            )
        )
        results.sortByDescending { result -> result.point }
        return results
    }
}