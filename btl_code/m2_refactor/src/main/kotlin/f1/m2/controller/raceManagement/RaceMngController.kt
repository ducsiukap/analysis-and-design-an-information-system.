package f1.m2.controller.raceManagement

import f1.m2.model.Circuit
import f1.m2.model.Race
import f1.m2.model.Tournament
import f1.m2.service.CircuitService
import f1.m2.service.RaceService
import f1.m2.service.TournamentService
import org.springframework.stereotype.Controller
import org.springframework.ui.Model
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.ModelAttribute
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.SessionAttributes
import org.springframework.web.servlet.mvc.support.RedirectAttributes
import java.time.format.DateTimeFormatter


@Controller
@RequestMapping("/race/management")
@SessionAttributes(
    "race_management_seasons",
    "race_management_raceUpdate",
    "race_management_raceDelete",
    "race_management_circuits"
)
class RaceMngController(
    private val tourService: TournamentService,
    private val raceService: RaceService,
    private val circuitService: CircuitService,
) {
    // init data
    @ModelAttribute("race_management_seasons")
    fun getSeasons() = tourService.getAllSeason()

    @ModelAttribute("race_management_circuits")
    fun getCircuits() = circuitService.getAllCircuits()

    @ModelAttribute("race_management_raceUpdate")
    fun initRace() = Race(id = -2)

    // management page
    @GetMapping
    fun getRaceManagementPage(
        @ModelAttribute("race_management_seasons") seasons: List<Tournament>,
        @ModelAttribute("race_management_updateSuccess") success: String?,
        @ModelAttribute("race_management_deleteSuccess") delSuccess: String?,

        @RequestParam("season") seasonYear: Int?,

        redirectAttributes: RedirectAttributes,
        model: Model,
    ): String {

        // season
        if (seasons.isEmpty()) {
            redirectAttributes.addFlashAttribute("message", "No season found")
            return "redirect:/error"
        }
        if (seasonYear == null) return "redirect:/race/management?season=${seasons[0].year}"
        val season = seasons.firstOrNull { it.year == seasonYear } ?: return "redirect:/error"

        // race
        val races = raceService.getSeasonRace(season)

        // send to client
        model.addAttribute("race_management_season", season)
        model.addAttribute("race_management_races", races)

        model.addAttribute("race_management_updateSuccess", success)
        model.addAttribute("race_management_deleteSuccess", delSuccess)

        return "staff/race/raceManagement"
    }

    // ----------------------------------
    // add new / edit a season
    // add new season
    @GetMapping("/new")
    fun newRacePage(
        @ModelAttribute("race_management_seasons") seasons: List<Tournament>,
        @ModelAttribute("race_management_raceUpdate") race: Race,
        @ModelAttribute("race_management_validateError") error: String?,
        model: Model
    ): String {
//        if (seasonYear == null) return "redirect:/race/management/new?season=${seasons[0].year}"
//        val season = seasons.firstOrNull { it.year == seasonYear } ?: return "redirect:/error"
        val season = seasons[0]

        // circuit
        val circuits = circuitService.getAllCircuits()

        // free race nums
        val raceNums = tourService.getAvailableRaceNumbers(season)

        // new race
        var r = if (race.id == -2) Race(
            tournament = seasons[0],
//            tournament = Tournament(year = 2014),
            raceNum = raceNums[0],
            circuit = circuits[0],
        ) else race

        // formatted time de display
        val formattedTime = r.time.format(DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"))

        model.addAttribute("race_management_circuits", circuits)
        model.addAttribute("race_management_raceNumbers", raceNums)
        model.addAttribute("race_management_raceUpdate", r)
        model.addAttribute("race_management_formattedRaceTime", formattedTime)

        model.addAttribute("race_management_validateError", error)

        return "staff/race/raceConfig"
    }

    //    edit a race
    @GetMapping("/{year}/{race}/edit")
    fun getEditRacePage(
        @ModelAttribute("race_management_seasons") seasons: List<Tournament>,
        @ModelAttribute("race_management_raceUpdate") race: Race,
        @ModelAttribute("race_management_circuits") circuits: List<Circuit>,

        @PathVariable("year") seasonYear: Int,
        @PathVariable("race") raceName: String,

        @ModelAttribute("race_management_validateError") error: String?,

        model: Model,
    ): String {
        // season
        val season = seasons.firstOrNull { it.year == seasonYear } ?: return "redirect:/error"

        var r = race
        if (race.id == -2 || race.name != raceName || race.tournament.year != seasonYear) {
            val races = raceService.getSeasonRace(season)
            r = races.firstOrNull { it.name == raceName } ?: return "redirect:/error"
        }

        // formatted time de display
        val formattedTime = r.time.format(DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"))

        val raceNums = tourService.getAvailableRaceNumbers(season)

        model.addAttribute("race_management_circuits", circuits)
        model.addAttribute("race_management_raceNumbers", raceNums)
        model.addAttribute("race_management_raceUpdate", r)
        model.addAttribute("race_management_formattedRaceTime", formattedTime)

        model.addAttribute("race_management_validateError", error)

        return "staff/race/raceConfig"
    }

    // select season / post race
    @PostMapping("/new")
    fun postNewRace(
        @ModelAttribute("race_management_seasons") seasons: List<Tournament>,
        @ModelAttribute("race_management_raceUpdate") race: Race,
        @ModelAttribute("race_management_circuits") circuits: List<Circuit>,

//        @RequestParam("season") seasonYear: Int,
        @RequestParam("action", defaultValue = "change_season") action: String,
        redirectAttributes: RedirectAttributes,
        model: Model,
    ): String {
        // select season
        val season = seasons.firstOrNull { it.year == race.tournament.year } ?: return "redirect:/error"
        race.tournament = season

        if (action == "change_season") {
//            println("check1 - raceName: ${race.name}, circuit:${race.circuit.id} ${race.circuit.name}, ss: ${race.tournament.name}")
            val raceNums = tourService.getAvailableRaceNumbers(season)
            race.raceNum = raceNums[0]
            model.addAttribute("race_management_raceNumbers", raceNums)

            // formatted time de display
            val formattedTime = race.time.format(DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"))
            model.addAttribute("race_management_formattedRaceTime", formattedTime)

            return "staff/race/raceConfig"
        }

        if (race.name.isEmpty() || race.numberOfLaps < 1 || race.time.year != race.tournament.year) {
            redirectAttributes.addFlashAttribute("race_management_validateError", "Invalid race")
            return if (race.id == -1) "redirect:/race/management/new"
            else "redirect:/race/management/${race.tournament.year}/${race.name}/edit"
        }

        // post race
        val circuit = circuits.firstOrNull { it.name == race.circuit.name } ?: return "redirect:/error"
        race.circuit = circuit

        return "redirect:/race/management/confirm"
    }

    //     confirm page
    @GetMapping("/confirm")
    fun confirmUpdatePage(
        @ModelAttribute("race_management_raceUpdate") race: Race,
        @ModelAttribute("race_management_updateError") error: String?,
        model: Model
    ): String {

        // formatted time de display
        val formattedTime = race.time.format(DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"))
        model.addAttribute("race_management_formattedRaceTime", formattedTime)
        model.addAttribute("race_management_updateError", error)
        return "staff/race/confirmConfigRace"
    }

    // save race to db
    @PostMapping("/save")
    fun saveRace(
        @ModelAttribute("race_management_raceUpdate") race: Race,

        redirectAttributes: RedirectAttributes,
    ): String {

        try {
            val ok = raceService.updateRace(race)
            if (ok) {
                redirectAttributes.addFlashAttribute(
                    "race_management_updateSuccess",
                    "Save race ${race.name} successfully"
                )
                return "redirect:/race/management?season=${race.time.year}"
            } else {
                redirectAttributes.addFlashAttribute(
                    "race_management_updateError",
                    "Save race ${race.name} error. Try again!"
                )
                return "redirect:/race/management/confirm"
            }
        } catch (e: Exception) {
            redirectAttributes.addFlashAttribute("race_management_updateError", e.message)
            return "redirect:/race/management/confirm"
        }
    }

    // ------------------------------------
    // delete a season
    @GetMapping("/{season}/{race}/delete")
    fun confirmDeleteRace(
        @ModelAttribute("race_management_seasons") seasons: List<Tournament>,

        @PathVariable("season") seasonYear: Int,
        @PathVariable("race") raceName: String,

        @ModelAttribute("race_management_deleteError") error: String?,

        model: Model,
    ): String {
        val season = seasons.firstOrNull { it.year == seasonYear } ?: return "redirect:/error"

        val races = raceService.getSeasonRace(season)
        val race = races.firstOrNull { it.name == raceName } ?: return "redirect:/error"

        model.addAttribute("race_management_raceDelete", race)
        model.addAttribute("race_management_deleteError", error)

        // formatted time de display
        val formattedTime = race.time.format(DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"))
        model.addAttribute("race_management_formattedRaceTime", formattedTime)

        return "staff/race/confirmDeleteRace"
    }

    // do delete
    @PostMapping("/{season}/{race}/delete")
    fun deleteRace(
        @PathVariable("season") seasonYear: Int,
        @PathVariable("race") raceName: String,

        @ModelAttribute("race_management_raceDelete") race: Race,
        redirectAttributes: RedirectAttributes
    ): String {
        if (race.name != raceName || race.tournament.year != seasonYear) return "redirect:/error"

        val ok = raceService.deleteRace(race)
        if (ok) {
            redirectAttributes.addFlashAttribute(
                "race_management_deleteSuccess",
                "Delete race ${race.name} successfully!"
            )
            return "redirect:/race/management?season=${race.tournament.year}"
        } else {
            redirectAttributes.addFlashAttribute("race_management_deleteError", "Delete race $${race.name} error!")
            return "redirect:/race/management/${race.tournament.year}/${race.name}/delete"
        }
    }
}