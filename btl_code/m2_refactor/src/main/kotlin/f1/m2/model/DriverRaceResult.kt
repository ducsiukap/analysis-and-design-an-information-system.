package f1.m2.model


data class DriverRaceResult(
    var id: Int = -1,
    var position: Int = 0,
    var laps: Int = 0,
    var time: Long = 0,
    var point: Int = 0,
    var startingPos: Int = 0,
    var race: Race = Race(),
    var driver: Driver = Driver(),
    var team: Team = Team()
)