//
// Created by Stéphane on 26.01.22.
//

import Foundation
import SwiftUI

struct ChartBodieImageView: View {
    @State var swTransit: Bool
    @Binding var swChiron: Bool
    @Binding var swCeres: Bool
    @State var idx: Int
    var swe: Swe
    var body: some View {
        let cD: ChartDraw = ChartDraw(swe: swe)
        if (idx == Swe.Bodies.chiron.rawValue && swChiron == false) != true
                   && (idx == Swe.Bodies.ceres.rawValue && swCeres == false) != true {
            let _ = Swe.Bodies.init(rawValue: Int32(idx)) ?? Swe.Bodies.sun
            let bodN = cD.bodie(swe: cD.swe, bodie: Int32(idx), swTransit: false)
            let bodT = cD.bodie(swe: cD.swe, bodie: Int32(idx), swTransit: true)
            VStack {
                GeometryReader { geometry in
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
                    if bodT.swRetrograde && swTransit {
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
                            .foregroundColor(.red)
                            .offset(
                                    x: bodN.oPx,
                                    y: bodN.oPy)
                            .frame(
                                    width: bodN.oSx,
                                    height: bodN.oSy)
                    if swTransit {
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
