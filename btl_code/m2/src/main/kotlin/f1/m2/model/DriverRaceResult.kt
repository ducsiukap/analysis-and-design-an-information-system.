package f1.m2.model

import kotlin.time.Duration

class DriverRaceResult(
    var id: Int = -1,
    var laps: Int = -1,
    var time: Duration = Duration.INFINITE,
    var point: Int = -1,
    var startingPos: Int = -1,
    var race: Race,
    var drive: Driver,
    var team: Team
)