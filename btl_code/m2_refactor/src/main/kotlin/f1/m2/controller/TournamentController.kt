package f1.m2.controller

import f1.m2.service.TournamentService
import org.springframework.stereotype.Controller
import org.springframework.web.bind.annotation.GetMapping

@Controller
class TournamentController(private val tourService: TournamentService) {

//    @GetMapping("")
//    fun getTeamRanking() {
//
//    }
}