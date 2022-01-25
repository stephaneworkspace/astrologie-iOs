//
// Created by Stéphane on 23.01.22.
//

import Foundation
import SwiftUI

struct ArrayView: View {
    @State var swTransit: Bool
    @State var transitType: Swe.TransitType
    var swe: Swe
    var body: some View {
        switch transitType {
        case .NatalNatal:
            ArrayDetailView(swe: swe, transitType: transitType)
        case .NatalTransit:
            ArrayDetailView(swe: swe, transitType: transitType)
        case .TransitTransit:
            ArrayDetailView(swe: swe, transitType: transitType)
        }
    }
}

struct ArrayDetailView: View {
    var swe: Swe
    let sizeMax = 390.0
    var size = 300.0
    var transitType: Swe.TransitType
    var body: some View {
        let cD: ChartDraw = ChartDraw(swe: swe)
        let forlopp: [Int] = swe.CONSTforLopp
        VStack {
            ZStack {
                ChartDraw.DrawTransit(size: size).stroke(.black)
                ForEach(0...forlopp.count - 1, id: \.self) { idx in
                    cD.drawArrayBodie(idx: forlopp[idx], jdx: idx, size: size).frame(width: size, height: size)
                }
                ForEach(swe.aspectsBodies, id: \.self) { asp in
                    if asp.transit == transitType {
                        cD.drawArrayAspect(asp: asp, size: size).frame(width: size, height: size)
                    }
                }
                ForEach(swe.aspectsAngleBodies, id: \.self) { asp in
                    if asp.transit == transitType {
                        cD.drawArrayAngleAspect(asp: asp, size: size).frame(width: size, height: size)
                    }
                }
            }.padding()
        }.frame(width: sizeMax, height: sizeMax)
    }
}
