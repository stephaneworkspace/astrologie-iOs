//
// Created by Stéphane on 19.01.22.
//

import Foundation
import SwiftUI

struct ChartDraw {
    let size = 100
    let mult = 3
    let SIZE = 300.0
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
];


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
        var x: Double
        var y: Double
    }

    func getCenterItem(size: Double, offset: Offset) -> Offset {
        Offset(
                x: offset.x - (size / 2.0),
                y: offset.y - (size / 2.0))
    }

    func getPosTrigo(angular: Double, radiusCircle: Double) -> Offset {
        let getCenter = getRadiusTotal()
        return Offset(
                x: getCenter + cos(angular / CIRCLE * 2.0 * Double.pi) * -1.0 * radiusCircle,
                y: getCenter + sin(angular / CIRCLE * 2.0 * Double.pi) * radiusCircle)
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
        var sX: Double
        var sY: Double
        var pX: Double
        var pY: Double
    }

    struct Line {
        var x1: Double
        var y1: Double
        var x2: Double
        var y2: Double
    }

    struct LineShape: Shape {
        var o: Object
        let center = 300.0 // TODO 300.0

        func path(in rect: CGRect) -> Path {
            print(o)
            var path = Path()
            path.move(to: CGPoint(x: center + o.pX, y: center + o.pY))
            path.addLine(to: CGPoint(x: o.sX, y: o.sY))
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

    func drawLine(objects: [Line]) -> Path {
        var path = Path()
        for o in objects {
            path.move(to: CGPoint(x: o.x1, y: o.y1))
            path.addLine(to: CGPoint(x: o.x2, y:o.y2))
        }
        return path
    }
/*
    func drawTickMarks(size: Double, offset: Double, objects: [Object]) -> Path {
        var path = Path()
        // 1
        let clockCenter = size / 2.0 + offset
        let clockRadius = size / 2.0
        // 2
        for x in zodiac_objects(swe: <#T##Swe##astrologiePourIPhone11.Swe#>) {
            // 3
            //let angle = Double(hourMark) / 12.0 * 2.0 * Double.pi
            // 4
            let startX = cos(angle) * clockRadius + clockCenter
            let startY = sin(angle) * clockRadius + clockCenter
            // 5
            let endX = cos(angle) * clockRadius * 0.9 + clockCenter
            let endY = sin(angle) * clockRadius * 0.9 + clockCenter
            // 6
            path.move(to: CGPoint(x: startX, y: startY))
            // 7
            path.addLine(to: CGPoint(x: endX, y: endY))
        }
        return path
    }*/

    func getCenter() -> Offset {
        Offset(x: getRadiusTotal(), y: getRadiusTotal())
    }

    func getLineTrigo(angular: Double, radiusCircleBegin: Double, radiusCircleEnd: Double) -> [Offset] {
        var res: [Offset] = []
        let dx1: Double = getCenter().x
                + cos(angular / CIRCLE  * 2.0 * Double.pi)
                * -1.0
                * radiusCircleBegin
        let dx2: Double = self.getCenter().y
                + sin(angular / CIRCLE * 2.0 * Double.pi)
                * radiusCircleBegin
        let dy1: Double = self.getCenter().x
                + cos(angular / CIRCLE * 2.0 * Double.pi)
                * -1.0
                * radiusCircleEnd
        let dy2: Double = self.getCenter().y
                + sin(angular / CIRCLE * 2.0 * Double.pi)
                * radiusCircleEnd
        res.append(Offset(x: dx1, y: dx2))
        res.append(Offset(x: dy1, y: dy2))
        return res
    }

    func getRadiusCircle(occurs: Int) -> (Double, Bool) {
        /*if occurs > CIRCLE_SIZE_TRANSIT.len() {
            // TODO panic out of range in circle occurs
        }*/
        let d = getRadiusTotal() * CIRCLE_SIZE_TRANSIT[occurs].0 / 100
        return (d, CIRCLE_SIZE_TRANSIT[occurs].1)
    }

    func zodiac_lines(swe: Swe) -> [Line] {
        var res: [Line] = []
        for i in 1...12 {
            // 0°
            let offPosAsc = 360.0 - swe.houses[0].longitude
            var pos = Double(i) * 30.0 + offPosAsc
            pos = getFixedPos(pos_value: pos)
            let axy: [Offset] = getLineTrigo(
                    angular: pos,
                    radiusCircleBegin: getRadiusCircle(occurs: 2).0,
                    radiusCircleEnd: getRadiusCircle(occurs: 1).0)
            res.append(Line(
                    x1: axy[0].x,
                    y1: axy[0].y,
                    x2: axy[1].x,
                    y2: axy[1].y)
            )
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
        return Object(
                sX: zodiacSize,
                sY: zodiacSize,
                pX: offset.x,
                pY: offset.y)
    }
}