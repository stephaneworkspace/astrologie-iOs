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
                Circle()
                        .stroke(.black)
                        .frame(width: cD.SIZE, height: cD.SIZE)
                // Text("Astrologie").padding()
                // Text("Éphémérides").padding()
                // #if targetEnvironment(simulator)
                // Text("Simulator").padding()
                // #endif
            }.frame(width: .infinity, height: .infinity)
            // Zodiac
            /*ForEach(1...12, id: \.self) { i in
                VStack {
                    ChartDraw.LineShape(o: cD.zodiac(swe: cD.swe, sign: Int32(i)))
                            .stroke(Color.red, lineWidth: 2.0)
                            .border(.red, width: 1.0)
                }.frame(width: cD.SIZE, height: cD.SIZE)
            }*/
            VStack {
                cD.drawLine(objects: cD.zodiac_lines(swe: cD.swe))
                        .stroke(Color.red, lineWidth: 2.0)
                        .border(.red, width: 1.0)
/*                cD.drawTickMarks(size: 300.0, offset: 0.0)
                        .stroke(Color.red, lineWidth: 2.0)
                        .border(.red, width: 1.0)*/
                /*    ChartDraw.LineShape2()
                        .stroke(Color.red, lineWidth: 2.0)
                        .border(.red, width: 1.0)*/
            }.frame(width: cD.SIZE, height: cD.SIZE)

        }
    }



}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
