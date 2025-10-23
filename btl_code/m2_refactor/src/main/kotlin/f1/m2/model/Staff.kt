package f1.m2.model

class Staff(
    id: Int = -1,
    fullName: String = "",
    username: String = "",
    password: String = "",
    mail: String = "",
    type: String = "",
    var position: String = ""
) : User(id = id, fullName = fullName, username = username, password = password, mail = mail, type = type)