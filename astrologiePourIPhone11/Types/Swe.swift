//
//  Swe.swift
//  astrology_macos
//
//  Created by Stéphane on 16.01.22.
//

import Foundation

class Swe {
    var bodies: [Bodie] = []
    var houses: [Swe14.House] = []
    init() {
        // Load json or default
        let chart = load_default_value()

        // Set path
        let swe02 = Swe02()
        swe02.set_ephe_path()
        //let path = swe02.get_library_path()

        // Compute julian day
        let swe08: Swe08 = Swe08()
        let julday = swe08.julday(year: chart.nYear, month: chart.nMonth, day: chart.nDay, hour: Double(chart.nHour), calandar: .gregorian)
        var utcTimeZone = TimeZone(year: chart.nYear, month: chart.nMonth, day: chart.nDay, hour: chart.nHour, min: chart.nMin, sec: 0.0)
        utcTimeZone.utc_time_zone(timezone: 2.0)
        let utcToJd = swe08.utc_to_jd(tz: utcTimeZone, calandar: .gregorian)

        // Compute bodies
        let swe03 = Swe03()
        let swe07 = Swe07()
        bodies.append(Swe.Bodie.init(bodie: .sun, calculUt: swe03.calc_ut(tjdUt: utcToJd.julianDayUt, ipl: .sun, iflag: .speed), phenoUt: swe07.pheno_ut(tjdUt: utcToJd.julianDayUt, ipl: .sun, iFlag: .speed)))

        // Computes houses
        let swe14 = Swe14()
        houses = swe14.houses(
                tjdUt: utcToJd.julianDayUt,
                geoLat: chart.nLat,
                geoLong: chart.nLng,
                hsys: CChar("W") ?? CChar.init())

        swe02.close()
    }

    struct Chart: Codable {
        let nLat: Double
        let nLng: Double
        let nTimeZone: Int32
        let nYear: Int32
        let nMonth: Int32
        let nDay: Int32
        let nHour: Int32
        let nMin: Int32
        let tLat: Double
        let tLng: Double
        let tTimeZone: Int32
        let tYear: Int32
        let tMonth: Int32
        let tDay: Int32
        let tHour: Int32
        let tMin: Int32
    }

    private func load_default_value() -> Chart {
        var decode: Chart = Chart.init(
                nLat: 46.12,
                nLng: 6.09,
                nTimeZone: 2,
                nYear: 1981,
                nMonth: 1,
                nDay: 1,
                nHour: 0,
                nMin: 0,
                tLat: 46.12,
                tLng: 6.09,
                tTimeZone: 2,
                tYear: 2022,
                tMonth: 1,
                tDay: 24,
                tHour: 12,
                tMin: 0)
        do {
            let path = Bundle.main.path(forResource: "data", ofType: "json")
            var jsonData = try! String(contentsOfFile: path!).data(using: .utf8)!
            decode = try JSONDecoder().decode(Chart.self, from: jsonData)
        } catch {
            print("Unable to open chart file")
        }
        return decode
    }

    struct Bodie {
        var bodie: Bodies
        var calculUt: Swe03.CalcUt
        var phenoUt: Swe07.PhenoUt
    }

    enum Bodies: Int32 {
        case eclNut = -1,
             sun = 0,
             moon = 1,
             mercury = 2,
             venus = 3,
             mars = 4,
             jupiter = 5,
             saturn = 6,
             uranus = 7,
             neptune = 8,
             pluto = 9,
             meanNode = 10,
             trueNode = 11,
             meanApog = 12,
             oscuApog = 13,
             earth = 14,
             chiron = 15,
             pholus = 16,
             ceres = 17,
             pallas = 18,
             juno = 19,
             vesta = 20,
             intpApog = 21,
             intpPerg = 22,
             nPlanets = 23,
             southNode = 24,
             fortunaPart = 25,
             // SE_FICT_OFFSET = 40,
             // SE_NFICT_ELEM = 15,
             // SE_AST_OFFSET = 10000,
             /* Hamburger or Uranian "planets" */
             cupido = 40,
             hades = 41,
             zeus = 42,
             kronos = 43,
             apollon = 44,
             admetos = 45,
             vulkanus = 46,
             poseidon = 47,
             /* other fictitious bodies */
             isis = 48,
             nibiru = 49,
             harrington = 50,
             neptuneLeverrier = 51,
             neptuneAdams = 52,
             plutoLowell = 53,
             plutoPickering = 54,
             /* Asteroid */
             asteroidAstera = 10005,
             asteroidHebe = 10006,
             asteroidIris = 10007,
             asteroidFlora = 10008,
             asteroidMetis = 10009,
             asteroidHygiea = 10010,
             asteroidUrania = 10030,
             asteroidIsis = 10042,
             asteroidHilda = 10153,
             asteroidPhilosophia = 10227,
             asteroidSophia = 10251,
             asteroidAletheia = 10259,
             asteroidSapientia = 10275,
             asteroidThule = 10279,
             asteroidUrsula = 10375,
             asteroidEros = 10433,
             asteroidCupido = 10763,
             asteroidHidalgo = 10944,
             asteroidLilith = 11181,
             asteroidAmor = 11221,
             asteroidKama = 11387,
             asteroidAphrodite = 11388,
             asteroidApollo = 11862,
             asteroidDamocles = 13553,
             asteroidCruithne = 13753,
             asteroidPoseidon = 14341,
             asteroidVulcano = 14464,
             asteroidZeus = 15731,
             asteroidNessus = 17066
    }

// Zodiac
    enum Signs: Int32 {
        case aries = 1,
             taurus = 2,
             gemini = 3,
             cancer = 4,
             leo = 5,
             virgo = 6,
             libra = 7,
             scorpio = 8,
             sagittarius = 9,
             capricorn = 10,
             aquarius = 11,
             pisces = 12
    }

// Angle
    enum Angle: Int32 {
        case nothing = 0,
             asc = 1,
             fc = 2,
             desc = 3,
             mc = 4
    }

// Type of calandar
    enum Calandar: Int32 {
        case julian = 0, gregorian = 1
    }

    enum OptionalFlag: Int32 {
        case jplEph = 1,
             swissEph = 2,
             moshier = 4,
             heliocentric = 8,
             truePosition = 16,
             j2000Equinox = 32,
             noNutation = 64,
             speed3 = 128,
             speed = 256,
             noGravitanionalDeflection = 512,
             noAnnualAberration = 1024,
             astronomicPosition = 1536,
             // AstronomicPosition = OptionalFlag::NoAnnualAberration
             //     | OptionalFlag::NoGravitanionalDeflection,
             equatorialPosition = 2048,
             xYZCartesianNotPolarCoordinate = 4096,
             radians = 8192,
             barycentricPosition = 16384,
             topocentricPosition = 32768,
             sideralPosition = 65536,
             iCRS = 131072,
             dpsideps1980 = 262144,
             jplHorApprox = 524288
    }

}

/*
To convert from String to UnsafeMutablePointer<Int8>
let cString = strdup("Hello") // UnsafeMutablePointer<Int8>

func ptrFromAddress<T>(p: UnsafeMutablePointer<T>) -> UnsafeMutablePointer<T> {
    return p
}

func makeCString(from str: String) -> UnsafeMutablePointer<Int8> {
    let count = str.utf8CString.count
    let result: UnsafeMutableBufferPointer<Int8> = UnsafeMutableBufferPointer<Int8>.allocate(capacity: count)
    // func initialize<S>(from: S) -> (S.Iterator, UnsafeMutableBufferPointer<Element>.Index)
    _ = result.initialize(from: str.utf8CString)
    return result.baseAddress!
}
*/