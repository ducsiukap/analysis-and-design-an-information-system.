package f1.m2.dao

import f1.m2.model.TeamResult
import org.springframework.stereotype.Repository

@Repository
class TeamResultDAOImpl : DAO(), TeamResultDAO {
    override fun findAllByTournamentId(tid: Int): ArrayList<TeamResult> {
        val results = ArrayList<TeamResult>()

        //
        val sql = """
            SELECT teamId, teamName, teamCountry, totalPoint
            FROM vTeamResult
            WHERE seasonId = ?
            ORDER BY totalPoint, teamName
        """.trimIndent()
        conn.prepareStatement(sql).use { pstm ->
            pstm.setInt(1, tid)
            pstm.executeQuery().use {
                while (it.next()) {
                    val result = TeamResult(
                        id = it.getInt("teamId"),
                        name = it.getString("teamName"),
                        country = it.getString("teamCountry"),
                        totalPoint = it.getInt("totalPoint"),
                    )
                    results.add(result)
                }
            }
        }

        //
        return results
    }

    override fun findAllByRaceId(rid: Int): ArrayList<TeamResult> {
        val results = ArrayList<TeamResult>()

        //
        val sql = """
            SELECT teamId, teamName, teamCountry, totalPoint
            FROM vTeamRaceStat
            WHERE raceId = ?
            ORDER BY totalPoint, teamName
        """.trimIndent()
        conn.prepareStatement(sql).use { pstm ->
            pstm.setInt(1, rid)
            pstm.executeQuery().use {
                while (it.next()) {
                    val result = TeamResult(
                        id = it.getInt("teamId"),
                        name = it.getString("teamName"),
                        country = it.getString("teamCountry"),
                        totalPoint = it.getInt("totalPoint"),
                    )
                    results.add(result)
                }
            }
        }

        //
        return results
    }
}