package f1.m2.dao

import f1.m2.model.Tournament
import org.springframework.stereotype.Repository
import java.time.LocalDate

@Repository
class TournamentDAOImpl : DAO(), TournamentDAO {
    override fun findAll(): ArrayList<Tournament> {
        val sql =
            """SELECT id, name, year, expectedRaceAmount 
                FROM tblTournament 
                WHERE year <= ? 
                ORDER BY year DESC
            """.trimIndent()
        // data
        val seasons = ArrayList<Tournament>()

        // use{} -> auto close pstm, rs
        conn.prepareStatement(sql).use { pstm ->
            pstm.setInt(1, LocalDate.now().year)
            pstm.executeQuery().use {
                // data
                while (it.next()) {
                    val season = Tournament(
                        it.getInt("id"),
                        it.getString("name"),
                        it.getInt("year"),
                        it.getInt("expectedRaceAmount")
                    )
                    seasons.add(season)
                }

            }
        }
        return seasons
    }

    override fun findFreeSeasonRaceNums(tid: Int): ArrayList<Int> {
        val raceNums = ArrayList<Int>()
        // select expected race amount
        var sql = """
            SELECT expectedRaceAmount
            FROM tblTournament 
            WHERE id = ?
        """.trimIndent()
        conn.prepareStatement(sql).use { pstm ->
            pstm.setInt(1, tid)
            pstm.executeQuery().use {
                if (it.next())
                    raceNums.add(it.getInt(1))
            }
        }

        // select race number that is used
        sql = """
            SELECT raceNumber
            FROM tblRace
            WHERE tblTournamentId = ?
        """.trimIndent()
        conn.prepareStatement(sql).use { pstm ->
            pstm.setInt(1, tid)
            pstm.executeQuery().use {
                while (it.next()) {
                    raceNums.add(it.getInt(1))
                }
            }
        }

        // first elems is expected race amount
        // from the seconds to the end is the race number that was used
        return raceNums
    }
}