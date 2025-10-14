package f1.m2.model

import java.time.LocalDateTime

open class Race(
    var id: Int = -1,
    var name: String = "",
    var numberOfLaps: Int = -1,
    var raceNum: Int = -1,
    var time: LocalDateTime = LocalDateTime.now(),
    var status: String = "active",
    var tournament: Tournament = Tournament(),
    var circuit: Circuit = Circuit(),
)