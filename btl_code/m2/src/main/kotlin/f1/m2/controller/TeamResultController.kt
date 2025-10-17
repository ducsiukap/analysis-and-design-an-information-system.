package f1.m2.controller

import f1.m2.model.Race
import f1.m2.model.Staff
import f1.m2.model.Tournament
import f1.m2.service.RaceService
import f1.m2.service.TeamResultService
import f1.m2.service.TournamentService
import jakarta.servlet.http.HttpSession
import org.springframework.stereotype.Controller
import org.springframework.ui.Model
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.servlet.view.InternalResourceViewResolver
import kotlin.math.PI

@Controller
class TeamResultController(
    private val trService: TeamResultService,
    private val tourService: TournamentService,
    private val raceService: RaceService,
    private val internalResourceViewResolver: InternalResourceViewResolver,
) {


    @GetMapping("/rankings/{year}/team")
    fun getTeamRanking(
        session: HttpSession,
        model: Model,
        @PathVariable("year") year: Int
    ): String {
        // reuse session
        var seasons = session.getAttribute("seasons") as? ArrayList<Tournament> ?: emptyList()
        // if nodata
        if (seasons.isEmpty()) {
            seasons = tourService.getAllSeason()
            session.setAttribute("seasons", seasons)
        }
        // selected year
        val selected = seasons.firstOrNull { it.year == year }
        if (selected == null) {
            return "redirect:/error"
        }

        // get & save races
        val races = raceService.getSeasonRace(selected)
        session.setAttribute("races", races)
        // get rankings
        val rankings = trService.getTeamRanking(selected)

        // send to view
        model.addAttribute("seasons", seasons.map { ss -> ss.year })
        model.addAttribute("selectedSeason", year)
        model.addAttribute("races", races)
        model.addAttribute("rankings", rankings)

        //===============
        // phan quyen
        // get user
        val user = session.getAttribute("user")
        return when (user) {
            !is Staff -> "public/rankings/teamRankings"
            else -> "staff/rankings/teamRankings"
        }
    }

    @GetMapping("/rankings/{year}/team/{race}")
    fun getTeamRankingRace(
        session: HttpSession,
        model: Model,
        @PathVariable("year") year: Int,
        @PathVariable("race") race: String
    ): String {
        if (race == "all") return "redirect:/rankings/${year}/team"

        // reuse session
        // seasons
        var seasons = session.getAttribute("seasons") as? ArrayList<Tournament> ?: emptyList()
        if (seasons.isEmpty()) {
            seasons = tourService.getAllSeason()
            session.setAttribute("seasons", seasons)
        }
        val selectedSeason = seasons.firstOrNull { it.year == year }
        if (selectedSeason == null) return "redirect:/error"
        // race
        var races = session.getAttribute("races") as? ArrayList<Race> ?: emptyList()
        if (races.isEmpty()) {
            races = raceService.getSeasonRace(selectedSeason)
            session.setAttribute("races", races)
        }
        val selectedRace = races.firstOrNull { it.name == race }
        if (selectedRace == null) return "redirect:/error"

        // get ranking of race
        val rankings = trService.getTeamRanking(selectedRace)

        // send to view
        model.addAttribute("seasons", seasons.map { ss -> ss.year })
        model.addAttribute("selectedSeason", year)
        model.addAttribute("races", races)
        model.addAttribute("selectedRace", race)
        model.addAttribute("rankings", rankings)

        //===============
        // phan quyen
        // get user
        val user = session.getAttribute("user")
        return when (user) {
            !is Staff -> "public/rankings/teamRankings"
            else -> "staff/rankings/teamRankings"
        }
    }
}