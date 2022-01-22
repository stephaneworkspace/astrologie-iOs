//
//  Swe.swift
//  astrology_macos
//
//  Created by Stéphane on 16.01.22.
//

import Foundation
import SwiftUI

class Swe {
    var bodies: [(Bodie, Bodie)] = []
    var houses: [Swe14.House] = []
    var aspectsBodies: [AspectBodie] = []
    init(chart: Chart) {
        // Load json or default
        // let chart = load_default_value()

        // Set path
        let swe02 = Swe02()
        swe02.set_ephe_path()
        // let path = swe02.get_library_path()

        // Compute julian day
        let swe08: Swe08 = Swe08()
        var utcTimeZone = TimeZone(
                year: chart.nYear,
                month: chart.nMonth,
                day: chart.nDay,
                hour: chart.nHour,
                min: chart.nMin,
                sec: 0.0)
        utcTimeZone.utc_time_zone(timezone: 2.0)
        let utcToJd = swe08.utc_to_jd(tz: utcTimeZone, calandar: .gregorian)
        // Transit
        var utcTimeZoneTransit = TimeZone(
                year: chart.tYear,
                month: chart.tMonth,
                day: chart.tDay,
                hour: chart.tHour,
                min: chart.tMin,
                sec: 0.0)
        utcTimeZoneTransit.utc_time_zone(timezone: 2.0)
        let utcToJdTransit = swe08.utc_to_jd(tz: utcTimeZoneTransit, calandar: .gregorian)

        // Computes houses
        let swe14 = Swe14()
        houses = swe14.houses(
                tjdUt: utcToJd.julianDayUt,
                geoLat: chart.nLat,
                geoLong: chart.nLng,
                hsys: CChar("W") ?? CChar.init())
        // let julday = swe08.julday(year: chart.nYear, month: chart.nMonth, day: chart.nDay, hour: Double(chart.nHour), calandar: .gregorian)

        // Compute bodies
        let swe03 = Swe03()
        let swe07 = Swe07()
        var bbb: [Bodies] = []
        bbb.append(.sun)
        bbb.append(.moon)
        bbb.append(.mercury)
        bbb.append(.venus)
        bbb.append(.mars)
        bbb.append(.jupiter)
        bbb.append(.saturn)
        bbb.append(.uranus)
        bbb.append(.neptune)
       // bbb.append(.pluto)
        //bbb.append(.ceres)
        for bbx in bbb {
            bodies.append(
                    (
                            Swe.Bodie.init(
                                    bodie: bbx,
                                    calculUt: swe03.calc_ut(
                                            tjdUt: utcToJd.julianDayUt,
                                            ipl: bbx, iflag: .speed),
                                    phenoUt: swe07.pheno_ut(
                                            tjdUt: utcToJd.julianDayUt,
                                    ipl: bbx,
                                    iFlag: .speed)),
                            Swe.Bodie.init(
                                    bodie: bbx,
                                    calculUt: swe03.calc_ut(
                                            tjdUt: utcToJdTransit.julianDayUt,
                                            ipl: bbx,
                                            iflag: .speed),
                                    phenoUt: swe07.pheno_ut(
                                            tjdUt: utcToJdTransit.julianDayUt,
                                            ipl: bbx,
                                            iFlag: .speed))
                    )
            )
        }
        let cD = ChartDraw(swe: self)
        for aspectIdx in 0...8 { // TODO const
            // TODO transit
            // TODO angle AC MC
            for bod in bodies {
                let bodNatalLongitude = cD.getBodieLongitude(bodie: bod.0, swTransit: false)
                for bodPair in bodies.reversed() {
                    /*if bodPair.0.bodie == bod.0.bodie {
                        break
                    }*/
                    let bod2NatalLongitude = cD.getBodieLongitude(bodie: bodPair.0, swTransit: false)
                    let separation = cD.getClosestDistance(
                            angle1: bodNatalLongitude,
                            angle2: bod2NatalLongitude)
                    let absSeparation = abs(separation)
                    let aspect = Aspects.init(rawValue: Int32(aspectIdx)) ?? Aspects.conjunction
                    let asp = aspect.angle().0
                    let orb = aspect.angle().1
                    if abs(absSeparation - Double(asp)) <= Double(orb) {
                        aspectsBodies.append(AspectBodie(id: UUID(), bodie1: bod.0, bodie2: bodPair.0, aspect: aspect))
                    }
                }
            }
        }
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

    enum Aspects: Int32 {
        case conjunction = 0,
             opposition = 1,
             trine = 2,
             square = 3,
             sextile = 4,
             inconjunction = 5,
             sequisquare = 6,
             semisquare =  7,
             semisextile = 8
    }

    struct AspectBodie: Hashable {
        static func ==(lhs: Swe.AspectBodie, rhs: Swe.AspectBodie) -> Bool {
            lhs.id == rhs.id
        }

        var id: UUID?
        var bodie1: Bodie
        var bodie2: Bodie
        var aspect: Aspects

        func hash(into hasher: inout Hasher) {

        }
    }
}

extension Swe.Aspects {
    // Return property (angle, orbe)
    func angle() -> (Int32, Int32) {
        switch self {
        case .conjunction:
            return (0, 10)
        case .opposition:
            return (180, 8)
        case .trine:
            return (120, 7)
        case .square:
            return (90, 6)
        case .sextile:
            return (60, 5)
        case .inconjunction:
            return (150, 2)
        case .sequisquare:
            return (135, 1)
        case .semisquare:
            return (45, 1)
        case .semisextile:
            return (30, 1)
        }
    }

    // Return if maj
    func maj() -> Bool {
        switch self {
        case .conjunction:
            return true
        case .opposition:
            return true
        case .trine:
            return true
        case .square:
            return true
        case .sextile:
            return true
        default:
            return false
        }
    }

    // Return text
    func text() -> String {
        switch self {
        case .conjunction:
            return "Conjonction"
        case .opposition:
            return "Opposition"
        case .trine:
            return "Trigone"
        case .square:
            return "Quadrature"
        case .sextile:
            return "Sextile"
        case .inconjunction:
            return "Quinconce"
        case .sequisquare:
            return "Sesqui-carré"
        case .semisquare:
            return "Demi-carré"
        case .semisextile:
            return "Demi-sextile"
        }
    }

    // Return color
    func color() -> Color {
        switch self {
        case .conjunction:
            return .red
        case .opposition:
            return .red
        case .trine:
            return .blue
        case .square:
            return .red
        case .sextile:
            return .blue
        case .inconjunction:
            return .green
        case .sequisquare:
            return .indigo
        case .semisquare:
            return .indigo
        case .semisextile:
            return .green
        }
    }

    // Return color
    func style() -> StrokeStyle {
        var stroke = StrokeStyle.init(lineWidth: 0.5)
        switch self {
        case .sequisquare:
            stroke.dash = [7]
        case .semisquare:
            stroke.dash = [7]
        case .semisextile:
            stroke.dash = [7]
        default:
            return stroke
        }
        return stroke
    }
}