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
            SELECT 
                r.id as raceId, r.name as raceName, r.numberOfLaps, r.raceNumber, r.time, r.status, 
                s.id as seasonId, s.name as seasonName, s.year, s.expectedRaceAmount,
                c.id as circuitId, c.name as circuitName, c.country, c.city, c.lapLength
            FROM tblRace as r
            JOIN tblTournament as s 
                ON s.id = r.tblTournamentId
            JOIN tblCircuit AS c
                ON c.id = r.tblCircuitId
            WHERE tblTournamentId = ?
            ORDER BY time
        """.trimIndent()

        val races = ArrayList<Race>()

        conn.prepareStatement(sql).use { pstm ->
            pstm.setInt(1, tid)
            pstm.executeQuery().use {
                while (it.next()) {
                    val race = Race(
                        id = it.getInt("raceId"),
                        name = it.getString("raceName"),
                        numberOfLaps = it.getInt("numberOfLaps"),
                        raceNum = it.getInt("raceNumber"),
                        time = it.getTimestamp("time").toLocalDateTime(),
                        status = it.getString("status"),
                        tournament = Tournament(
                            id = it.getInt("seasonId"),
                            name = it.getString("seasonName"),
                            year = it.getInt("year"),
                            expectedRaceAmount = it.getInt("expectedRaceAmount"),
                        ),
                        circuit = Circuit(
                            id = it.getInt("circuitId"),
                            name = it.getString("circuitName"),
                            country = it.getString("country"),
                            city = it.getString("city"),
                            lapLength = it.getFloat("lapLength"),
                        )
                    )
                    races.add(race)
                }
            }
        }

        return races
    }

    override fun updateRace(race: Race): Boolean {
        val sql = """
            {CALL updateRace(?, ?, ?, ?, ?, ?, ?, ?, ?)}
        """.trimIndent()
        //
        conn.prepareCall(sql).use { pstm ->
            pstm.setInt(1, race.id)
            pstm.setString(2, race.name)
            pstm.setInt(3, race.numberOfLaps)
            pstm.setInt(4, race.raceNum)
            pstm.setObject(5, race.time)
            pstm.setString(6, race.status)
            pstm.setInt(7, race.tournament.id)
            pstm.setInt(8, race.circuit.id)

            pstm.registerOutParameter(9, java.sql.Types.BOOLEAN)

            pstm.execute()

            val ok = pstm.getBoolean(9)
            return ok
        }
    }

    override fun deleteById(rid: Int): Boolean {
        val sql = """
            DELETE FROM tblRace
            WHERE id = ?
        """.trimIndent()
        //

        conn.prepareStatement(sql).use { pstm ->
            pstm.setInt(1, rid)
            val row = pstm.executeUpdate()
            return (row == 1)
        }
    }

    override fun findOne(rid: Int): Race? {
        //
        val sql = """
            SELECT 
                r.id AS raceId, r.name AS raceName, r.numberOfLaps, r.raceNumber, r.time, r.status,
                s.id AS seasonId, s.name as seasonName, s.year AS seasonYear,
                c.id AS circuitId, c.name AS circuitName, c.country as circuitCountry
            FROM tblRace as r 
            JOIN tblTournament AS s
                ON s.id =r.tblTournamentId
            JOIN tblCircuit AS c 
                ON c.id = r.tblCircuitId
            WHERE r.id = ?
        """.trimIndent()

        conn.prepareStatement(sql).use { pstm ->
            pstm.setInt(1, rid)
            pstm.executeQuery().use {
                if (it.next()) {
                    val race = Race(
                        id = it.getInt("raceId"),
                        name = it.getString("raceName"),
                        numberOfLaps = it.getInt("numberOfLaps"),
                        raceNum = it.getInt("raceNumber"),
                        time = it.getTimestamp("time").toLocalDateTime(),
                        status = it.getString("status"),
                        tournament = Tournament(
                            id = it.getInt("seasonId"),
                            year = it.getInt("seasonYear"),
                            name = it.getString("seasonName"),
                        ),
                        circuit = Circuit(
                            id = it.getInt("circuitId"),
                            name = it.getString("circuitName"),
                            country = it.getString("circuitCountry")
                        )
                    )
                    return race
                } else return null
            }
        }
    }
}