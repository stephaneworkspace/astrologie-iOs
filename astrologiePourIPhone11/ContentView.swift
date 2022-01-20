//
//  ContentView.swift
//  astrologiePourIPhone11
//
//  Created by Stéphane on 18.01.22.
//

import SwiftUI

func swe() -> String {
    let swe = Swe()
    return swe.bodies[0].0.calculUt.longitude.formatted()
}

struct ContentView: View {
    var cD: ChartDraw = ChartDraw()
    var body: some View {
        ZStack {
            // Circle
            VStack {
                // Text("Astrologie").padding()
                // Text("Éphémérides").padding()
                // #if targetEnvironment(simulator)
                // Text("Simulator").padding()
                // #endif
            }.frame(width: .infinity, height: .infinity)
            // Draw chart circles
            VStack {
                cD.drawCircle(circles: cD.circles(swe: cD.swe))
                        .stroke(.black, lineWidth: 1.0)
            }.frame(width: cD.SIZE, height: cD.SIZE)
            // Draw zodiac lines
            VStack {
                cD.drawLine(lines: cD.zodiac_lines(swe: cD.swe))
                        .stroke(.black, lineWidth: 1.0)
            }.frame(width: cD.SIZE, height: cD.SIZE)
            // Draw house triangle and lines
            VStack {
                ChartDraw.DrawHouseTriangle(lines: cD.house_lines(swe: cD.swe))
                        .fill(.black)
            }.frame(width: cD.SIZE, height: cD.SIZE)
            VStack {
                cD.drawHouseLine(lines: cD.house_lines(swe: cD.swe)).stroke(.black, lineWidth: 1.0)
            }.frame(width: cD.SIZE, height: cD.SIZE)
            // Draw zodiac symbols
            ForEach(1...12, id: \.self) { idx in
                VStack {
                    GeometryReader { geometry in
                        if idx < 10 {
                            Image("zod0" + idx.formatted())
                                    .resizable()
                                    .offset(
                                            x: cD.zodiac_sign(swe: cD.swe, sign: Int32(idx)).oPx,
                                            y: cD.zodiac_sign(swe: cD.swe, sign: Int32(idx)).oPy)
                                    .frame(
                                            width: cD.zodiac_sign(swe: cD.swe, sign: Int32(idx)).oSx,
                                            height: cD.zodiac_sign(swe: cD.swe, sign: Int32(idx)).oSy)
                        } else {
                            Image("zod" + idx.formatted())
                                    .resizable()
                                    .offset(
                                            x: cD.zodiac_sign(swe: cD.swe, sign: Int32(idx)).oPx,
                                            y: cD.zodiac_sign(swe: cD.swe, sign: Int32(idx)).oPy)
                                    .frame(
                                            width: cD.zodiac_sign(swe: cD.swe, sign: Int32(idx)).oSx,
                                            height: cD.zodiac_sign(swe: cD.swe, sign: Int32(idx)).oSy)
                        }
                    }
                }.frame(width: cD.SIZE, height: cD.SIZE)
            }
            // Draw bodies line on chart
            ForEach(1...8, id: \.self) { idx in
                VStack {
                    cD.drawBodieLine(lines: cD.bodie_lines(swe: cD.swe, swTransit: false)).stroke(.black, lineWidth: 1.0)
                }.frame(width: cD.SIZE, height: cD.SIZE)
            }
            ForEach(1...8, id: \.self) { idx in
                VStack {
                    cD.drawBodieLine(lines: cD.bodie_lines(swe: cD.swe, swTransit: true)).stroke(.black, lineWidth: 1.0)
                }.frame(width: cD.SIZE, height: cD.SIZE)
            }
            // Draw bodies symbol
            ForEach(0...8, id: \.self) { idx in
                VStack {
                    GeometryReader { geometry in
                        if cD.bodie(swe: cD.swe, bodie: Int32(idx), swTransit: true).swRetrograde {
                            Image("r")
                                    .resizable()
                                    .offset(
                                            x: cD.bodie(swe: cD.swe, bodie: Int32(idx), swTransit: true).oPx + cD.bodie(swe: cD.swe, bodie: Int32(idx), swTransit: true).oSx / cD.RETOGRADE_DIV,
                                            y: cD.bodie(swe: cD.swe, bodie: Int32(idx), swTransit: true).oPy + cD.bodie(swe: cD.swe, bodie: Int32(idx), swTransit: true).oSy / cD.RETOGRADE_DIV)
                                    .frame(
                                            width: cD.bodie(swe: cD.swe, bodie: Int32(idx), swTransit: true).oSx / cD.RETOGRADE_DIV,
                                            height: cD.bodie(swe: cD.swe, bodie: Int32(idx), swTransit: true).oSy / cD.RETOGRADE_DIV)

                        }
                        if cD.bodie(swe: cD.swe, bodie: Int32(idx), swTransit: false).swRetrograde {
                            Image("r")
                                    .resizable()
                                    .offset(
                                            x: cD.bodie(swe: cD.swe, bodie: Int32(idx), swTransit: false).oPx + cD.bodie(swe: cD.swe, bodie: Int32(idx), swTransit: true).oSx / cD.RETOGRADE_DIV,
                                            y: cD.bodie(swe: cD.swe, bodie: Int32(idx), swTransit: false).oPy + cD.bodie(swe: cD.swe, bodie: Int32(idx), swTransit: true).oSy / cD.RETOGRADE_DIV)
                                    .frame(
                                            width: cD.bodie(swe: cD.swe, bodie: Int32(idx), swTransit: false).oSx / cD.RETOGRADE_DIV,
                                            height: cD.bodie(swe: cD.swe, bodie: Int32(idx), swTransit: false).oSy / cD.RETOGRADE_DIV)
                        }
                        if idx < 10 {
                            Image("b0" + idx.formatted())
                                    .resizable()
                                    .offset(
                                            x: cD.bodie(swe: cD.swe, bodie: Int32(idx), swTransit: false).oPx,
                                            y: cD.bodie(swe: cD.swe, bodie: Int32(idx), swTransit: false).oPy)
                                    .frame(
                                            width: cD.bodie(swe: cD.swe, bodie: Int32(idx), swTransit: false).oSx,
                                            height: cD.bodie(swe: cD.swe, bodie: Int32(idx), swTransit: false).oSy)
                            Image("b0" + idx.formatted())
                                    .resizable()
                                    .offset(
                                            x: cD.bodie(swe: cD.swe, bodie: Int32(idx), swTransit: true).oPx,
                                            y: cD.bodie(swe: cD.swe, bodie: Int32(idx), swTransit: true).oPy)
                                    .frame(
                                            width: cD.bodie(swe: cD.swe, bodie: Int32(idx), swTransit: true).oSx,
                                            height: cD.bodie(swe: cD.swe, bodie: Int32(idx), swTransit: true).oSy)
                        } else {
                            Image("b" + idx.formatted())
                                    .resizable()
                                    .offset(
                                            x: cD.bodie(swe: cD.swe, bodie: Int32(idx), swTransit: false).oPx,
                                            y: cD.bodie(swe: cD.swe, bodie: Int32(idx), swTransit: false).oPy)
                                    .frame(
                                            width: cD.bodie(swe: cD.swe, bodie: Int32(idx), swTransit: false).oSx,
                                            height: cD.bodie(swe: cD.swe, bodie: Int32(idx), swTransit: false).oSy)
                            Image("b" + idx.formatted())
                                    .resizable()
                                    .offset(
                                            x: cD.bodie(swe: cD.swe, bodie: Int32(idx), swTransit: true).oPx,
                                            y: cD.bodie(swe: cD.swe, bodie: Int32(idx), swTransit: true).oPy)
                                    .frame(
                                            width: cD.bodie(swe: cD.swe, bodie: Int32(idx), swTransit: true).oSx,
                                            height: cD.bodie(swe: cD.swe, bodie: Int32(idx), swTransit: true).oSy)
                        }
                    }
                }.frame(width: cD.SIZE, height: cD.SIZE)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
