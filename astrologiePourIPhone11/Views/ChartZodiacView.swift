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
        }.frame(width: cD.swe.SIZE, height: cD.swe.SIZE)
        // Draw zodiac lines
        VStack {
            cD.drawLine(lines: cD.zodiac_lines(swe: cD.swe))
                    .stroke(colorScheme == .light ? .black : .white, lineWidth: 1.0)
        }.frame(width: cD.swe.SIZE, height: cD.swe.SIZE)
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
            }.frame(width: cD.swe.SIZE, height: cD.swe.SIZE)
        }
        let angle_asc = cD.angle(swe: cD.swe, angle: .asc)
        VStack {
            GeometryReader { geometry in
                Image(colorScheme == .light ? "a" + angle_asc.svg : "ad" + angle_asc.svg)
                        .resizable()
                        .offset(
                                x: angle_asc.oPx,
                                y: angle_asc.oPy)
                        .frame(
                                width: angle_asc.oSx,
                                height: angle_asc.oSy)
            }
        }.frame(width: cD.swe.SIZE, height: cD.swe.SIZE)
        let angle_fc = cD.angle(swe: cD.swe, angle: .fc)
        VStack {
            GeometryReader { geometry in
                Image(colorScheme == .light ? "a" + angle_fc.svg : "ad" + angle_fc.svg)
                        .resizable()
                        .offset(
                                x: angle_fc.oPx,
                                y: angle_fc.oPy)
                        .frame(
                                width: angle_fc.oSx,
                                height: angle_fc.oSy)
            }
        }.frame(width: cD.swe.SIZE, height: cD.swe.SIZE)
        let angle_desc = cD.angle(swe: cD.swe, angle: .desc)
        VStack {
            GeometryReader { geometry in
                Image(colorScheme == .light ? "a" + angle_desc.svg : "ad" + angle_desc.svg)
                        .resizable()
                        .offset(
                                x: angle_desc.oPx,
                                y: angle_desc.oPy)
                        .frame(
                                width: angle_desc.oSx,
                                height: angle_desc.oSy)
            }
        }.frame(width: cD.swe.SIZE, height: cD.swe.SIZE)
        let angle_mc = cD.angle(swe: cD.swe, angle: .mc)
        VStack {
            GeometryReader { geometry in
                Image(colorScheme == .light ? "a" + angle_mc.svg : "ad" + angle_mc.svg)
                        .resizable()
                        .offset(
                                x: angle_mc.oPx,
                                y: angle_mc.oPy)
                        .frame(
                                width: angle_mc.oSx,
                                height: angle_mc.oSy)
            }
        }.frame(width: cD.swe.SIZE, height: cD.swe.SIZE)
        VStack {
            cD.drawAngleLine(lines: cD.angle_lines(swe: cD.swe))
                    .stroke(colorScheme == .light ? .black : .white, lineWidth: 1.0)
        }.frame(width: cD.swe.SIZE, height: cD.swe.SIZE)
    }
}
