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

struct Array2View: View {
    @State var swTransit: Bool
    @State var transitType: Swe.TransitType
    var swe: Swe
    var body: some View {
        switch transitType {
        case .NatalNatal:
            Array2BodieView(swe: swe, transitType: transitType)
        case .NatalTransit:
            Array2BodieView(swe: swe, transitType: transitType)
        case .TransitTransit:
            Array2BodieView(swe: swe, transitType: transitType)
        }
    }
}

struct Array2BodieView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var swe: Swe
    let sizeMax = 390.0
    var size = 300.0
    var transitType: Swe.TransitType // TODO State ?
    var body: some View {
        let cD: ChartDraw = ChartDraw(swe: swe)
        let forlopp: [Int] = swe.CONSTforLopp
        VStack {
            ZStack {
               // ChartDraw.DrawTransit(size: size, transitType: transitType).stroke(.black)
                ForEach(0...forlopp.count - 1, id: \.self) { idx in
                    cD.drawArray2Bodie(idx: forlopp[idx], jdx: idx, size: size).frame(width: size, height: size)
                    cD.drawArray2BodieNom(
                            idx: forlopp[idx],
                            jdx: idx,
                            size: size,
                            colorScheme: colorScheme
                    ).frame(width: size, height: size)
                    cD.drawArray2BodieSign(idx: forlopp[idx], jdx: idx, size: size).frame(width: size, height: size)
                    cD.drawArray2BodieLongitude(
                            idx: forlopp[idx],
                            jdx: idx,
                            size: size,
                            colorScheme: colorScheme
                    ).frame(width: size, height: size)
                    cD.drawArray2BodieSignTransit(idx: forlopp[idx], jdx: idx, size: size).frame(width: size, height: size)
                }
            }.padding()
        }.frame(width: sizeMax, height: sizeMax)
    }

}

struct ArrayDetailView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var swe: Swe
    let sizeMax = 390.0
    var size = 300.0
    var transitType: Swe.TransitType // TODO State ?
    var body: some View {
        let cD: ChartDraw = ChartDraw(swe: swe)
        let forlopp: [Int] = swe.CONSTforLopp
        VStack {
            ZStack {
                ChartDraw.DrawTransit(size: size, transitType: transitType)
                        .stroke(colorScheme == .light ? .black : .white)
                ForEach(0...forlopp.count - 1, id: \.self) { idx in
                    cD.drawArrayBodie(idx: forlopp[idx], jdx: idx, size: size).frame(width: size, height: size)
                }
                if transitType != .NatalTransit {
                    cD.drawArrayAngle(angle: .asc, size: size, colorScheme: colorScheme).frame(width: size, height: size)
                    cD.drawArrayAngle(angle: .mc, size: size, colorScheme: colorScheme).frame(width: size, height: size)
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
