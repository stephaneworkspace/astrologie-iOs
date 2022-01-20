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
            // Zodiac
            /*
            ForEach(1...12, id: \.self) { i in
                VStack {
                    ChartDraw.LineShape(o: cD.zodiac(swe: cD.swe, sign: Int32(i)))
                            .stroke(Color.red, lineWidth: 2.0)
                            .border(.red, width: 1.0)
                }.frame(width: cD.SIZE, height: cD.SIZE)
            }*/
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
            // Draw house lines
            VStack {
                cD.drawHouseLine(lines: cD.house_lines(swe: cD.swe))
                        .stroke(.black, lineWidth: 1.0)
            }.frame(width: cD.SIZE, height: cD.SIZE)
            // Draw zodiac symbols
            ForEach(1...12, id: \.self) { idx in
                cD.drawZodiacSvg(object: cD.zodiac_sign(swe: cD.swe, sign: Int32(idx)))
                        .frame(width: cD.SIZE, height: cD.SIZE).border(.red, width: 1.0)
            }
        }
}
}

struct ContentView_Previews: PreviewProvider {
static var previews: some View {
    ContentView()
}
}
