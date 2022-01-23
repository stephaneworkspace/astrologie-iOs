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
            TransitView(swe: swe, transitType: transitType)
        case .NatalTransit:
            TransitView(swe: swe, transitType: transitType)
        case .TransitTransit:
            TransitView(swe: swe, transitType: transitType)
        }
    }
}

struct TransitView: View {
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
                    cD.drawTransitBodie(idx: forlopp[idx], jdx: idx, size: size).frame(width: size, height: size)
                }
                ForEach(swe.aspectsBodies, id: \.self) { asp in
                    if asp.transit == transitType {
                        cD.drawTransitAspect(asp: asp, size: size).frame(width: size, height: size)
                    }
                }
            }.padding()
        }.frame(width: sizeMax, height: sizeMax)
    }
}
