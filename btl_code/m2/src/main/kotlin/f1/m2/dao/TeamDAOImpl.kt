package f1.m2.dao

import f1.m2.model.Team
import org.springframework.stereotype.Repository

@Repository
class TeamDAOImpl : DAO(), TeamDAO {
    override fun findAllByTournamentId(tid: Int): ArrayList<Team> {
        val teams = ArrayList<Team>()

        //
        val sql = """
            SELECT t.id, t.name, t.country
            FROM tblTeam as t
            JOIN tblDriverRaceResult as d 
                ON d.tblTeamId = t.id
            JOIN tblRace as r
                ON r.id = d.tblRaceId
            JOIN tblTournament as s
                ON s.id = r.tblTournamentId
            WHERE s.id = ?
            GROUP BY t.id
        """.trimIndent()

        conn.prepareStatement(sql).use { pstm ->
            pstm.setInt(1, tid)
            pstm.executeQuery().use {
                while (it.next()) {
                    val team = Team(
                        id = it.getInt("id"),
                        name = it.getString("name"),
                        country = it.getString("country")
                    )
                    teams.add(team)
                }
            }
        }

        return teams
    }
}