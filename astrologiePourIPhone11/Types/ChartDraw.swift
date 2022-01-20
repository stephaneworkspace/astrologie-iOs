//
// Created by Stéphane on 19.01.22.
//

import Foundation
import SwiftUI

struct ChartDraw {
    let size = 130
    let mult = 3
    let SIZE = 390.0
    let b = 1.0
    let ZODIAC_RATIO = 10.0
    let ZODIAC_SIZE = 50.0
    let CIRCLE = 360.0
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
        (45.0, true), // 0 CIRCLE ASPECT
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

    let swe = Swe()

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

    func getPosTrigo(angular: Double, radiusCircle: Double) -> Offset {
        let getCenter = getRadiusTotal()
        return Offset(
                offX: getCenter + cos(angular / CIRCLE * 2.0 * Double.pi) * -1.0 * radiusCircle,
                offY: getCenter + sin(angular / CIRCLE * 2.0 * Double.pi) * radiusCircle)
    }

    func getRadiusCircleZodiac() -> Double {
        let divTraitBig = 0.2
        return (getRadiusTotal() * (
                        (
                                (CIRCLE_SIZE_NATAL[1].0 - CIRCLE_SIZE_NATAL[0].0)
                                / (2.0 + divTraitBig)
                        ) + CIRCLE_SIZE_NATAL[0].0))
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

    func drawHouseLine(lines: [HouseLine]) -> Path {
        var path = Path()
        for line in lines {
            if line.lXY3 {
                print(line)
                path.move(to: CGPoint(x: line.lX3, y: line.lY3))
                path.addLine(to: CGPoint(x: line.lX1, y: line.lY1))
                path.addLine(to: CGPoint(x: line.lX2, y: line.lY2))
                path.addLine(to: CGPoint(x: line.lX3, y: line.lY3))
            } else {
                path.move(to: CGPoint(x: line.lX1, y: line.lY1))
                path.addLine(to: CGPoint(x: line.lX2, y: line.lY2))
                path.closeSubpath()
            }
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
                + cos(angular / CIRCLE  * 2.0 * Double.pi)
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
                } else
                {
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

    func drawZodiacSvg(object: Object) -> some View {
        //print(object)
        switch object.sign.rawValue {
        case 1:
            return VStack {
                GeometryReader { geometry in
                    Image("zod01").resizable()
                            .resizable()
                            .position(x: object.oPx + object.oSx, y: object.oPy + object.oSy)
                            .frame(width: object.oSx, height: object.oSy)
                }
            }
        case 2:
            return VStack {
                GeometryReader { geometry in
                    Image("zod02").resizable()
                            .resizable()
                            .position(x: object.oPx, y: object.oPy).frame(width: object.oSx, height: object.oSy)
                }
            }
        case 3:
            return VStack {
                GeometryReader { geometry in
                    Image("zod03").resizable()
                            .resizable()
                            .position(x: object.oPx, y: object.oPy).frame(width: object.oSx, height: object.oSy)
                }
            }
        case 4:
            return VStack {
                GeometryReader { geometry in
                    Image("zod04").resizable()
                            .resizable()
                            .position(x: object.oPx, y: object.oPy).frame(width: object.oSx, height: object.oSy)
                }
            }
        case 5:
            return VStack {
                GeometryReader { geometry in
                    Image("zod05").resizable()
                            .resizable()
                            .position(x: object.oPx, y: object.oPy).frame(width: object.oSx, height: object.oSy)
                }
            }
        case 6:
            return VStack {
                GeometryReader { geometry in
                    Image("zod06").resizable()
                            .resizable()
                            .position(x: object.oPx, y: object.oPy).frame(width: object.oSx, height: object.oSy)
                }
            }
        case 7:
            return VStack {
                GeometryReader { geometry in
                    Image("zod07").resizable()
                            .resizable()
                            .position(x: object.oPx, y: object.oPy).frame(width: object.oSx, height: object.oSy)
                }
            }
        case 8:
            return VStack {
                GeometryReader { geometry in
                    Image("zod08").resizable()
                            .resizable()
                            .position(x: object.oPx, y: object.oPy).frame(width: object.oSx, height: object.oSy)
                }
            }
        case 9:
            return VStack {
                GeometryReader { geometry in
                    Image("zod09").resizable()
                            .resizable()
                            .position(x: object.oPx, y: object.oPy).frame(width: object.oSx, height: object.oSy)
                }
            }
        case 10:
            return VStack {
                GeometryReader { geometry in
                    Image("zod10").resizable()
                            .resizable()
                            .position(x: object.oPx, y: object.oPy).frame(width: object.oSx, height: object.oSy)
                }
            }
        case 11:
            return VStack {
                GeometryReader { geometry in
                    Image("zod11").resizable()
                            .resizable()
                            .position(x: object.oPx, y: object.oPy).frame(width: object.oSx, height: object.oSy)
                }
            }
        default:
            return VStack {
                GeometryReader { geometry in
                    Image("zod12").resizable()
                            .resizable()
                            .position(x: object.oPx, y: object.oPy).frame(width: object.oSx, height: object.oSy)
                }
            }
        }
    }
}