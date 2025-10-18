package f1.m2.dao

import f1.m2.model.Circuit
import f1.m2.model.Race
import f1.m2.model.Tournament
import org.springframework.stereotype.Repository
import java.sql.Timestamp
import java.time.LocalDateTime

@Repository
class RaceDAOImpl : DAO(), RaceDAO {
    override fun findAllByTournamentId(tid: Int): ArrayList<Race> {
        val sql = """
            SELECT id, name, numberOfLaps, raceNumber, time, status, tblTournamentId, tblCircuitId
            FROM tblRace
            WHERE tblTournamentId = ? AND time <= ?
            ORDER BY time
        """.trimIndent()

        val races = ArrayList<Race>()

        conn.prepareStatement(sql).use { pstm ->
            pstm.setInt(1, tid)
            pstm.setTimestamp(2, Timestamp.valueOf(LocalDateTime.now()))
            pstm.executeQuery().use {
                while (it.next()) {
                    val race = Race(
                        id = it.getInt("id"),
                        name = it.getString("name"),
                        numberOfLaps = it.getInt("numberOfLaps"),
                        raceNum = it.getInt("raceNumber"),
                        time = it.getTimestamp("time").toLocalDateTime(),
                        status = it.getString("status"),
                        tournament = Tournament(id = it.getInt("tblTournamentId")),
                        circuit = Circuit(id = it.getInt("tblCircuitId"))
                    )
                    races.add(race)
                }
            }
        }

        return races
    }

    override fun updateRace(race: Race): Boolean {

        //
        return true
    }

    override fun deleteById(rid: Int): Boolean {

        //
        return true
    }

    override fun findOneById(rid: Int): Race? {
        val race = Race()
        //
        return race
    }
}