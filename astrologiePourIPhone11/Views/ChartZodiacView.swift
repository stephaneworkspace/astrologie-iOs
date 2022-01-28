//
// Created by Stéphane on 27.01.22.
//

import Foundation
import SwiftUI

struct ChartZodiacView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var swe: Swe
    var body: some View {
        let cD: ChartDraw = ChartDraw(swe: swe)
        // Circle
        /* VStack {
             // Text("Astrologie").padding()
             // Text("Éphémérides").padding()
             // #if targetEnvironment(simulator)
             // Text("Simulator").padding()
             // #endif
         }.frame(width: .infinity, height: .infinity)*/
        // Draw chart circles
        VStack {
            cD.drawCircle(circles: cD.circles(swe: cD.swe))
                    .stroke(colorScheme == .light ? .black : .white, lineWidth: 1.0)
        }.frame(width: cD.SIZE, height: cD.SIZE)
        // Draw zodiac lines
        VStack {
            cD.drawLine(lines: cD.zodiac_lines(swe: cD.swe))
                    .stroke(colorScheme == .light ? .black : .white, lineWidth: 1.0)
        }.frame(width: cD.SIZE, height: cD.SIZE)
        ForEach(1...12, id: \.self) { idx in
            VStack {
                GeometryReader { geometry in
                    Image("zod" + idx.formatted())
                            .resizable()
                            .offset(
                                    x: cD.zodiac_sign(swe: cD.swe, sign: Int32(idx)).oPx,
                                    y: cD.zodiac_sign(swe: cD.swe, sign: Int32(idx)).oPy)
                            .frame(
                                    width: cD.zodiac_sign(swe: cD.swe, sign: Int32(idx)).oSx,
                                    height: cD.zodiac_sign(swe: cD.swe, sign: Int32(idx)).oSy)
                }
            }.frame(width: cD.SIZE, height: cD.SIZE)
        }
        let angle = cD.angle(swe: cD.swe, angle: .asc)
        VStack {
            GeometryReader { geometry in
                Image(angle.svg)
                        .resizable()
                        .offset(
                                x: angle.oPx,
                                y: angle.oPy)
                        .frame(
                                width: angle.oSx,
                                height: angle.oSy)
            }
        }.frame(width: cD.SIZE, height: cD.SIZE)
        let angle = cD.angle(swe: cD.swe, angle: .fc)
        VStack {
            GeometryReader { geometry in
                Image(angle.svg)
                        .resizable()
                        .offset(
                                x: angle.oPx,
                                y: angle.oPy)
                        .frame(
                                width: angle.oSx,
                                height: angle.oSy)
            }
        }.frame(width: cD.SIZE, height: cD.SIZE)
        let angle = cD.angle(swe: cD.swe, angle: .desc)
        VStack {
            GeometryReader { geometry in
                Image(angle.svg)
                        .resizable()
                        .offset(
                                x: angle.oPx,
                                y: angle.oPy)
                        .frame(
                                width: angle.oSx,
                                height: angle.oSy)
            }
        }.frame(width: cD.SIZE, height: cD.SIZE)
        let angle = cD.angle(swe: cD.swe, angle: .mc)
        VStack {
            GeometryReader { geometry in
                Image(angle.svg)
                        .resizable()
                        .offset(
                                x: angle.oPx,
                                y: angle.oPy)
                        .frame(
                                width: angle.oSx,
                                height: angle.oSy)
            }
        }.frame(width: cD.SIZE, height: cD.SIZE)
        VStack {
            cD.drawAngleLine(lines: cD.angle_lines(swe: cD.swe))
                    .stroke(colorScheme == .light ? .black : .white, lineWidth: 1.0)
        }.frame(width: cD.SIZE, height: cD.SIZE)
    }
}