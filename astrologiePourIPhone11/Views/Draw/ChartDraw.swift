//
// Created by Stéphane on 19.01.22.
//

import Foundation
import SwiftUI

struct ChartDraw {
    let swe: Swe
    let size = 130
    let mult = 3
    let SIZE = 390.0
    let b = 1.0
    let ZODIAC_RATIO = 10.0
    let ZODIAC_SIZE = 50.0
    let BODIE_SIZE = 35.0
    let ANGLE_SIZE = 50.0
    let HOUSE_SIZE = 40.0
    let DEG_SIZE = 50.0
    let MIN_SIZE = 50.0
    let CIRCLE = 360.0
    let RETOGRADE_DIV = 1.5
    let CIRCLE_SIZE_NATAL: [(Double, Bool)] = [
        (35.0, true), // 0
        (62.0, true), // 1
        (67.0, true), // 2
        (77.0, false), // 3
        (80.0, false), // 4
        (89.0, false), // 5
        (96.0, false), // 6
        (69.0, false), // 7 between 2 and 3
        (71.0, false), // 8 correction planet between 2 and 3
    ]
    let CIRCLE_SIZE_TRANSIT: [(Double, Bool)] = [
        (42.0, true), // 0 CIRCLE ASPECT
        (59.0, true), // 1 CIRCLE TRANSIT
        (75.0, true), // 2 CIRCLE ZODIAC END
        (80.0, true), // 3 CIRCLE HOUSE
        (92.0, false), // 4 CIRCLE INVISIBLE -
        (92.0, false), // 5 CIRCLE INVISIBLE PLANET
        //    (0.0, false), // 5
        (0.0, false), // 6
        (82.0, false), // 7 between 2 and 3
        (85.0, false), // 8 correction planet between 2 and 3
        (49.0, false), // 9 Planet pos transit
        (57.5, false), // 10 - 7 transit
        (54.5, false), // 11 - 8 transit
    ]

    let LARGER_DRAW_LINE_RULES_SMALL = 0.1
    let LARGER_DRAW_LINE_RULES_LARGE = 0.2

    //var chart: Swe.Chart

    func getFixedPos(pos_value: Double) -> Double {
        var pos = pos_value
        var done = false
        while !done {
            if pos >= 360.0 {
                pos = pos - 360.0
            }
            if pos >= 360 {

            } else {
                done = true
            }
        }
        return pos
    }

    struct Offset {
        var offX: Double
        var offY: Double
    }

    func getCenterItem(size: Double, offset: Offset) -> Offset {
        Offset(
                offX: offset.offX - (size / 2.0),
                offY: offset.offY - (size / 2.0))
    }

    func getBodieLongitude(bodie: Swe.Bodie, swTransit: Bool) -> Double {
        var pos = 0.0
        if swTransit {
            pos = CIRCLE - swe.houses[0].longitude + bodie.calculUt.longitude // TODO
        } else {
            pos = CIRCLE - swe.houses[0].longitude + bodie.calculUt.longitude
        }
        pos = getFixedPos(pos_value: pos)
        return pos
    }

    func getPosTrigo(angular: Double, radiusCircle: Double) -> Offset {
        let getCenter = getRadiusTotal()
        return Offset(
                offX: getCenter + cos(angular / CIRCLE * 2.0 * Double.pi) * -1.0 * radiusCircle,
                offY: getCenter + sin(angular / CIRCLE * 2.0 * Double.pi) * radiusCircle)
    }

    func getRadiusCircleHouse() -> Double {
        (getRadiusTotal() * (((
                (CIRCLE_SIZE_TRANSIT[3].0 - CIRCLE_SIZE_TRANSIT[2].0) / 2.0))
                + CIRCLE_SIZE_TRANSIT[2].0))
                / 100.0
    }

    func getRadiusCircleZodiac() -> Double {
        let divTraitBig = 0.2
        return (getRadiusTotal() * (
                (
                        (CIRCLE_SIZE_TRANSIT[2].0 - CIRCLE_SIZE_TRANSIT[1].0)
                                / (2.0 + divTraitBig)
                ) + CIRCLE_SIZE_TRANSIT[1].0))
                / 100.0
    }

    func getRadiusTotal() -> Double {
        SIZE / 2.0
    }

    struct Object {
        var sign: Swe.Signs
        var oSx: Double
        var oSy: Double
        var oPx: Double
        var oPy: Double
    }

