package f1.m2.model

class Staff(
    id: Int = -1,
    fullName: String = "",
    username: String = "",
    password: String = "",
    mail: String = "",
    var position: String = ""
) : User(id, fullName, username, password, mail)