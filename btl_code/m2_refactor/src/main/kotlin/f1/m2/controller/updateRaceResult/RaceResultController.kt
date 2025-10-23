package f1.m2.controller.updateRaceResult

import f1.m2.model.DriverRaceResult
import f1.m2.model.Race
import f1.m2.model.Tournament
import f1.m2.service.DriverRaceResultService
import f1.m2.service.RaceService
import f1.m2.service.TournamentService
import java.net.URLEncoder
import org.springframework.stereotype.Controller
import org.springframework.ui.Model
import org.springframework.web.bind.annotation.GetMapping
import org.springframework.web.bind.annotation.ModelAttribute
import org.springframework.web.bind.annotation.PostMapping
import org.springframework.web.bind.annotation.RequestMapping
import org.springframework.web.bind.annotation.RequestParam
import org.springframework.web.bind.annotation.SessionAttributes
import org.springframework.web.servlet.mvc.support.RedirectAttributes
import java.time.Duration

data class ResultWrapper(
    var results: MutableList<DriverRaceResult> = mutableListOf()
)

@Controller
@SessionAttributes("updateResult_seasons", "updateResult_races", "updateResult_results")
@RequestMapping("/results/update")
class RaceResultController(
    private val tourService: TournamentService,
    private val drrService: DriverRaceResultService,
    private val raceService: RaceService
) {

    @ModelAttribute("updateResult_seasons")
    fun getSeasons() = tourService.getAllSeason()

    @ModelAttribute("updateResult_races")
    fun getRaces(): MutableList<Race> = mutableListOf()

    @ModelAttribute("updateResult_results")
    fun getResults(): ResultWrapper = ResultWrapper()


    // step1: get form update
    @GetMapping
    fun getFormUpdateResult(
        model: Model,
        @ModelAttribute("updateResult_seasons") seasons: List<Tournament>,
        @ModelAttribute("updateResult_races") races: MutableList<Race>,
        @ModelAttribute("updateResult_results") resultWrapper: ResultWrapper,

        @RequestParam("season") seasonYear: Int?,
        @RequestParam("race") raceName: String?,

        @ModelAttribute("error") error: String?,
        @ModelAttribute("success") success: String?,
        redirectAttributes: RedirectAttributes

    ): String {

        // khong co mua giai nao
        if (seasons.isEmpty()) {
            redirectAttributes.addFlashAttribute("message", "No season is available")
            return "redirect:/error"
        }

        // vao trang lan dau /or sai path (co race nhung khong co seasonYear)
        if (seasonYear == null) {
            return "redirect:/results/update?season=${seasons[0].year}"
        }

        // vao bang link nhung season khong ton tai
        val season = seasons.firstOrNull { it.year == seasonYear }
        if (season == null) {
            redirectAttributes.addFlashAttribute("message", "404 not found...")
            return "redirect:/error"
        }

        // danh sach races
        if (races.isEmpty()) { // races trong session empty
            // thu lay races moi
            races.addAll(raceService.getSeasonRace(season))

            // neu van empty => mua giai chua co race
            if (races.isEmpty()) {
                redirectAttributes.addFlashAttribute("message", "No race is available")
                return "redirect:/error"
            }

            // luu session
            model.addAttribute("updateResult_races", races)
        }

        // select season
        if (raceName == null || raceName == "") return "redirect:/results/update?season=${seasonYear}&race=${
            URLEncoder.encode(
                races[0].name, "UTF-8"
            )
        }"

        // select 1 race tu giao dien
        val race = races.firstOrNull { it.name == raceName }
        if (race == null) {
            redirectAttributes.addFlashAttribute("message", "404 not found...")
            return "redirect:/error"
        }

        // lay ket qua
        var results = resultWrapper.results
        if (results.isEmpty() || results[0].race.name != raceName) {
            results = drrService.getRaceResult(race)
            resultWrapper.results = results
        }

        // tach thoi gian
        val hours = ArrayList<Int>()
        val minutes = ArrayList<Int>()
        val seconds = ArrayList<Int>()
        val millis = ArrayList<Int>()
        for (result in results) {
            val time = Duration.ofMillis(result.time)
//            println(time)
            hours.add(time.toHours().toInt())
            minutes.add(time.toMinutes().toInt() % 60)
            seconds.add(time.toSeconds().toInt() % 60)
            millis.add(time.toMillis().toInt() % 1000)
        }

        // selected
        model.addAttribute("updateResult_season", season)
        model.addAttribute("updateResult_race", race)

        model.addAttribute("updateResult_hours", hours)
        model.addAttribute("updateResult_minutes", minutes)
        model.addAttribute("updateResult_seconds", seconds)
        model.addAttribute("updateResult_millis", millis)

        // error/succes
        model.addAttribute("updateResult_error", error)
        model.addAttribute("updateResult_success", success)

        return "staff/results/updateRaceResult"
    }

    // step2: post form update ->  render review
    @PostMapping
    fun postFromUpdateResult(
        @ModelAttribute("updateResult_results") resultWrapper: ResultWrapper,

        @RequestParam("season") seasonYear: Int,
        @RequestParam("race") raceName: String,

        redirectAttributes: RedirectAttributes,
    ): String {
        val results = resultWrapper.results

        // check
        for (result in results) {

            if (result.time < 0 || result.laps < 0 || result.startingPos < 0) {
                redirectAttributes.addFlashAttribute("error", "Invalid data of row ${result.driver.name}")
                return "redirect:/results/update?season=${seasonYear}&race=${URLEncoder.encode(raceName, "UTF-8")}"
            }
        }

        results.sortWith(compareBy<DriverRaceResult> { it.time == 0L || it.laps == 0 }.thenByDescending { it.laps }
            .thenBy { it.time })
        val points = listOf(25, 18, 15, 12, 10, 8, 6, 4, 2, 1)
        for ((idx, result) in results.withIndex()) {
            if (result.laps >= (results[0].laps * 9 / 10) && result.time > 0) {
                result.point = if (idx < 10) points[idx] else 0
                result.position = idx + 1
            } else if (result.time == 0L || result.laps == 0) {
                result.point = 0
                result.position = 0
            }
        }

        resultWrapper.results = results

        // render review page
        return "redirect:/results/update/review?season=${seasonYear}&race=${URLEncoder.encode(raceName, "UTF-8")}"
    }

    // review page
    @GetMapping("/review")
    fun getReviewResult(
        model: Model,

        @ModelAttribute("updateResult_results") resultWrapper: ResultWrapper,
        @ModelAttribute("updateResult_seasons") seasons: List<Tournament>,
        @ModelAttribute("updateResult_races") races: List<Race>,

        @RequestParam("season") seasonYear: Int,
        @RequestParam("race") raceName: String,

        @ModelAttribute("error") error: String?,

        redirectAttributes: RedirectAttributes,
    ): String {
        if (seasons.isEmpty() || races.isEmpty() || resultWrapper.results.isEmpty()) return "redirect:/error"

        val season = seasons.firstOrNull { it.year == seasonYear }
        if (season == null) {
            redirectAttributes.addFlashAttribute("error", "404 not found...")
            return "redirect:/error"
        }

        val race = races.firstOrNull { it.name == raceName }
        if (race == null) {
            redirectAttributes.addFlashAttribute("error", "404 not found...")
            return "redirect:/error"
        }
        // tach thoi gian
        val hours = ArrayList<Int>()
        val minutes = ArrayList<Int>()
        val seconds = ArrayList<Int>()
        val millis = ArrayList<Int>()
        for (result in resultWrapper.results) {
            val time = Duration.ofMillis(result.time)
            hours.add(time.toHours().toInt())
            minutes.add(time.toMinutes().toInt() % 60)
            seconds.add(time.toSeconds().toInt() % 60)
            millis.add(time.toMillis().toInt() % 1000)
        }

        model.addAttribute("updateResult_season", season)
        model.addAttribute("updateResult_race", race)

        model.addAttribute("updateResult_error", error)

        model.addAttribute("updateResult_hours", hours)
        model.addAttribute("updateResult_minutes", minutes)
        model.addAttribute("updateResult_seconds", seconds)
        model.addAttribute("updateResult_millis", millis)

        return "staff/results/confirmUpdateResult"
    }

    // step3: after user confirm
    @PostMapping("/save")
    fun saveResult(
        @ModelAttribute("updateResult_results") resultWrapper: ResultWrapper,

        @RequestParam("season") seasonYear: Int,
        @RequestParam("race") raceName: String,

        redirectAttributes: RedirectAttributes,
    ): String {
        try {
            val results = resultWrapper.results

            val ok = drrService.updateRaceResult(results as ArrayList<DriverRaceResult>)
            if (ok) {
                resultWrapper.results = mutableListOf()
                redirectAttributes.addFlashAttribute("success", "Update result of race $raceName successfully")
                return "redirect:/results/update?season=${seasonYear}&race=${URLEncoder.encode(raceName, "UTF-8")}"
            } else {
                redirectAttributes.addFlashAttribute(
                    "error", "Can not update result of race ${raceName}. Please try again later"
                )
                return "redirect:/results/update/review?season=${seasonYear}&race=${
                    URLEncoder.encode(
                        raceName, "UTF-8"
                    )
                }"
            }
        } catch (e: Exception) {
            redirectAttributes.addFlashAttribute("error", e.message)
            return "redirect:/results/update/review?season=${seasonYear}&race=${URLEncoder.encode(raceName, "UTF-8")}"
        }
    }
}