package f1.m2.service

import f1.m2.model.DriverRaceResult
import f1.m2.model.Race
import f1.m2.model.Team

interface DriverRaceResultService {
    fun getRaceResult(race: Race, team: Team): ArrayList<DriverRaceResult>
}