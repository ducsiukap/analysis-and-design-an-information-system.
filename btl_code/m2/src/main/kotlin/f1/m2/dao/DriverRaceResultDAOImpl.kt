package f1.m2.dao

import f1.m2.model.Driver
import f1.m2.model.DriverRaceResult
import f1.m2.model.Race
import f1.m2.model.Team
import org.springframework.stereotype.Repository
import java.time.Duration

@Repository
class DriverRaceResultDAOImpl : DAO(), DriverRaceResultDAO {
    override fun findAllByRaceAndTeam(rid: Int, tid: Int): ArrayList<DriverRaceResult> {
        val results = ArrayList<DriverRaceResult>()
        //
        val sql = """
            SELECT 
                d.id as id, d.laps as laps, d.time as time, d.point as point, d.position as position, 
                r.id as raceId, r.name as raceName,
                dr.id as driverId, dr.number as driverNumber, dr.name as driverName, 
                t.id as teamId, t.name as teamName
            FROM tblDriverRaceResult as d
            JOIN tblRace as r
                ON r.id = d.tblRaceId
            JOIN tblDriver as dr
                ON dr.id = d.tblDriverId
            JOIN tblTeam as t
                ON t.id = d.tblTeamId
            WHERE r.id = ? AND t.id = ?
        """.trimIndent()
        conn.prepareStatement(sql).use { pstm ->
            pstm.setInt(1, rid)
            pstm.setInt(2, tid)
            pstm.executeQuery().use {
                while (it.next()) {
                    val result = DriverRaceResult(
                        id = it.getInt("id"),
                        laps = it.getInt("laps"),
                        time = Duration.ofMillis(it.getLong("time")),
                        point = it.getInt("point"),
                        position = it.getInt("position"),
                        race = Race(
                            id = it.getInt("raceId"),
                            name = it.getString("raceName")
                        ),
                        driver = Driver(
                            id = it.getInt("driverId"),
                            name = it.getString("driverName"),
                            number = it.getInt("driverNumber")
                        ),
                        team = Team(
                            id = it.getInt("teamId"),
                            name = it.getString("teamName")
                        )
                    )
                    results.add(result)
                }
            }
        }
//        public final var id: Int = -1,
//        public final var position: Int = -1,
//        public final var laps: Int = -1,
//        public final var time: Duration = Duration.ZERO,
//        public final var point: Int = -1,
//        public final var startingPos: Int = -1,
//        public final var race: Race,
//        public final var driver: Driver,
//        public final var team: Team
        return results
    }
}