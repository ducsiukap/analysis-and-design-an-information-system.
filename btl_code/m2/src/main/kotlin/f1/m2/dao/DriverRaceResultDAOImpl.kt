package f1.m2.dao

import f1.m2.model.DriverRaceResult
import org.springframework.stereotype.Repository

@Repository
class DriverRaceResultDAOImpl : DAO(), DriverRaceResultDAO {
    override fun findAllByRaceAndTeam(rid: Int, tid: Int): ArrayList<DriverRaceResult> {
        val results = ArrayList<DriverRaceResult>()
        //
        return results
    }
}