    struct ObjectBodie {
        var swRetrograde: Bool
        var oSx: Double
        var oSy: Double
        var oPx: Double
        var oPy: Double
    }

    struct ObjectHouse {
        var oSx: Double
        var oSy: Double
        var oPx: Double
        var oPy: Double
    }

    struct ObjectAngle {
        var svg: String
        var oSx: Double
        var oSy: Double
        var oPx: Double
        var oPy: Double
    }

    struct Line {
        var lX1: Double
        var lY1: Double
        var lX2: Double
        var lY2: Double
    }

    struct HouseLine {
        var lX1: Double
        var lY1: Double
        var lX2: Double
        var lY2: Double
        var lXY3: Bool
        var lX3: Double
        var lY3: Double
    }

    struct AspectLine {
        var aspect: Swe.Aspects
        var lX1: Double
        var lY1: Double
        var lX2: Double
        var lY2: Double
    }

    struct Circle {
        var center: Double
        var radius: Double
    }

    struct LineShape: Shape {
        var obj: Object
        let center = 300.0 // TODO 300.0

        func path(in rect: CGRect) -> Path {
            print(obj)
            var path = Path()
            path.move(to: CGPoint(x: center + obj.oPx, y: center + obj.oPy))
            path.addLine(to: CGPoint(x: obj.oSx, y: obj.oSy))
            path.closeSubpath()
            return path
        }
    }

