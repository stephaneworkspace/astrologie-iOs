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

    struct LineShape: Shape {
        var o: Object

        func path(in rect: CGRect) -> Path {
            print(o)
            var path = Path()
            path.move(to: CGPoint(x: o.pX, y: o.pY))
            path.addLine(to: CGPoint(x: o.sX, y: o.sY))
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

    func zodiac(swe: Swe, sign: Int32) -> Object {
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