//driver race result
const r = [
    {"id": 1, "race": "Louis Vuitton Australian Grand Prix 2025", "laps": 58},
    {"id": 2, "race": "Heineken Chinese Grand Prix 2025", "laps": 56},
    {"id": 3, "race": "Lenovo Japanese Grand Prix 2025", "laps": 53},
    {"id": 4, "race": "Bahrain Grand Prix 2025", "laps": 57},
    {"id": 5, "race": "STC Saudi Arabian Grand Prix 2025", "laps": 50},
    {"id": 6, "race": "CRYPTO.COM Miami Grand Prix 2025", "laps": 57},
    {"id": 7, "race": "AWS Gran Premio del Made in Italy e Dell Emilia-Romagna 2025", "laps": 63},
    {"id": 8, "race": "Grand Prix de Monaco 2025", "laps": 78},
    {"id": 9, "race": "Aramco Gran Premio de España 2025", "laps": 66},
    {"id": 10, "race": "Pirelli Grand Prix Du Canada 2025", "laps": 70},
    {"id": 11, "race": "MSC Cruises Austrian Grand Prix 2025", "laps": 71},
    {"id": 12, "race": "Qatar Airways British Grand Prix 2025", "laps": 52},
    {"id": 13, "race": "Belgian Grand Prix 2025", "laps": 44},
    {"id": 14, "race": "Lenovo Hungarian Grand Prix 2025", "laps": 70},
    {"id": 15, "race": "Heineken Dutch Grand Prix 2025", "laps": 72},
    {"id": 16, "race": "Pirelli Gran D'Italia 2025", "laps": 53},
    {"id": 17, "race": "Qatar Airways Azerbaijan Grand Prix 2025", "laps": 51},
    {"id": 18, "race": "Singapore Airlines Singapore Grand Prix 2025", "laps": 62},
    {"id": 19, "race": "MSC Cruises United States Grand Prix 2025", "laps": 56},
    {"id": 20, "race": "Gran Premio de La Ciudad de México 2025", "laps": 71},
    {"id": 21, "race": "MSC Cruises Grande Premio de Sao Paulo 2025", "laps": 71},
    {"id": 22, "race": "Heineken Las Vegas Grand Prix 2025", "laps": 50},
    {"id": 23, "race": "Qatar Airways Qatar Grand Prix 2025", "laps": 57},
    {"id": 24, "race": "Etihad Airways Abu Dhabi Grand Prix 2025", "laps": 58}
]


const d = [
    {"id": 1, "name": "Oscar Piastri"},
    {"id": 2, "name": "Lando Norris"},
    {"id": 3, "name": "Max Verstappen"},
    {"id": 4, "name": "George Russell"},
    {"id": 5, "name": "Charles Leclerc"},
    {"id": 6, "name": "Lewis Hamilton"},
    {"id": 7, "name": "Andrea Kimi Antonelli"},
    {"id": 8, "name": "Alex Albon"},
    {"id": 9, "name": "Isack Hadjar"},
    {"id": 10, "name": "Nico Hulkenberg"},
    {"id": 11, "name": "Fernando Alonso"},
    {"id": 12, "name": "Carlos Sainz"},
    {"id": 13, "name": "Lance Stroll"},
    {"id": 14, "name": "Liam Lawson"},
    {"id": 15, "name": "Esteban Ocon"},
    {"id": 16, "name": "Pierre Gasly"},
    {"id": 17, "name": "Yuki Tsunoda"},
    {"id": 18, "name": "Gabriel Bortoleto"},
    {"id": 19, "name": "Oliver Bearman"},
    {"id": 20, "name": "Franco Colapinto"},
    {"id": 21, "name": "Jack Doohan"}
]


const t = [
    {"id": 1, "name": "McLaren Formula 1 Team"},
    {"id": 2, "name": "Mercedes Formula 1 Team"},
    {"id": 3, "name": "Scuderia Ferrari"},
    {"id": 4, "name": "Red Bull Racing"},
    {"id": 5, "name": "Williams Racing"},
    {"id": 6, "name": "RB F1 Team"},
    {"id": 7, "name": "Aston Martin F1 Team"},
    {"id": 8, "name": "Sauber F1 Team"},
    {"id": 9, "name": "Haas F1 Team"},
    {"id": 10, "name": "Alpine F1 Team"}
]

function calcTime(baseTime, gapStr) {
    const [h, m, s] = baseTime.split(':').map(parseFloat);
    let total = h * 3600 + m * 60 + s;
    const gap = parseFloat(gapStr.replace('+', ''));
    total += gap;

    const hh = Math.floor(total / 3600);
    const mm = Math.floor((total % 3600) / 60);
    const ss = (total % 60).toFixed(3).padStart(6, '0');

    return `${hh}:${mm.toString().padStart(2, '0')}:${ss}`;
}

function toMS(timeStr) {
    const [hms, msStr] = timeStr.split('.');
    const [hours, minutes, seconds] = hms.split(':').map(Number);
    const millis = msStr ? Number(msStr) : 0;
    return hours * 3600 * 1000 + minutes * 60 * 1000 + seconds * 1000 + millis;
}


for (let i = 1; i < 19; i++) {
    let res = await fetch(`https://f1api.dev/api/2025/${i}/race`);
    res = await res.json();

    const race = res.races;
    const matchedRace = r.find(x => x.race === race.raceName);
    // console.log(matchedRace);
    const results = race.results;
    if (i === 6) results[0].time = "1:28:51.587"
    else if (i === 8) results[0].time = "1:40:33.843"
    else if (i === 12) results[0].time = "1:37:15.735"
    else if (i === 15) results[0].time = "1:38:29.849"
    for (let r of results) {
        const driverid = d.find(x => x.name.startsWith(r.driver.name)).id;
        const teamid = t.find(x => r.team.teamName === x.name).id;
        let time = r.time;
        let laps = matchedRace.laps;

        if (time.startsWith("DNF")) {
            laps = time.slice(5, (time.indexOf(")")))
            time = -1
        } else if (time.startsWith("+")) {
            time = toMS(calcTime(results[0].time, time));
        } else {
            time = toMS(time);
        }
        if (r.grid === "not available") r.grid = "null"

        if (r.position === "-" || r.position === "NC") {
            r.position = "-1"
            if (r.position === "-1")
                laps -= Math.max(laps - 1, 0);
        }
        console.log(`(${r.grid}, ${laps}, ${time}, ${r.position}, ${r.points}, ${matchedRace.id}, ${driverid}, ${teamid}),`)
    }
}

// =================================
const td = [
    {"teamId": 1, "drivers": [1, 2]},
    {"teamId": 2, "drivers": [4, 7]},
    {"teamId": 3, "drivers": [5, 6]},
    {"teamId": 4, "drivers": [3, 17]},
    {"teamId": 5, "drivers": [8, 12]},
    {"teamId": 6, "drivers": [9, 14]},
    {"teamId": 7, "drivers": [11, 13]},
    {"teamId": 8, "drivers": [10, 18]},
    {"teamId": 9, "drivers": [15, 19]},
    {"teamId": 10, "drivers": [16, 20]},
]

for (let i = 18; i < 24; ++i) {
    for (let j = 0; j < 10; ++j) {
        for (let k = 0; k < td[j].drivers.length; k++) {

            console.log(`(0, 0, 0, 0, 0, ${r[i].id}, ${td[j].drivers[k]}, ${td[j].teamId}),`)
        }
    }
}