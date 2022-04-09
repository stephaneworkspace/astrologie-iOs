//
// Created by Stéphane on 27.01.22.
//

import Foundation
import SwiftUI

struct ChartBodieView: View {
    @State var swTransit: Bool
    @Binding var swBodie: [Bool]
    @Binding var swPluton: Bool
    @Binding var swNode: Bool
    @Binding var swChiron: Bool
    @Binding var swCeres: Bool
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var swe: Swe
    var body: some View {
        let cD: ChartDraw = ChartDraw(swe: swe)
        let forlopp: [Int] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 15, 17] // TODO
        // Draw bodies line on chart
        VStack {
            cD.drawBodieLine(
                    lines: cD.bodie_lines(
                            swe: cD.swe,
                            swTransit: false,
                            swBodie: swBodie,
                            swPluton: swPluton,
                            swNode: swNode,
                            swChiron: swChiron,
                            swCeres: swCeres)
            ).stroke(colorScheme == .light ? .black : .white, lineWidth: 0.3)
        }.frame(width: cD.SIZE, height: cD.SIZE)
        if swTransit {
            VStack {
                cD.drawBodieLine(
                        lines: cD.bodie_lines(
                                swe: cD.swe,
                                swTransit: true,
                                swPluton: swPluton,
                                swNode: swNode,
                                swChiron: swChiron,
                                swCeres: swCeres)
                ).stroke(colorScheme == .light ? .black : .white, lineWidth: 0.3)
            }.frame(width: cD.SIZE, height: cD.SIZE)
        }
        // Draw bodies symbol
        ForEach(forlopp, id: \.self) { idx in
            ChartBodieImageView(
                    swTransit: swTransit,
                    swPluton: $swPluton,
                    swNode: $swNode,
                    swChiron: $swChiron,
                    swCeres: $swCeres,
                    idx: idx,
                    swe: cD.swe
            )
        }
    }
}
