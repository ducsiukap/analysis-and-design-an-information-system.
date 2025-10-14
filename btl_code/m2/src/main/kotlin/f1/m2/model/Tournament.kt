package f1.m2.model

import java.time.LocalDate

class Tournament(
    var id: Int = 0,
    var name: String = "",
    var year: Int = LocalDate.now().year,
    var expectedRaceAmount: Int = -1
)