    struct LineShape2: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            path.move(to: CGPoint(x: 0, y: 0))
            path.addLine(to: CGPoint(x: -100, y: -100))
            return path
        }
    }

    func drawLine(lines: [Line]) -> Path {
        var path = Path()
        for line in lines {
            path.move(to: CGPoint(x: line.lX1, y: line.lY1))
            path.addLine(to: CGPoint(x: line.lX2, y: line.lY2))
            path.closeSubpath()
        }
        return path
    }

    struct DrawHouseTriangle: Shape {
        var lines: [HouseLine]

        func path(in rect: CGRect) -> Path {
            var path = Path()
            for line in lines {
                if line.lXY3 {
                    path.move(to: CGPoint(x: line.lX3, y: line.lY3))
                    path.addLine(to: CGPoint(x: line.lX1, y: line.lY1))
                    path.addLine(to: CGPoint(x: line.lX2, y: line.lY2))
                    path.addLine(to: CGPoint(x: line.lX3, y: line.lY3))
                    path.closeSubpath()
                } /*else {
                    path.move(to: CGPoint(x: line.lX1, y: line.lY1))
                    path.addLine(to: CGPoint(x: line.lX2, y: line.lY2))
                    path.closeSubpath()
                }*/
            }
            return path
        }
    }

    struct DrawTransit: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            let size = 390 // TODO SIZE don't work
            let cas = Double(size) / 16
            let max = 8
            path.move(to: CGPoint(x: 0, y: cas))
            path.addLine(to: CGPoint(x: 0, y: Double(max + 1) * cas))
            for iDx in 1...max {
                let idx = Double(iDx)
                path.move(to: CGPoint(x: idx * cas, y: idx * cas))
                path.addLine(to: CGPoint(x: idx * cas, y: (idx + 1) * cas))
                path.move(to: CGPoint(x: idx * cas, y: idx * cas))
                path.addLine(to: CGPoint(x: 0, y: idx * cas))
                path.move(to: CGPoint(x: idx * cas, y: (idx + 1) * cas))
                path.addLine(to: CGPoint(x: 0, y: (idx + 1) * cas))
                path.move(to: CGPoint(x: idx * cas, y: (idx + 1) * cas))
                path.addLine(to: CGPoint(x: idx * cas, y: Double(max + 1) * cas))
            }
            return path
        }
    }

    func drawTransitBodie(idx: Int) -> some View {
        let size = 390 // TODO SIZE don't work
        let bodPos = CGFloat((size / 2) * -1)
        let cas = Double(size) / 16.0
        let casDiv = 1.1
        let xPos = bodPos + (cas / 2) + (cas * Double(idx))
        let yPos = bodPos + (cas / 2) + (cas * Double(idx))
        var body: some View {
            Image("b" + idx.formatted())
                    .resizable()
                    .foregroundColor(.red)
                    .offset(
                            x: xPos,
                            y: yPos)
                    .frame(
                            width: cas / casDiv,
                            height: cas / casDiv)
        }
        return body
    }

    func drawTransitAspect(idx: Int, asp: Swe.AspectBodie) -> some View {
        let size = 390 // TODO SIZE don't work
        let bodPos = CGFloat((size / 2) * -1)
        let cas = Double(size) / 16.0
        let casDiv = 1.1
        var body: some View {
            ForEach(0...idx, id: \.self) { jdx in
                if asp.bodie1.bodie.rawValue == idx && asp.bodie2.bodie.rawValue == jdx {
                    let xPos = bodPos + (cas / 2) + (cas * Double(jdx))
                    let yPos = bodPos + (cas / 2) + (cas * Double(idx + 1))
                    Image("a" + asp.aspect.rawValue.formatted())
                            .resizable()
                            .foregroundColor(.red)
                            .offset(
                                    x: xPos,
                                    y: yPos)
                            .frame(
                                    width: cas / casDiv,
                                    height: cas / casDiv)
                }
            }
        }
        return body
    }

    func drawBodieLine(lines: [Line]) -> Path {
        var path = Path()
        for line in lines {
            path.move(to: CGPoint(x: line.lX1, y: line.lY1))
            path.addLine(to: CGPoint(x: line.lX2, y: line.lY2))
            path.closeSubpath()
        }
        return path
    }

    func drawHouseLine(lines: [HouseLine]) -> Path {
        var path = Path()
        for line in lines {
            if line.lXY3 {
                /* path.move(to: CGPoint(x: line.lX3, y: line.lY3))
                path.addLine(to: CGPoint(x: line.lX1, y: line.lY1))
                path.addLine(to: CGPoint(x: line.lX2, y: line.lY2))
                path.addLine(to: CGPoint(x: line.lX3, y: line.lY3))
                path.closeSubpath()*/
            } else {
                path.move(to: CGPoint(x: line.lX1, y: line.lY1))
                path.addLine(to: CGPoint(x: line.lX2, y: line.lY2))
                path.closeSubpath()
            }
        }
        return path
    }

    struct DrawAspectLines: Shape {
        var lines: [AspectLine]

        func path(in rect: CGRect) -> Path {
            var path = Path()
            for line in lines {
                path.move(to: CGPoint(x: line.lX1, y: line.lY1))
                path.addLine(to: CGPoint(x: line.lX2, y: line.lY2))
                path.closeSubpath()
            }
            return path
        }
    }

    func drawAngleLine(lines: [Line]) -> Path {
        var path = Path()
        for line in lines {
            path.move(to: CGPoint(x: line.lX1, y: line.lY1))
            path.addLine(to: CGPoint(x: line.lX2, y: line.lY2))
            path.closeSubpath()
        }
        return path
    }

    func drawCircle(circles: [Circle]) -> Path {
        var path = Path()
        for circle in circles.reversed() {
            path.move(to: CGPoint(x: circle.center + circle.radius, y: circle.center))
            path.addArc(
                    center: CGPoint(
                            x: circle.center,
                            y: circle.center),
                    radius: circle.radius,
                    startAngle: .zero,
                    endAngle: .degrees(360.0),
                    clockwise: false)
            path.closeSubpath()
        }
        return path
    }

    func getCenter() -> Offset {
        Offset(offX: getRadiusTotal(), offY: getRadiusTotal())
    }

    func getLineTrigo(angular: Double, radiusCircleBegin: Double, radiusCircleEnd: Double) -> [Offset] {
        var res: [Offset] = []
        let dx1: Double = getCenter().offX
                + cos(angular / CIRCLE * 2.0 * Double.pi)
                * -1.0
                * radiusCircleBegin
        let dx2: Double = getCenter().offY
                + sin(angular / CIRCLE * 2.0 * Double.pi)
                * radiusCircleBegin
        let dy1: Double = getCenter().offX
                + cos(angular / CIRCLE * 2.0 * Double.pi)
                * -1.0
                * radiusCircleEnd
        let dy2: Double = getCenter().offY
                + sin(angular / CIRCLE * 2.0 * Double.pi)
                * radiusCircleEnd
        res.append(Offset(offX: dx1, offY: dx2))
        res.append(Offset(offX: dy1, offY: dy2))
        return res
    }

    func getTriangleTrigo(angular: Double, angularPointer: Double, radiusCircleBegin: Double, radiusCircleEnd: Double) -> [Offset] {
        var res: [Offset] = []
        let angular1 = getFixedPos(pos_value: angular - angularPointer)
        let angular2 = getFixedPos(pos_value: angular + angularPointer)
        let dx1: Double = getCenter().offX
                + cos(angular1 / CIRCLE * 2.0 * Double.pi)
                * -1.0
                * radiusCircleBegin
        let dy1: Double = getCenter().offY
                + sin(angular1 / CIRCLE * 2.0 * Double.pi)
                * radiusCircleBegin
        let dx2: Double = getCenter().offX
                + cos(angular2 / CIRCLE * 2.0 * Double.pi)
                * -1.0
                * radiusCircleBegin
        let dy2: Double = getCenter().offY
                + sin(angular2 / CIRCLE * 2.0 * Double.pi)
                * radiusCircleBegin
        let dx3: Double = getCenter().offX
                + cos(angular / CIRCLE * 2.0 * Double.pi)
                * -1.0
                * radiusCircleEnd
        let dy3: Double = getCenter().offY
                + sin(angular / CIRCLE * 2.0 * Double.pi)
                * radiusCircleEnd
        res.append(Offset(offX: dx1, offY: dy1))
        res.append(Offset(offX: dx2, offY: dy2))
        res.append(Offset(offX: dx3, offY: dy3))
        return res
    }

    func getRadiusCircle(occurs: Int) -> (Double, Bool) {
        /* TODO if occurs > CIRCLE_SIZE_TRANSIT.len() {
            exception("out of range in circle occurs")
        }*/
        let res = getRadiusTotal() * CIRCLE_SIZE_TRANSIT[occurs].0 / 100
        return (res, CIRCLE_SIZE_TRANSIT[occurs].1)
    }

    func getRadiusInsideCircleHouseForPointerBottom() -> Double {
        let divTraitPointer = 1.5 // TODO CONST
        return (getRadiusTotal() * (((CIRCLE_SIZE_TRANSIT[3].0 - CIRCLE_SIZE_TRANSIT[2].0)
                / divTraitPointer)
                - CIRCLE_SIZE_TRANSIT[3].0)) / 100.0
    }

    func getRadiusInsideCircleHouseForPointerTop() -> Double {
        (getRadiusTotal() * ((CIRCLE_SIZE_TRANSIT[3].0 - CIRCLE_SIZE_TRANSIT[2].0)
                - CIRCLE_SIZE_TRANSIT[3].0)) / 100.0
    }

    func getRadiusRulesInsideCircle(largerDrawLine: LargerDrawLine) -> Double {
        var size = 0.0
        switch largerDrawLine {
        case .small:
            size = 1.0 + LARGER_DRAW_LINE_RULES_SMALL
        case .large:
            size = 1.0 + LARGER_DRAW_LINE_RULES_LARGE
        }
        return getRadiusTotal() * (((CIRCLE_SIZE_TRANSIT[2].0 - CIRCLE_SIZE_TRANSIT[1].0) / size)
                + CIRCLE_SIZE_TRANSIT[1].0) / 100.0
    }

    func getAngleLongitude(angle: Swe.Angle) -> Double {
        var pos = 0.0
        for house in swe.houses {
            if house.angle == angle {
                pos = CIRCLE - swe.houses[0].longitude + house.longitude
                break
            }
        }
        pos = getFixedPos(pos_value: pos)
        return pos
    }

    func getClosestDistance(angle1: Double, angle2: Double) -> Double {
        getZnorm(angle: angle2 - angle1)
    }

    func getZnorm(angle: Double) -> Double {
        let ang = Int(angle) % Int(SIZE)
        if Double(ang) <= (SIZE / 2) {
            return Double(ang)
        } else {
            return Double(ang) - SIZE
        }
    }

    enum LargerDrawLine {
        case large, small
    }

    func circles(swe: Swe) -> [Circle] {
        var res: [Circle] = []
        let center = getRadiusTotal()
        for (idx, circleSize) in CIRCLE_SIZE_TRANSIT.enumerated() {
            if circleSize.1 {
                let radius = getRadiusCircle(occurs: idx).0
                res.append(Circle(center: center, radius: radius))
            }
        }
        return res
    }

    func angle_lines(swe: Swe) -> [Line] {
        var res: [Line] = []
        //
        var angle: Swe.Angle = .asc
        var pos = getAngleLongitude(angle: angle)
        var axyLine: [Offset] = getLineTrigo(
                angular: pos,
                radiusCircleBegin: getRadiusCircle(occurs: 2).0,
                radiusCircleEnd: getRadiusCircle(occurs: 8).0)
        res.append(Line(
                lX1: axyLine[0].offX,
                lY1: axyLine[0].offY,
                lX2: axyLine[1].offX,
                lY2: axyLine[1].offY))
        //
        angle = .fc
        pos = getAngleLongitude(angle: angle)
        axyLine = getLineTrigo(
                angular: pos,
                radiusCircleBegin: getRadiusCircle(occurs: 2).0,
                radiusCircleEnd: getRadiusCircle(occurs: 8).0)
        res.append(Line(
                lX1: axyLine[0].offX,
                lY1: axyLine[0].offY,
                lX2: axyLine[1].offX,
                lY2: axyLine[1].offY))
        //
        angle = .desc
        pos = getAngleLongitude(angle: angle)
        axyLine = getLineTrigo(
                angular: pos,
                radiusCircleBegin: getRadiusCircle(occurs: 2).0,
                radiusCircleEnd: getRadiusCircle(occurs: 8).0)
        res.append(Line(
                lX1: axyLine[0].offX,
                lY1: axyLine[0].offY,
                lX2: axyLine[1].offX,
                lY2: axyLine[1].offY))
        //
        angle = .mc
        pos = getAngleLongitude(angle: angle)
        axyLine = getLineTrigo(
                angular: pos,
                radiusCircleBegin: getRadiusCircle(occurs: 2).0,
                radiusCircleEnd: getRadiusCircle(occurs: 8).0)
        res.append(Line(
                    lX1: axyLine[0].offX,
                    lY1: axyLine[0].offY,
                    lX2: axyLine[1].offX,
                    lY2: axyLine[1].offY))
        return res
    }

    func house_lines(swe: Swe) -> [HouseLine] {
        var res: [HouseLine] = []
        for iIdx in 0...11 {
            let offHouse = 360.0 - swe.houses[0].longitude
            let pos = getFixedPos(pos_value: offHouse + swe.houses[iIdx].longitude)
            var axyTriangle: [Offset] = []
            let angularPointer = -1.0 // TODO CONST
            if swe.houses[iIdx].angle == Swe.Angle.nothing {
                axyTriangle = getTriangleTrigo(
                        angular: pos,
                        angularPointer: angularPointer,
                        radiusCircleBegin: getRadiusInsideCircleHouseForPointerBottom(),
                        radiusCircleEnd: getRadiusInsideCircleHouseForPointerTop())
                let axyLine: [Offset] = getLineTrigo(
                        angular: pos,
                        radiusCircleBegin: getRadiusCircle(occurs: 3).0,
                        radiusCircleEnd: getRadiusCircle(occurs: 2).0)
                res.append(HouseLine(
                        lX1: axyLine[0].offX,
                        lY1: axyLine[0].offY,
                        lX2: axyLine[1].offX,
                        lY2: axyLine[1].offY,
                        lXY3: false,
                        lX3: 0.0,
                        lY3: 0.0)
                )
            } else {
                axyTriangle = getTriangleTrigo(
                        angular: pos,
                        angularPointer: angularPointer,
                        radiusCircleBegin: getRadiusCircle(occurs: 3).0,
                        radiusCircleEnd: getRadiusCircle(occurs: 2).0)
            }
            res.append(HouseLine(
                    lX1: axyTriangle[0].offX,
                    lY1: axyTriangle[0].offY,
                    lX2: axyTriangle[1].offX,
                    lY2: axyTriangle[1].offY,
                    lXY3: true,
                    lX3: axyTriangle[2].offX,
                    lY3: axyTriangle[2].offY)
            )
        }
        return res
    }

    enum AspectType: Int {
        case natal = 0, transit = 1, natalAndTransit = 2
    }

    func aspect_lines(swe: Swe, aspect: Swe.Aspects, aspectType: AspectType) -> [AspectLine] {
        var res: [AspectLine] = []
        for bod in swe.bodies {
            let bodNatalLongitude = getBodieLongitude(bodie: bod.0, swTransit: false)
            let bodTransitLongitude = getBodieLongitude(bodie: bod.0, swTransit: true)
            switch aspectType {
            case .natalAndTransit:
                let separation = getClosestDistance(
                        angle1: bodNatalLongitude,
                        angle2: bodTransitLongitude)
                let absSeparation = abs(separation)
                let asp = aspect.angle().0
                let orb = aspect.angle().1
                if abs(absSeparation - Double(asp)) <= Double(orb) {
                    let pos1: Offset = getPosTrigo(
                            angular: bodNatalLongitude,
                            radiusCircle: getRadiusCircle(occurs: 0).0)
                    let pos2: Offset = getPosTrigo(
                            angular: bodTransitLongitude,
                            radiusCircle: getRadiusCircle(occurs: 0).0)
                    let line: AspectLine = AspectLine(
                            aspect: aspect,
                            lX1: pos1.offX,
                            lY1: pos1.offY,
                            lX2: pos2.offX,
                            lY2: pos2.offY)
                    res.append(line)
                }
            case .natal:
                for bodPair in swe.bodies.reversed() {
                    if bodPair.0.bodie == bod.0.bodie {
                        break
                    }
                    let bod2NatalLongitude = getBodieLongitude(bodie: bodPair.0, swTransit: false)
                    let separation = getClosestDistance(
                            angle1: bodNatalLongitude,
                            angle2: bod2NatalLongitude)
                    let absSeparation = abs(separation)
                    let asp = aspect.angle().0
                    let orb = aspect.angle().1
                    if abs(absSeparation - Double(asp)) <= Double(orb) {
                        let pos1: Offset = getPosTrigo(
                                angular: bodNatalLongitude,
                                radiusCircle: getRadiusCircle(occurs: 0).0)
                        let pos2: Offset = getPosTrigo(
                                angular: bod2NatalLongitude,
                                radiusCircle: getRadiusCircle(occurs: 0).0)
                        let line: AspectLine = AspectLine(
                                aspect: aspect,
                                lX1: pos1.offX,
                                lY1: pos1.offY,
                                lX2: pos2.offX,
                                lY2: pos2.offY)
                        res.append(line)
                    }
                }
            case .transit:
                for bodPair in swe.bodies.reversed() {
                    if bodPair.1.bodie == bod.1.bodie {
                        break
                    }
                    let bod2TransitLongitude = getBodieLongitude(bodie: bodPair.1, swTransit: true)
                    let separation = getClosestDistance(
                            angle1: bodTransitLongitude,
                            angle2: bod2TransitLongitude)
                    let absSeparation = abs(separation)
                    let asp = aspect.angle().0
                    let orb = aspect.angle().1
                    if abs(absSeparation - Double(asp)) <= Double(orb) {
                        let pos1: Offset = getPosTrigo(
                                angular: bodTransitLongitude,
                                radiusCircle: getRadiusCircle(occurs: 0).0)
                        let pos2: Offset = getPosTrigo(
                                angular: bod2TransitLongitude,
                                radiusCircle: getRadiusCircle(occurs: 0).0)
                        let line: AspectLine = AspectLine(
                                aspect: aspect,
                                lX1: pos1.offX,
                                lY1: pos1.offY,
                                lX2: pos2.offX,
                                lY2: pos2.offY)
                        res.append(line)
                    }
                }
            }
        }
        return res
    }

    func bodie_lines(swe: Swe, swTransit: Bool) -> [Line] {
        var res: [Line] = []
        for _ in 1...8 {
            var pos = 0.0
            for bod in swe.bodies {
                var axy: [Offset]
                if swTransit {
                    pos = getBodieLongitude(bodie: bod.1, swTransit: swTransit)
                    axy =
                            getLineTrigo(
                                    angular: pos,
                                    radiusCircleBegin: getRadiusCircle(occurs: 1).0,
                                    radiusCircleEnd: getRadiusCircle(occurs: 10).0)
                    res.append(Line(
                            lX1: axy[0].offX,
                            lY1: axy[0].offY,
                            lX2: axy[1].offX,
                            lY2: axy[1].offY)
                    )
                    // TODO posFix getBodieFixLongitude line 1306 svg_draw.rs}
                    axy = getLineTrigo(
                            angular: pos,
                            radiusCircleBegin: getRadiusCircle(occurs: 10).0,
                            radiusCircleEnd: getRadiusCircle(occurs: 11).0)
                    res.append(Line(
                            lX1: axy[0].offX,
                            lY1: axy[0].offY,
                            lX2: axy[1].offX,
                            lY2: axy[1].offY)
                    )
                } else {
                    pos = getBodieLongitude(bodie: bod.0, swTransit: swTransit)
                    axy =
                            getLineTrigo(
                                    angular: pos,
                                    radiusCircleBegin: getRadiusCircle(occurs: 3).0,
                                    radiusCircleEnd: getRadiusCircle(occurs: 7).0)
                    res.append(Line(
                            lX1: axy[0].offX,
                            lY1: axy[0].offY,
                            lX2: axy[1].offX,
                            lY2: axy[1].offY)
                    )
                    axy = getLineTrigo(
                            angular: pos,
                            radiusCircleBegin: getRadiusCircle(occurs: 7).0,
                            radiusCircleEnd: getRadiusCircle(occurs: 8).0)
                    res.append(Line(
                            lX1: axy[0].offX,
                            lY1: axy[0].offY,
                            lX2: axy[1].offX,
                            lY2: axy[1].offY)
                    )
                }
            }
        }
        return res
    }

    func zodiac_lines(swe: Swe) -> [Line] {
        var res: [Line] = []
        for iIdx in 1...12 {
            // 0°
            let offPosAsc = 360.0 - swe.houses[0].longitude
            var pos = Double(iIdx) * 30.0 + offPosAsc
            pos = getFixedPos(pos_value: pos)
            let axy: [Offset] = getLineTrigo(
                    angular: pos,
                    radiusCircleBegin: getRadiusCircle(occurs: 2).0,
                    radiusCircleEnd: getRadiusCircle(occurs: 1).0)
            res.append(Line(
                    lX1: axy[0].offX,
                    lY1: axy[0].offY,
                    lX2: axy[1].offX,
                    lY2: axy[1].offY)
            )
            // 1° to 29°
            var largerDrawLine: LargerDrawLine = .large
            for jIdx in 1...15 {
                if jIdx == 5 || jIdx == 10 || jIdx == 15 {
                    largerDrawLine = .large
                } else {
                    largerDrawLine = .small
                }
                pos = (Double(iIdx) * 30.0) + Double(jIdx) * 2.0 + offPosAsc
                pos = getFixedPos(pos_value: pos)
                let axy: [Offset] = getLineTrigo(
                        angular: pos,
                        radiusCircleBegin: getRadiusCircle(occurs: 2).0,
                        radiusCircleEnd: getRadiusRulesInsideCircle(largerDrawLine: largerDrawLine))
                res.append(Line(
                        lX1: axy[0].offX,
                        lY1: axy[0].offY,
                        lX2: axy[1].offX,
                        lY2: axy[1].offY)
                )
            }
        }
        return res
    }

    func zodiac_sign(swe: Swe, sign: Int32) -> Object {
        let zodiacSize = (((ZODIAC_SIZE * ZODIAC_RATIO) / 100.0) * SIZE) / 100.0;
        let offPosAsc = CIRCLE - swe.houses[0].longitude
        let signEnum: Swe.Signs = Swe.Signs.init(rawValue: sign) ?? Swe.Signs.aries
        let pos = (Double(signEnum.rawValue - 1) * 30.0) + 15.0 + offPosAsc
        let offset = getCenterItem(
                size: zodiacSize,
                offset: getPosTrigo(
                        angular: pos,
                        radiusCircle: getRadiusCircleZodiac()))
        let res = Object(
                sign: signEnum,
                oSx: zodiacSize,
                oSy: zodiacSize,
                oPx: offset.offX,
                oPy: offset.offY)
        return res
    }

    func angle(swe: Swe, angle: Swe.Angle) -> ObjectAngle {
        let angleRatio = 12.0 // TODO const
        var angleSize = (((ANGLE_SIZE * angleRatio) / 100.0) * SIZE) / 100.0
        let pos = getAngleLongitude(angle: angle)
        let offAngle = getCenterItem(
                size: angleSize,
                offset: getPosTrigo(
                        angular: pos,
                        radiusCircle: getRadiusCircle(occurs: 5).0))
        var posNext: Double
        var svg = "aas"
        switch angle {
        case .asc:
            svg = "aas"
        case .fc:
            svg = "afc"
        case .desc:
            svg = "ads"
        case .mc:
            svg = "amc"
        case .nothing:
            svg = ""
        }
        return ObjectAngle(
                svg: svg,
                oSx: angleSize,
                oSy: angleSize,
                oPx: offAngle.offX,
                oPy: offAngle.offY)
    }

    func house(swe: Swe, number: Int32) -> ObjectHouse {
        let houseRatio = 5.0 // TODO const
        var houseSize = (((HOUSE_SIZE * houseRatio) / 100.0) * SIZE) / 100.0
        let offPosAsc = CIRCLE - swe.houses[0].longitude
        var posNext: Double
        if number > 11 {
            posNext = swe.houses[0].longitude + offPosAsc
        } else {
            posNext = swe.houses[Int(number)].longitude + offPosAsc
        }
        let posNow = swe.houses[Int(number - 1)].longitude + offPosAsc
        var pos: Double
        if posNow > posNext {
            pos = posNow + ((posNext - posNow - CIRCLE) / 2.0)
        } else {
            pos = posNow + ((posNext - posNow) / 2.0)
        }
        pos = getFixedPos(pos_value: pos)
        let offset = getCenterItem(
                size: houseSize,
                offset: getPosTrigo(
                        angular: pos,
                        radiusCircle: getRadiusCircleHouse()))
        if number > 9 {
            return ObjectHouse(
                    oSx: houseSize,
                    oSy: houseSize,
                    oPx: offset.offX,
                    oPy: offset.offY)
        } else {
            return ObjectHouse(
                    oSx: houseSize / 1.5,
                    oSy: houseSize,
                    oPx: offset.offX,
                    oPy: offset.offY)

        }
    }

    func bodie(swe: Swe, bodie: Int32, swTransit: Bool) -> ObjectBodie {
        var planetRatio: Double
        if swTransit {
            planetRatio = 6.0 // TODO const
        } else {
            planetRatio = 12.0 // TODO const
        }
        let planetSize = (((BODIE_SIZE * ZODIAC_RATIO) / 100.0) * SIZE) / 100.0;
        let degRatio = 6.0 // TODO const
        let degSize = (((DEG_SIZE * degRatio) / 100.0) * SIZE)
        let minRatio = 6.0 // TODO const
        let minSize = (((MIN_SIZE * degRatio) / 100.0) * SIZE)
        var swRetrograde = false
        for bod in swe.bodies {
            if bod.1.bodie.rawValue == bodie {
                if swTransit {
                    if abs(bod.1.calculUt.speedLongitude) < 0.0003 {
                        // Stationary
                    } else if bod.1.calculUt.speedLongitude > 0.0 {
                        // Direct
                    } else {
                        swRetrograde = true
                    }
                } else {
                    if !swTransit {
                        if abs(bod.0.calculUt.speedLongitude) < 0.0003 {
                            // Stationary
                        } else if bod.0.calculUt.speedLongitude > 0.0 {
                            // Direct
                        } else {
                            swRetrograde = true
                        }
                    }
                }
            }
        }
            var pos = 0.0
            for bod in swe.bodies {
                if bod.1.bodie.rawValue == bodie {
                    if swTransit {
                        pos = getBodieLongitude(bodie: bod.1, swTransit: swTransit)
                    }
                    // TODO posFix getBodieFixLongitude line 1306 svg_draw.rs
                }
                if bod.0.bodie.rawValue == bodie {
                    if !swTransit {
                        pos = getBodieLongitude(bodie: bod.0, swTransit: swTransit)
                    }
                    // TODO posFix getBodieFixLongitude line 1306 svg_draw.rs
                }
            }
            let offset: Offset
            if swTransit {
                offset = getCenterItem(
                        size: planetSize,
                        offset: getPosTrigo(
                                angular: pos,
                                radiusCircle: getRadiusCircle(occurs: 9).0))
            } else {
                offset = getCenterItem(
                        size: planetSize,
                        offset: getPosTrigo(
                                angular: pos,
                                radiusCircle: getRadiusCircle(occurs: 5).0))
            }
            // TODO deg min line 1336 sw_draw.rs
            let res = ObjectBodie(
                    swRetrograde: swRetrograde,
                    oSx: planetSize,
                    oSy: planetSize,
                    oPx: offset.offX,
                    oPy: offset.offY)
            return res
    }
}
