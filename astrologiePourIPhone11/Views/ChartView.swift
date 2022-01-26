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
    @Binding var swChiron: Bool
    @Binding var swCeres: Bool
    var swe: Swe
    var body: some View {
        ZStack {
            ChartZodiacView(swe: swe)
            ChartHouseView(swe: swe)
            ChartBodieView(
                    swTransit: swTransit,
                    swChiron: $swChiron,
                    swCeres: $swCeres,
                    swe: swe)
            ChartAspectView(swTransit: swTransit, swe: swe)
        }
    }
}


struct ChartZodiacView: View {
    var swe: Swe
    var body: some View {
        let cD: ChartDraw = ChartDraw(swe: swe)
        // Circle
        /* VStack {
             // Text("Astrologie").padding()
             // Text("Éphémérides").padding()
             // #if targetEnvironment(simulator)
             // Text("Simulator").padding()
             // #endif
         }.frame(width: .infinity, height: .infinity)*/
        // Draw chart circles
        VStack {
            cD.drawCircle(circles: cD.circles(swe: cD.swe))
                    .stroke(.black, lineWidth: 1.0)
        }.frame(width: cD.SIZE, height: cD.SIZE)
        // Draw zodiac lines
        VStack {
            cD.drawLine(lines: cD.zodiac_lines(swe: cD.swe))
                    .stroke(.black, lineWidth: 1.0)
        }.frame(width: cD.SIZE, height: cD.SIZE)
        ForEach(1...12, id: \.self) { idx in
            VStack {
                GeometryReader { geometry in
                    Image("zod" + idx.formatted())
                            .resizable()
                            .offset(
                                    x: cD.zodiac_sign(swe: cD.swe, sign: Int32(idx)).oPx,
                                    y: cD.zodiac_sign(swe: cD.swe, sign: Int32(idx)).oPy)
                            .frame(
                                    width: cD.zodiac_sign(swe: cD.swe, sign: Int32(idx)).oSx,
                                    height: cD.zodiac_sign(swe: cD.swe, sign: Int32(idx)).oSy)
                }
            }.frame(width: cD.SIZE, height: cD.SIZE)
        }
        let angle = cD.angle(swe: cD.swe, angle: .asc)
        VStack {
            GeometryReader { geometry in
                Image(angle.svg)
                        .resizable()
                        .offset(
                                x: angle.oPx,
                                y: angle.oPy)
                        .frame(
                                width: angle.oSx,
                                height: angle.oSy)
            }
        }.frame(width: cD.SIZE, height: cD.SIZE)
        let angle = cD.angle(swe: cD.swe, angle: .fc)
        VStack {
            GeometryReader { geometry in
                Image(angle.svg)
                        .resizable()
                        .offset(
                                x: angle.oPx,
                                y: angle.oPy)
                        .frame(
                                width: angle.oSx,
                                height: angle.oSy)
            }
        }.frame(width: cD.SIZE, height: cD.SIZE)
        let angle = cD.angle(swe: cD.swe, angle: .desc)
        VStack {
            GeometryReader { geometry in
                Image(angle.svg)
                        .resizable()
                        .offset(
                                x: angle.oPx,
                                y: angle.oPy)
                        .frame(
                                width: angle.oSx,
                                height: angle.oSy)
            }
        }.frame(width: cD.SIZE, height: cD.SIZE)
        let angle = cD.angle(swe: cD.swe, angle: .mc)
        VStack {
            GeometryReader { geometry in
                Image(angle.svg)
                        .resizable()
                        .offset(
                                x: angle.oPx,
                                y: angle.oPy)
                        .frame(
                                width: angle.oSx,
                                height: angle.oSy)
            }
        }.frame(width: cD.SIZE, height: cD.SIZE)
        VStack {
            cD.drawAngleLine(lines: cD.angle_lines(swe: cD.swe)).stroke(.black, lineWidth: 1.0)
        }.frame(width: cD.SIZE, height: cD.SIZE)
    }
}

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

struct ChartAspectView: View {
    @State var swTransit: Bool
    var swe: Swe
    var body: some View {
        let cD: ChartDraw = ChartDraw(swe: swe)
        ForEach(1...8, id: \.self) { idx in // nombre d'aspects
            ForEach(0...2, id: \.self) { jdx in
                let aspect = Swe.Aspects.init(rawValue: Int32(idx)) ?? Swe.Aspects.conjunction
                let aspectType = ChartDraw.AspectType.init(rawValue: jdx) ?? ChartDraw.AspectType.natal
                let aspectColor = aspect.color()
                let aspectStyle = aspect.style()
                let lines = cD.aspect_lines(swe: cD.swe, aspect: aspect, aspectType: aspectType)
                if aspectType == .natal {
                    if lines.count > 0 {
                        VStack {
                            ChartDraw.DrawAspectLines(lines: lines).stroke(aspectColor, style: aspectStyle)
                        }.frame(width: cD.SIZE, height: cD.SIZE)
                    }
                } else {
                    if swTransit {
                        if lines.count > 0 {
                            VStack {
                                ChartDraw.DrawAspectLines(lines: lines).stroke(aspectColor, style: aspectStyle)
                            }.frame(width: cD.SIZE, height: cD.SIZE)
                        }
                    }
                }
            }
        }
    }
}

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

struct ChartBodieView: View {
    @State var swTransit: Bool
    @Binding var swChiron: Bool
    @Binding var swCeres: Bool
    var swe: Swe
    var body: some View {
        let cD: ChartDraw = ChartDraw(swe: swe)
        let forlopp: [Int] = [0,1,2,3,4,5,6,7,8,9,11,15,17] // TODO
        // Draw bodies line on chart
        VStack {
            cD.drawBodieLine(lines: cD.bodie_lines(swe: cD.swe, swTransit: false)).stroke(.black, lineWidth: 0.1)
        }.frame(width: cD.SIZE, height: cD.SIZE)
        if swTransit {
            VStack {
                cD.drawBodieLine(lines: cD.bodie_lines(swe: cD.swe, swTransit: true)).stroke(.black, lineWidth: 0.1)
            }.frame(width: cD.SIZE, height: cD.SIZE)
        }
        // Draw bodies symbol
        ForEach(forlopp, id: \.self) { idx in
           ChartBodieImageView(swTransit: swTransit, swChiron: $swChiron, swCeres: $swCeres, idx: idx, swe: cD.swe)
        }
    }
}
