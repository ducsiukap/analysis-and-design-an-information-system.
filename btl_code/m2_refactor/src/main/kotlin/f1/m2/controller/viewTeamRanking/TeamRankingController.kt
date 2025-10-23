package f1.m2.controller.viewTeamRanking

import f1.m2.model.Race
import f1.m2.model.Tournament
import f1.m2.model.User
import f1.m2.service.DriverRaceResultService
import f1.m2.service.RaceService
import f1.m2.service.TeamRaceStatService
import f1.m2.service.TeamResultService
import f1.m2.service.TeamService
import f1.m2.service.TournamentService
import jakarta.servlet.http.HttpSession
import org.springframework.stereotype.Controller
import org.springframework.ui.Model
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.ModelAttribute
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.SessionAttributes
import org.springframework.web.servlet.mvc.support.RedirectAttributes
import java.net.URLEncoder
import java.time.Duration


@Controller
@RequestMapping("/rankings/team")
@SessionAttributes("ranking_team_seasons", "ranking_team_races")
class TeamRankingController(
    private val tourService: TournamentService,
    private val raceService: RaceService,
    private val trService: TeamResultService,
    private val teamService: TeamService,
    private val trsService: TeamRaceStatService,
    private val drrService: DriverRaceResultService

) {
    @ModelAttribute("ranking_team_seasons")
    fun getSeasons() = tourService.getAllSeason()

    @ModelAttribute("ranking_team_races")
    fun initRaces(): ArrayList<Race> = ArrayList()

    // -----------------------------
    // general rankings
    @GetMapping
    fun getTeamRanking(
        @ModelAttribute("ranking_team_seasons") seasons: ArrayList<Tournament>,
        @ModelAttribute("ranking_team_races") races: ArrayList<Race>,

        @RequestParam(value = "season", required = false) seasonYear: Int?,
        @RequestParam(value = "race", required = false) raceName: String?,

        session: HttpSession,

        redirectAttributes: RedirectAttributes,
        model: Model,
    ): String {
//        println("ss: " + seasonYear + " r: " + raceName)

        if (seasons.isEmpty()) {
            redirectAttributes.addFlashAttribute("message", "No season is available")
            return "redirect:/error"
        }

        if (seasonYear == null) return "redirect:/rankings/team?season=${seasons[0].year}"
        // selected season
        val season =
            seasons.firstOrNull { it.year == seasonYear } ?: return "redirect:/rankings/team?season=${seasons[0].year}"

        if (races.isEmpty() || races[0].tournament.year == season.year) {
            races.clear()
            races.addAll(raceService.getSeasonRace(season))
            model.addAttribute("ranking_team_races", races)
        }

        // lay ket qua
        if (raceName == null || raceName.isEmpty() || raceName == "all") {
            model.addAttribute("ranking_team_results", trService.getTeamRanking(season))
        } else {
            val race = races.firstOrNull { it.name == raceName } ?: return "redirect:/error"
            model.addAttribute("ranking_team_results", trService.getTeamRanking(race))
            model.addAttribute("ranking_team_race", race) // race duoc chon
        }
        model.addAttribute("ranking_team_season", season) // mua giai duoc chon

        val user = session.getAttribute("user") as? User
        if (user == null) return "public/rankings/teamRankings"
        else {
            when (user.type) {
                "staff" -> return "staff/rankings/teamRankings"
                else -> return "public/rankings/teamRankings"
            }
        }
    }

    // -----------------------------
    // team season stat
    @GetMapping("/{team}")
    fun getTeamSeasonResult(

        @PathVariable("team") teamName: String,

        @ModelAttribute("ranking_team_seasons") seasons: ArrayList<Tournament>,
        @RequestParam(value = "season", required = false) seasonYear: Int?,

        model: Model,
        session: HttpSession,
        redirectAttributes: RedirectAttributes,
    ): String {

//        println("ss: $seasonYear, t: $team")

        if (seasons.isEmpty()) {
            redirectAttributes.addFlashAttribute("message", "No season is available")
            return "redirect:/error"
        }
        if (seasonYear == null) return "redirect:/rankings/team/$teamName?season=${seasons[0].year}"

        val season = seasons.firstOrNull { it.year == seasonYear } ?: return "redirect:/error"
        val teams = teamService.getTeamOfSeason(season)
        if (teamName.isEmpty() || teamName == "_") return "redirect:/rankings/team/${teams[0].name}?season=${season.year}"

        val team = teams.firstOrNull { it.name == teamName } ?: return "redirect:/error"

        val stats = trsService.getTeamSeasonResult(season, team)

        model.addAttribute("ranking_team_stats", stats)
        model.addAttribute("ranking_team_teams", teams)
        model.addAttribute("ranking_team_season", season)
        model.addAttribute("ranking_team_team", team)

        val user = session.getAttribute("user") as? User
        if (user == null) return "public/rankings/teamSeasonResult"
        else {
            when (user.type) {
                "staff" -> return "staff/rankings/teamSeasonResult"
                else -> return "public/rankings/teamSeasonResult"
            }
        }
    }

    // -----------------------------
    // team race result
    @GetMapping("/{team}/race/{race}")
    fun getTeamRaceResult(
        @PathVariable("team") teamName: String,
        @PathVariable("race") raceName: String,
        @RequestParam(value = "season", required = false) seasonYear: Int?,

        @ModelAttribute("ranking_team_seasons") seasons: ArrayList<Tournament>,
        @ModelAttribute("ranking_team_races") races: ArrayList<Race>,

        redirectAttributes: RedirectAttributes,
        session: HttpSession,
        model: Model

    ): String {
        println("ss: $seasonYear, r: $raceName, t: $teamName")
        // season
        if (seasons.isEmpty()) {
            redirectAttributes.addFlashAttribute("message", "No season is available")
            return "redirect:/error"
        }
        if (seasonYear == null) return "redirect:/rankings/team/$teamName/race/$raceName?season=${seasons[0].year}"
        val season = seasons.firstOrNull { it.year == seasonYear } ?: return "redirect:/error"

        // race
        if (races.isEmpty() || races[0].tournament.year == season.year) {
            races.clear()
            races.addAll(raceService.getSeasonRace(season))
            model.addAttribute("ranking_team_races", races)
        }
        if (races.isEmpty()) {
            redirectAttributes.addFlashAttribute("message", "No race is available")
            return "redirect:/error"
        }
        if (raceName.isEmpty() || raceName == "_") {
            return "redirect:/rankings/team/$teamName/race/${races[0].name}?season=${seasons[0].year}"
        }
        val race = races.firstOrNull { it.name == raceName } ?: return "redirect:/error"

        // team
        val teams = teamService.getTeamOfSeason(season)
        if (teams.isEmpty()) {
            redirectAttributes.addFlashAttribute("message", "No team is available")
            return "redirect:/error"
        }
        if (teamName.isEmpty() || teamName == "_") {
            return "redirect:/rankings/team/${teams[0].name}/race/$raceName?season=${season.year}"
        }
        val team = teams.firstOrNull { it.name == teamName } ?: return "redirect:/error"

        // result
        val results = drrService.getRaceResult(race, team)

        // tach thoi gian
        val resultTimes = ArrayList<String>()
        for (result in results) {
            val time = Duration.ofMillis(result.time)
            val timeStr = "${time.toHours()}:${time.toMinutesPart()}:${time.toSecondsPart()}:${time.toMillisPart()}"
            resultTimes.add(timeStr)
        }

        // send data to view
        model.addAttribute("ranking_team_results", results)
        model.addAttribute("ranking_team_teams", teams)
        model.addAttribute("ranking_team_race", race)
        model.addAttribute("ranking_team_season", season)
        model.addAttribute("ranking_team_team", team)

        model.addAttribute("ranking_team_resultTimes", resultTimes)

        val user = session.getAttribute("user") as? User
        if (user == null) return "public/rankings/teamRaceResult"
        else {
            when (user.type) {
                "staff" -> return "staff/rankings/teamRaceResult"
                else -> return "public/rankings/teamRaceResult"
            }
        }
    }
}