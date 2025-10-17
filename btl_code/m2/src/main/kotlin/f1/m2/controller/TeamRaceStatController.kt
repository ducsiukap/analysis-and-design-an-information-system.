package f1.m2.controller

import f1.m2.model.Staff
import f1.m2.model.Team
import f1.m2.model.Tournament
import f1.m2.service.TeamRaceStatService
import f1.m2.service.TeamService
import f1.m2.service.TournamentService
import jakarta.servlet.http.HttpSession
import org.springframework.stereotype.Controller
import org.springframework.ui.Model
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable


@Controller
class TeamRaceStatController(
    private val trsService: TeamRaceStatService,
    private val tourService: TournamentService,
    private val teamService: TeamService,
) {

    @GetMapping("/results/{year}/team/{team}")
    fun getTeamSeasonStat(
        session: HttpSession,
        model: Model,
        @PathVariable("year") year: Int,
        @PathVariable("team") team: String
    ): String {
        // season
        var seasons = session.getAttribute("seasons") as? ArrayList<Tournament> ?: emptyList()
        if (seasons.isEmpty()) {
            seasons = tourService.getAllSeason()
            session.setAttribute("seasons", seasons)
        }
        val selectedSeason = seasons.firstOrNull { it.year == year }
        if (selectedSeason == null) return "redirect:/error"

        // team
        var teams = session.getAttribute("teams") as? ArrayList<Team> ?: emptyList()
        if (teams.isEmpty()) teams = teamService.getTeamOfSeason(selectedSeason)
        val selectedTeam = teams.firstOrNull { it.name == team }
        if (selectedTeam == null) return "redirect:/error"

        //
        val stats = trsService.getTeamSeasonResult(selectedSeason, selectedTeam)

        // send to view
        model.addAttribute("seasons", seasons.map { it.year })
        model.addAttribute("selectedSeason", selectedSeason.year)
        model.addAttribute("teams", teams)
        model.addAttribute("selectedTeam", selectedTeam.name)
        model.addAttribute("stats", stats)

        //================
        // phan quyen
        val user = session.getAttribute("user")
        return when (user) {
            !is Staff -> "public/rankings/teamSeasonResult"
            else -> "staff/rankings/teamSeasonResult"
        }
    }

    @GetMapping("/results/{year}/team")
    fun getTeamSeasonStat(
        session: HttpSession,
        @PathVariable("year") year: Int
    ): String {
        // season
        var seasons = session.getAttribute("seasons") as? ArrayList<Tournament> ?: emptyList()
        if (seasons.isEmpty()) {
            seasons = tourService.getAllSeason()
            session.setAttribute("seasons", seasons)
        }
        val selectedSeason = seasons.firstOrNull { it.year == year }
        if (selectedSeason == null) return "redirect:/error"

        // team
        val teams = teamService.getTeamOfSeason(selectedSeason)
        return if (teams.isEmpty()) {
            "redirect:/error"
        } else {
            session.setAttribute("teams", teams)
            "redirect:/results/${year}/team/${teams[0].name}"
        }
    }
}