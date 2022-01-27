//
//  ChartView.swift
//  astrologiePourIPhone11
//
//  Created by Stéphane on 21.01.22.
//

import Foundation
import SwiftUI

struct ChartView: View {
    @State var swTransit: Bool
    @Binding var swPluton: Bool
    @Binding var swNode: Bool
    @Binding var swChiron: Bool
    @Binding var swCeres: Bool
    var swe: Swe
    var body: some View {
        ZStack {
            ChartZodiacView(swe: swe)
            ChartHouseView(swe: swe)
            ChartBodieView(
                    swTransit: swTransit,
                    swPluton: $swPluton,
                    swNode: $swNode,
                    swChiron: $swChiron,
                    swCeres: $swCeres,
                    swe: swe
            )
            ChartAspectView(
                    swTransit: swTransit,
                    swPluton: $swPluton,
                    swNode: $swNode,
                    swChiron: $swChiron,
                    swCeres: $swCeres,
                    swe: swe
            )
        }
    }
}

