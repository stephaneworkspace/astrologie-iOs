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

struct Chart1View: View {
    var cD: ChartDraw = ChartDraw()
    var body: some View {
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

    }
}

struct ContentView: View {
    var cD: ChartDraw = ChartDraw()
    var body: some View {
        ZStack {
            Chart1View(cD: cD)
            // House number
            ForEach(1...12, id: \.self) { idx in
                let house = cD.house(swe: cD.swe, number: Int32(idx))
                VStack {
                    GeometryReader { geometry in
                        Image("h" + idx.formatted())
                                .resizable()
                                .offset(
                                        x: house.oPx,
                                        y: house.oPy)
                                .frame(
                                        width: house.oSx,
                                        height: house.oSy)
                    }
                }.frame(width: cD.SIZE, height: cD.SIZE)
            }
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
                    cD.drawBodieLine(lines: cD.bodie_lines(swe: cD.swe, swTransit: false)).stroke(.black, lineWidth: 0.1)
                }.frame(width: cD.SIZE, height: cD.SIZE)
            }
            ForEach(1...8, id: \.self) { idx in
                VStack {
                    cD.drawBodieLine(lines: cD.bodie_lines(swe: cD.swe, swTransit: true)).stroke(.black, lineWidth: 0.1)
                }.frame(width: cD.SIZE, height: cD.SIZE)
            }
            // Draw bodies symbol
            ForEach(0...8, id: \.self) { idx in
                let bod = Swe.Bodies.init(rawValue: Int32(idx)) ?? Swe.Bodies.sun
                let bodN = cD.bodie(swe: cD.swe, bodie: Int32(idx), swTransit: false)
                let bodT = cD.bodie(swe: cD.swe, bodie: Int32(idx), swTransit: true)
                VStack {
                    GeometryReader { geometry in
                        if idx < 10 {
                            if bodN.swRetrograde {
                                Image("r0" + idx.formatted())
                                        .resizable()
                                        .offset(
                                                x: bodN.oPx + bodN.oSx / cD.RETOGRADE_DIV,
                                                y: bodN.oPy + bodN.oSy / cD.RETOGRADE_DIV)
                                        .frame(
                                                width: bodN.oSx / cD.RETOGRADE_DIV,
                                                height: bodN.oSy / cD.RETOGRADE_DIV)
                            }
                            if bodT.swRetrograde {
                                Image("r0" + idx.formatted())
                                        .resizable()
                                        .offset(
                                                x: bodT.oPx + bodT.oSx / cD.RETOGRADE_DIV,
                                                y: bodT.oPy + bodT.oSy / cD.RETOGRADE_DIV)
                                        .frame(
                                                width: bodT.oSx / cD.RETOGRADE_DIV,
                                                height: bodT.oSy / cD.RETOGRADE_DIV)
                            }
                            Image("b0" + idx.formatted())
                                    .resizable()
                                    .foregroundColor(.red)
                                    .offset(
                                            x: bodN.oPx,
                                            y: bodN.oPy)
                                    .frame(
                                            width: bodN.oSx,
                                            height: bodN.oSy)
                            Image("b0" + idx.formatted())
                                    .resizable()
                                    .offset(
                                            x: bodT.oPx,
                                            y: bodT.oPy)
                                    .frame(
                                            width: bodT.oSx,
                                            height: bodT.oSy)
                        } else {
                            if bodN.swRetrograde {
                                Image("r" + idx.formatted())
                                        .resizable()
                                        .offset(
                                                x: bodN.oPx + bodN.oSx / cD.RETOGRADE_DIV,
                                                y: bodN.oPy + bodN.oSy / cD.RETOGRADE_DIV)
                                        .frame(
                                                width: bodN.oSx / cD.RETOGRADE_DIV,
                                                height: bodN.oSy / cD.RETOGRADE_DIV)
                            }
                            if bodT.swRetrograde {
                                Image("r" + idx.formatted())
                                        .resizable()
                                        .offset(
                                                x: bodT.oPx + bodT.oSx / cD.RETOGRADE_DIV,
                                                y: bodT.oPy + bodT.oSy / cD.RETOGRADE_DIV)
                                        .frame(
                                                width: bodT.oSx / cD.RETOGRADE_DIV,
                                                height: bodT.oSy / cD.RETOGRADE_DIV)
                            }
                            Image("b" + idx.formatted())
                                    .resizable()
                                    .offset(
                                            x: bodN.oPx,
                                            y: bodN.oPy)
                                    .frame(
                                            width: bodN.oSx,
                                            height: bodN.oSy)
                            Image("b" + idx.formatted())
                                    .resizable()
                                    .offset(
                                            x: bodT.oPx,
                                            y: bodT.oPy)
                                    .frame(
                                            width: bodT.oSx,
                                            height: bodT.oSy)
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
