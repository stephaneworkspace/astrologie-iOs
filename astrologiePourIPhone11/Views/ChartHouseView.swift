//
// Created by Stéphane on 27.01.22.
//

import Foundation
import SwiftUI

struct ChartHouseView: View {
    var swe: Swe
    var body: some View {
        let cD: ChartDraw = ChartDraw(swe: swe)
        // Draw house triangle and lines
        VStack {
            ChartDraw.DrawHouseTriangle(lines: cD.house_lines(swe: cD.swe))
                    .fill(.black)
        }.frame(width: cD.SIZE, height: cD.SIZE)
        VStack {
            cD.drawHouseLine(lines: cD.house_lines(swe: cD.swe)).stroke(.black, lineWidth: 1.0)
        }.frame(width: cD.SIZE, height: cD.SIZE)
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
    }
}