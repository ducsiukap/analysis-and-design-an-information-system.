package f1.m2.model

import java.time.Duration

class DriverRaceResult(
    var id: Int = -1,
    var position: Int = -1,
    var laps: Int = -1,
    var time: Duration = Duration.ZERO,
    var point: Int = -1,
    var startingPos: Int = -1,
    var race: Race,
    var driver: Driver,
    var team: Team
)