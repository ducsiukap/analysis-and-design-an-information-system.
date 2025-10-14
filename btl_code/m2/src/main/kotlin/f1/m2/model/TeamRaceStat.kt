package f1.m2.model

import java.time.LocalDateTime

class TeamRaceStat(
    id: Int = -1,
    name: String = "",
    numberOfLaps: Int = -1,
    raceNumber: Int = -1,
    time: LocalDateTime = LocalDateTime.now(),
    status: String = "",
    tournament: Tournament = Tournament(),
    circuit: Circuit = Circuit(),
    var totalPoint: Int = -1
) : Race(id, name, numberOfLaps, raceNumber, time, status, tournament, circuit)