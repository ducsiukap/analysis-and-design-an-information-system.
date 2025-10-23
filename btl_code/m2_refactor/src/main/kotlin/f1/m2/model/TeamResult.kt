package f1.m2.model

class TeamResult(
    id: Int = -1,
    name: String = "",
    country: String = "",
    var totalPoint: Int = -1,
) : Team(id, name, country)