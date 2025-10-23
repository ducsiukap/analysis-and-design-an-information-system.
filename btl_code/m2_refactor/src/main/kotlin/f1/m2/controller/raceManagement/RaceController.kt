package f1.m2.controller.raceManagement

import f1.m2.model.Circuit
import f1.m2.model.Race
import f1.m2.model.Staff
import f1.m2.model.Tournament
import f1.m2.service.CircuitService
import f1.m2.service.RaceService
import f1.m2.service.TournamentService
import jakarta.servlet.http.HttpSession
import org.springframework.format.annotation.DateTimeFormat
import org.springframework.stereotype.Controller
import org.springframework.ui.Model
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.PathVariable
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestParam
import java.time.LocalDate
import java.time.LocalDateTime
import java.time.format.DateTimeFormatter

@Controller
class RaceController(
    private val tourService: TournamentService,
    private val raceService: RaceService,
    private val circuitService: CircuitService,
) {

    // ================================
    // raceMngView
    // ================================
    @GetMapping("/race/{year}")
    fun raceManagement(
        session: HttpSession, model: Model, @PathVariable("year") year: Int,
        @RequestParam("update", defaultValue = "false") update: Boolean
    ): String {
        // check user
        val user = session.getAttribute("user") ?: return "redirect:/"

        // season
        var seasons = session.getAttribute("seasons") as? ArrayList<Tournament> ?: emptyList()
        if (seasons.isEmpty()) {
            seasons = tourService.getAllSeason()
            session.setAttribute("seasons", seasons)
        }
        val selectedSeason = seasons.firstOrNull { it.year == year }
        if (selectedSeason == null) return "redirect:/error"

        // get All race
        var races = raceService.getSeasonRace(selectedSeason)

        // add
        model.addAttribute("seasons", seasons.map { it.year })
        model.addAttribute("selectedSeason", selectedSeason.year)
        model.addAttribute("races", races)

        return when (user) {
            is Staff -> "staff/race/raceManagement"
            else -> "redirect:/"
        }
    }

    @GetMapping("/race")
    fun raceManagement(): String {
        val year = LocalDate.now().year
        return "redirect:/race/${year}"
    }


    // ==============================
    // add new race
    // ==============================
    @GetMapping("/race/new")
    fun addNewRace(
        session: HttpSession,
        model: Model,
        @RequestParam("first", defaultValue = "false") first: Boolean,
    ): String {
        val user = session.getAttribute("user") ?: return "redirect:/"

        // seasons
        var seasons = session.getAttribute("seasons") as? ArrayList<Tournament> ?: emptyList()
        if (seasons.isEmpty()) {
            seasons = tourService.getAllSeason()
            session.setAttribute("seasons", seasons)
        }

        // circuits
        var circuits = session.getAttribute("circuits") as? ArrayList<Circuit> ?: emptyList()
        if (circuits.isEmpty()) {
            circuits = circuitService.getAllCircuits()
            session.setAttribute("circuits", circuits)
        }

        // race
        var race = session.getAttribute("race") as? Race
        if (race == null || first) {// first time
            race = Race(numberOfLaps = 0, tournament = seasons[0], circuit = circuits[0])
            session.setAttribute("race", race)
        }
        // formatted time
        val formattedTime = race.time.format(DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"))

        // race numbers
        val raceSeason = race.tournament
        val raceNumbers = tourService.getAvailableRaceNumbers(raceSeason)

        // send to client
        model.addAttribute("seasons", seasons)
        model.addAttribute("circuits", circuits)
        model.addAttribute("raceNumbers", raceNumbers)
        model.addAttribute("formattedRaceTime", formattedTime)
        model.addAttribute("race", race)

        return when (user) {
            is Staff -> "staff/race/raceConfig"
            else -> "redirect:/"
        }
    }

    @GetMapping("/race/config/{tournament}/{circuit}")
    fun addNewRace(
        session: HttpSession,
        @PathVariable("tournament") seasonId: Int,
        @PathVariable("circuit") circuitId: Int,
        @RequestParam("raceName", required = false) raceName: String,
        @RequestParam("raceLaps", required = false) raceLaps: Int,
        @RequestParam(
            "raceTime", required = false
        ) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) raceTime: LocalDateTime,

        @RequestParam("from") from: String
    ): String {
        var seasons = session.getAttribute("seasons") as? ArrayList<Tournament> ?: emptyList()
        if (seasons.isEmpty()) {
            seasons = tourService.getAllSeason()
            session.setAttribute("seasons", seasons)
        }
        val selectedSeason = seasons.firstOrNull { it.id == seasonId }
        if (selectedSeason == null) return "redirect:/error"

        var circuits = session.getAttribute("circuits") as? ArrayList<Circuit> ?: emptyList()
        if (circuits.isEmpty()) {
            circuits = circuitService.getAllCircuits()
            session.setAttribute("circuits", circuits)
        }
        val selectedCircuit = circuits.firstOrNull { it.id == circuitId }
        if (selectedCircuit == null) return "redirect:/error"

        var race = session.getAttribute("race") as? Race ?: return "redirect:/error"

        race.name = raceName
        race.numberOfLaps = raceLaps
        race.time = raceTime
        race.tournament = selectedSeason
        race.circuit = selectedCircuit

        session.setAttribute("selectedSeason", selectedSeason)
        session.setAttribute("selectedCircuit", selectedCircuit)
        session.setAttribute("race", race)

        return "redirect:${from}"
    }

    // ================================
    // modify an existing race
    // ================================
    @GetMapping("/race/{id}/edit")
    fun configRace(
        session: HttpSession,
        model: Model,
        @PathVariable("id") raceId: Int,
        @RequestParam("first", defaultValue = "false") first: Boolean,
    ): String {
        val user = session.getAttribute("user") ?: return "redirect:/"

        // get race
        var race = session.getAttribute("race") as? Race
        if (race == null || first) {
            race = raceService.getRace(raceId);

            if (race == null) return "redirect:/error"

            session.setAttribute("race", race)
            session.setAttribute("race-based-season", race.tournament)
        }

        // seasons
        var seasons = session.getAttribute("seasons") as? ArrayList<Tournament> ?: emptyList()
        if (seasons.isEmpty()) {
            seasons = tourService.getAllSeason()
            session.setAttribute("seasons", seasons)
        }

        // circuits
        var circuits = session.getAttribute("circuits") as? ArrayList<Circuit> ?: emptyList()
        if (circuits.isEmpty()) {
            circuits = circuitService.getAllCircuits()
            session.setAttribute("circuits", circuits)
        }

        // formatted time
        val formattedTime = race.time.format(DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"))

        // race numbers
        val raceSeason = race.tournament
        val raceNumbers = tourService.getAvailableRaceNumbers(raceSeason)

        val raceBasedSeason = model.getAttribute("race-based-season") as? Tournament
        if (raceBasedSeason == null || raceBasedSeason.year == raceSeason.year) {
            raceNumbers.addFirst(race.raceNum)
        }

        // send to client
        model.addAttribute("seasons", seasons)
        model.addAttribute("circuits", circuits)
        model.addAttribute("raceNumbers", raceNumbers)
        model.addAttribute("formattedRaceTime", formattedTime)
        model.addAttribute("race", race)

        return when (user) {
            is Staff -> "staff/race/raceConfig"
            else -> "redirect:/"
        }
    }

    // ================================
    // confirm update/create
    // ================================
    @PostMapping("/race/confirm")
    fun confirmRace(
        session: HttpSession,
        model: Model,

        @RequestParam("tournament", required = false) seasonId: Int?,
        @RequestParam("circuit", required = false) circuitId: Int?,
        @RequestParam("raceNumber", required = false) raceNum: Int?,
        @RequestParam("raceName", required = false) raceName: String?,
        @RequestParam("raceLaps", required = false) raceLaps: Int?,
        @RequestParam(
            "raceTime",
            required = false
        ) @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) raceTime: LocalDateTime?,
        @RequestParam("confirm", defaultValue = "false") confirm: Boolean

    ): String {
        val user = session.getAttribute("user") ?: return "redirect:/"
        //
        val race = session.getAttribute("race") as? Race ?: return "redirect:/error"
        if (confirm) {
//            println("check1")
            try {
                val ok = raceService.updateRace(race)
                if (ok) {
//                    println("success")
                    model.addAttribute("success", "Update race successfully")
                } else {
//                    println("failure")
                    model.addAttribute("error", "Update race failed")
                }
            } catch (e: Exception) {
//                println("failure-catch")
                model.addAttribute("error", e.message)
            }
        } else {
            race.name = raceName!!
            race.raceNum = raceNum!!
            race.time = raceTime!!
            race.numberOfLaps = raceLaps!!

            val seasons = session.getAttribute("seasons") as? ArrayList<Tournament> ?: return "redirect:/error"
            val season = seasons.firstOrNull { it.id == seasonId!! } ?: return "redirect:/error"
            race.tournament = season

            val circuits = session.getAttribute("circuits") as? ArrayList<Circuit> ?: return "redirect:/error"
            val circuit = circuits.firstOrNull { it.id == circuitId!! } ?: return "redirect:/error"
            race.circuit = circuit

            session.setAttribute("race", race)
        }

        // formatted time
        val formattedTime = race.time.format(DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"))

        // send to client
        model.addAttribute("race", race)
        model.addAttribute("formattedRaceTime", formattedTime)

        return when (user) {
            is Staff -> "staff/race/confirmConfigRace"
            else -> "redirect:/"
        }
    }

    // ================================
    // delete a race
    // ================================
    @GetMapping("/race/{id}/delete")
    fun confirmDelete(
        session: HttpSession,
        model: Model,
        @PathVariable("id") raceId: Int,
        @RequestParam("confirm", defaultValue = "false") confirm: Boolean
    ): String {
        val user = session.getAttribute("user") ?: return "redirect:/"
        val race = raceService.getRace(raceId) ?: return "redirect:/error"
        if (confirm) {
            val ok = raceService.deleteRace(race)
            if (ok) {
                model.addAttribute("success", "Delete race successfully")
            } else {
                model.addAttribute("error", "Some thing went wrong, try again")
            }
        }

        // formatted time
        val formattedTime = race.time.format(DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm"))

        // send to client
        model.addAttribute("race", race)
        model.addAttribute("formattedRaceTime", formattedTime)

        return when (user) {
            is Staff -> "staff/race/confirmDeleteRace"
            else -> "redirect:/"
        }
    }
}