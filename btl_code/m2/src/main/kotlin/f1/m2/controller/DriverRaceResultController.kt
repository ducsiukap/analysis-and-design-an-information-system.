package f1.m2.controller

import f1.m2.model.Race
import f1.m2.model.Staff
import f1.m2.model.Team
import f1.m2.model.Tournament
import f1.m2.service.DriverRaceResultService
import f1.m2.service.RaceService
import f1.m2.service.TeamService
import f1.m2.service.TournamentService
import jakarta.servlet.http.HttpSession
import org.springframework.stereotype.Controller
import org.springframework.ui.Model
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable

@Controller
class DriverRaceResultController(
    private val drrService: DriverRaceResultService,
    private val tourService: TournamentService,
    private val teamService: TeamService,
    private val raceService: RaceService,
) {
    @GetMapping("/results/{year}/team/{team}/race/{race}")
    fun getTeamRaceResult(
        session: HttpSession,
        model: Model,
        @PathVariable("year") year: Int,
        @PathVariable("team") team: String,
        @PathVariable("race") race: String,
    ): String {
        // seasons
        var seasons = session.getAttribute("seasons") as? List<Tournament> ?: emptyList()
        if (seasons.isEmpty()) {
            seasons = tourService.getAllSeason()
            session.setAttribute("seasons", seasons)
        }
        val selectedSeason = seasons.firstOrNull { it.year == year }
        if (selectedSeason == null) return "redirect:/error"
        // teams
        var teams = session.getAttribute("teams") as? List<Team> ?: emptyList()
        if (teams.isEmpty()) {
            teams = teamService.getTeamOfSeason(selectedSeason)
            session.setAttribute("teams", teams)
        }
        val selectedTeam = teams.firstOrNull { it.name == team }
        if (selectedTeam == null) return "redirect:/error"
        // races
        var races = session.getAttribute("races") as? List<Race> ?: emptyList()
        if (races.isEmpty()) {
            races = raceService.getSeasonRace(selectedSeason)
            session.setAttribute("races", races)
        }
        val selectedRace = races.firstOrNull { it.name == race }
        if (selectedRace == null) return "redirect:/error"
        session.setAttribute("races", races)

        // result
        val results = drrService.getRaceResult(selectedRace, selectedTeam)

        // send to view
        model.addAttribute("seasons", seasons.map { it.year })
        model.addAttribute("races", races)
        model.addAttribute("teams", teams)
        model.addAttribute("selectedSeason", year)
        model.addAttribute("selectedTeam", team)
        model.addAttribute("selectedRace", race)
        model.addAttribute("results", results)

        // ========================
        // phan quyen
        val user = session.getAttribute("user")
        return if (user !is Staff) {
            "public/rankings/teamRaceResult"
        } else {
            "staff/rankings/teamRaceResult"
        }
    }

    @GetMapping("/results/{year}")
    fun getTeamRaceResult(
        session: HttpSession,
        @PathVariable("year") year: Int,
    ): String {
        // season
        var seasons = session.getAttribute("seasons") as? List<Tournament> ?: emptyList()
        if (seasons.isEmpty()) {
            seasons = tourService.getAllSeason()
            session.setAttribute("seasons", seasons)
        }
        val selectedSeason = seasons.firstOrNull { it.year == year }
        if (selectedSeason == null) return "redirect:/error"

        // team
        val teams = teamService.getTeamOfSeason(selectedSeason)
        if (teams.isEmpty()) return "redirect:/error"
        session.setAttribute("teams", teams)

        // race
        val races = raceService.getSeasonRace(selectedSeason)
        if (races.isEmpty()) return "redirect:/error"
        session.setAttribute("races", races)

        return "redirect:/results/$year/team/${teams[0].name}/race/${races[0].name}"
    }

}