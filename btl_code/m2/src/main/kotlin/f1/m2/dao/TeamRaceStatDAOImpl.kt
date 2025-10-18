package f1.m2.dao

import f1.m2.model.TeamRaceStat
import org.springframework.stereotype.Repository
import java.sql.Timestamp
import java.time.LocalDateTime

@Repository
class TeamRaceStatDAOImpl : DAO(), TeamRaceStatDAO {
    override fun findAllBySeasonTeam(ssid: Int, tid: Int): ArrayList<TeamRaceStat> {
        val stats = ArrayList<TeamRaceStat>()

        //
        val sql = """
            SELECT raceId, raceName, raceTime, totalPoint
            FROM vTeamRaceStat
            WHERE seasonId = ? AND teamId = ? AND raceTime <= ?
        """.trimIndent()

        conn.prepareStatement(sql).use { pstm ->
            pstm.setInt(1, ssid)
            pstm.setInt(2, tid)
            pstm.setTimestamp(3, Timestamp.valueOf(LocalDateTime.now()))
            pstm.executeQuery().use {
                while (it.next()) {
                    val stat = TeamRaceStat(
                        id = it.getInt("raceId"),
                        name = it.getString("raceName"),
                        time = it.getTimestamp("raceTime").toLocalDateTime(),
                        totalPoint = it.getInt("totalPoint")
                    )
                    stats.add(stat)
                }
            }
        }

        return stats
    }
}