//
//  ContentView.swift
//  astrologiePourIPhone11
//
//  Created by Stéphane on 18.01.22.
//

import SwiftUI

func swe() -> String {
    let swe = Swe()
    return swe.bodies[0].calculUt.longitude.formatted()
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
                        //.border(.black, width: 2.0)
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
                }.frame(width: cD.SIZE, height: cD.SIZE).border(.red, width: 1.0)
            }
        }
}
}

struct ContentView_Previews: PreviewProvider {
static var previews: some View {
ContentView()
}
}
