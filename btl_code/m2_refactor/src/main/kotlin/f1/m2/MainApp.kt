package f1.m2

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication

@SpringBootApplication
class MainApp

fun main(args: Array<String>) {
	runApplication<MainApp>(*args)
}
