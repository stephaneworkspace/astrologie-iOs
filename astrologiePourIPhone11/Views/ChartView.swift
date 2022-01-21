//
//  ChartView.swift
//  astrologiePourIPhone11
//
//  Created by Stéphane on 21.01.22.
//

import Foundation
import SwiftUI

struct ChartView: View {
    var swe: Swe
    var body: some View {
        ZStack {
            ChartZodiacView(swe: swe)
            ChartHouseView(swe: swe)
            ChartBodieView(swe: swe)
            ChartAspectView(swe: swe)
        }
        TransitView(swe: swe)
    }
}

struct TransitView: View {
   var swe: Swe
    var body: some View {
        var cD: ChartDraw = ChartDraw(swe: swe)
        ChartDraw.DrawTransit().stroke(.black).padding()

    }
}

struct ChartZodiacView: View {
    var swe: Swe
    var body: some View {
        var cD: ChartDraw = ChartDraw(swe: swe)
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
        var cD: ChartDraw = ChartDraw(swe: swe)
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
    var swe: Swe
    var body: some View {
        var cD: ChartDraw = ChartDraw(swe: swe)
        ForEach(1...8, id: \.self) { idx in
            ForEach(0...2, id: \.self) { jdx in
                let aspect = Swe.Aspects.init(rawValue: Int32(idx)) ?? Swe.Aspects.conjunction
                let aspectType = ChartDraw.AspectType.init(rawValue: jdx) ?? ChartDraw.AspectType.natal
                let aspectColor = aspect.color()
                let aspectStyle = aspect.style()
                let lines = cD.aspect_lines(swe: cD.swe, aspect: aspect, aspectType: aspectType)
                if lines.count > 0 {
                    VStack {
                        ChartDraw.DrawAspectLines(lines: lines).stroke(aspectColor, style: aspectStyle)
                    }.frame(width: cD.SIZE, height: cD.SIZE)
                }
            }
        }
    }
}

struct ChartBodieView: View {
    var swe: Swe
    var body: some View {
        var cD: ChartDraw = ChartDraw(swe: swe)
        // Draw bodies line on chart
        ForEach(1...8, id: \.self) { idx in
            VStack {
                cD.drawBodieLine(lines: cD.bodie_lines(swe: cD.swe, swTransit: false)).stroke(.black, lineWidth: 0.1)
            }.frame(width: cD.SIZE, height: cD.SIZE)
        }
        ForEach(1...8, id: \.self) { idx in
            VStack {
                cD.drawBodieLine(lines: cD.bodie_lines(swe: cD.swe, swTransit: true)).stroke(.black, lineWidth: 0.1)
            }.frame(width: cD.SIZE, height: cD.SIZE)
        }
        // Draw bodies symbol
        ForEach(0...8, id: \.self) { idx in
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
                    if bodT.swRetrograde {
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
                    Image("b" + idx.formatted())
                            .resizable()
                            .offset(
                                    x: bodT.oPx,
                                    y: bodT.oPy)
                            .frame(
                                    width: bodT.oSx,
                                    height: bodT.oSy)
                }
            }.frame(width: cD.SIZE, height: cD.SIZE)
        }
    }
}
