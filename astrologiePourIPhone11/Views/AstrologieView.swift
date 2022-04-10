//
// Created by Stéphane on 26.01.22.
//

import Foundation
import SwiftUI

struct AstrologieView: View {
    @State var swTransit: Bool
    @Binding var swBodies: [Bool]
    @Binding var swPluton: Bool
    @Binding var swNode: Bool
    @Binding var swChiron: Bool
    @Binding var swCeres: Bool
    @Binding var selectedDateNatal: Date
    @Binding var selectedDateNatalC: Date
    @Binding var selectedDateTransit: Date
    @Binding var selectedDateTransitC: Date
    @Binding var latNatal: Double
    @Binding var latNatalC: Double
    @Binding var lngNatal: Double
    @Binding var lngNatalC: Double
    @Binding var latTransit: Double
    @Binding var latTransitC: Double
    @Binding var lngTransit: Double
    @Binding var lngTransitC: Double
    @Binding var tzNatal: Int
    @Binding var tzNatalC: Int
    @Binding var tzTransit: Int
    @Binding var tzTransitC: Int
    @Binding var swShowNatal: Bool
    @Binding var swShowTransit: Bool
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var FONTSIZE = 15.0
    var screenSize: CGRect = UIScreen.main.bounds

    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.allowsFloats = true
        return formatter
    }()
    let formatterNoFloat: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.allowsFloats = false
        return formatter
    }()
    var body: some View {
        let swe = Swe(
                chart: loadValue(
                        selectedDate: selectedDateNatal,
                        selectedDateTransit: selectedDateTransit,
                        lat: (latNatalC, latTransitC),
                        lng: (lngNatalC, lngTransitC),
                        tz: (Int32(tzNatalC), Int32(tzTransitC))),
                sizeChart: (screenSize.width == 744 && screenSize.height == 1133) ? 630.0 : 390.0)
        ZStack {
            BgView()
            ScrollView {
                VStack {
                    Spacer().frame(height: 60)
                    ZStack {
                        VStack {
                            Spacer()
                                    .frame(width: 390, height: 390)
                                    .background(RadialGradient(
                                            gradient: Gradient(colors: [Color.orange, Color.white]),
                                            center: .center, startRadius: 60, endRadius: 200)).opacity(0.1)
                                    .clipShape(Circle())
                        }
                        ChartView(
                                swTransit: swTransit,
                                swBodies: $swBodies,
                                swPluton: $swPluton,
                                swNode: $swNode,
                                swChiron: $swChiron,
                                swCeres: $swCeres,
                                swe: swe)
                    }
                    HStack {
                        if swTransit {
                            VStack {
                            }.frame(height: 20)
                        }
                        Button(action: {
                            swShowNatal.toggle()
                        }, label: {
                            ZStack {
                                Spacer()
                                        .frame(width: 150, height: 50)
                                        .background(.orange).opacity(0.1)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                                if colorScheme == .light {
                                    Image("bouton")
                                            .resizable()
                                            .frame(width: 150, height: 50)
                                            .opacity(0.3)
                                }
                                Text("Saisie natal")

                            }
                                    .frame(width: 150, height: 50)
                                    .overlay(RoundedRectangle(cornerRadius: 10)
                                            .stroke(lineWidth: 1)
                                            .foregroundColor(colorScheme == .light ? .black : .white))
                        }).fullScreenCover(isPresented: $swShowNatal) {
                            VStack {
                                AstrologieInputsView(
                                        selectedDate: $selectedDateNatalC,
                                        lat: $latNatalC,
                                        lng: $lngNatalC,
                                        tz: $tzNatalC)
                                Button(action: {
                                    selectedDateNatal = selectedDateNatalC
                                    latNatal = latNatalC
                                    lngNatal = lngNatalC
                                    tzNatal = tzNatalC
                                    let dateFormatter = DateFormatter()
                                    dateFormatter.dateFormat = "YYYY"
                                    let nYear = Int32(dateFormatter.string(from: selectedDateNatal)) ?? 1984
                                    let tYear = Int32(dateFormatter.string(from: selectedDateTransit)) ?? 1984
                                    dateFormatter.dateFormat = "MM"
                                    let nMonth = Int32(dateFormatter.string(from: selectedDateNatal)) ?? 1
                                    let tMonth = Int32(dateFormatter.string(from: selectedDateTransit)) ?? 1
                                    dateFormatter.dateFormat = "dd"
                                    let nDay = Int32(dateFormatter.string(from: selectedDateNatal)) ?? 1
                                    let tDay = Int32(dateFormatter.string(from: selectedDateTransit)) ?? 1
                                    dateFormatter.dateFormat = "hh"
                                    let nHour = Int32(dateFormatter.string(from: selectedDateNatal)) ?? 0
                                    let tHour = Int32(dateFormatter.string(from: selectedDateTransit)) ?? 0
                                    dateFormatter.dateFormat = "mm"
                                    let nMin = Int32(dateFormatter.string(from: selectedDateNatal)) ?? 0
                                    let tMin = Int32(dateFormatter.string(from: selectedDateTransit)) ?? 0
                                    saveChart(chart: Swe.Chart(
                                            nLat: latNatal,
                                            nLng: lngNatal,
                                            nTimeZone: Int32(tzNatal),
                                            nYear: nYear,
                                            nMonth: nMonth,
                                            nDay: nDay,
                                            nHour: nHour,
                                            nMin: nMin,
                                            tLat: latTransit,
                                            tLng: lngTransit,
                                            tTimeZone: Int32(tzTransit),
                                            tYear: tYear,
                                            tMonth: tMonth,
                                            tDay: tDay,
                                            tHour: tHour,
                                            tMin: tMin))
                                    swShowNatal = false
                                }, label: {
                                    VStack {
                                        Text("Fermer")
                                        Text("")
                                        Text("")
                                    }
                                })
                                        .padding().foregroundColor(colorScheme == .light ? .black : .white)
                            }
                        }
                                .foregroundColor(colorScheme == .light ? .black : .white)
                                .padding()
                                .cornerRadius(10)
                                //.border(colorScheme == .light ? .black : .white, width: 1)
                               // .background(colorScheme == .light ? .orange : .orange)
                        if swTransit {
                            Button(action: {
                                swShowTransit.toggle()
                            }, label: {
                                ZStack {
                                    Spacer()
                                            .frame(width: 150, height: 50)
                                            .background(.orange).opacity(0.1)
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                    if colorScheme == .light {
                                        Image("bouton")
                                                .resizable()
                                                .frame(width: 150, height: 50)
                                                .opacity(0.3)
                                    }
                                    Text("Saisie transit")
                                }
                                        .frame(width: 150, height: 50)
                                        .overlay(RoundedRectangle(cornerRadius: 10)
                                                .stroke(lineWidth: 1)
                                                .foregroundColor(colorScheme == .light ? .black : .white))
                            }).fullScreenCover(isPresented: $swShowTransit) {
                                VStack {
                                    AstrologieInputsTransitView(
                                            selectedDate: $selectedDateTransitC,
                                            lat: $latTransitC,
                                            lng: $lngTransitC,
                                            tz: $tzTransitC)
                                    Button(action: {
                                        selectedDateTransit = selectedDateTransitC
                                        latTransit = latTransitC
                                        lngTransit = lngTransitC
                                        tzTransit = tzTransitC
                                        let dateFormatter = DateFormatter()
                                        dateFormatter.dateFormat = "YYYY"
                                        let nYear = Int32(dateFormatter.string(from: selectedDateNatal)) ?? 1984
                                        let tYear = Int32(dateFormatter.string(from: selectedDateTransit)) ?? 1984
                                        dateFormatter.dateFormat = "MM"
                                        let nMonth = Int32(dateFormatter.string(from: selectedDateNatal)) ?? 1
                                        let tMonth = Int32(dateFormatter.string(from: selectedDateTransit)) ?? 1
                                        dateFormatter.dateFormat = "dd"
                                        let nDay = Int32(dateFormatter.string(from: selectedDateNatal)) ?? 1
                                        let tDay = Int32(dateFormatter.string(from: selectedDateTransit)) ?? 1
                                        dateFormatter.dateFormat = "hh"
                                        let nHour = Int32(dateFormatter.string(from: selectedDateNatal)) ?? 0
                                        let tHour = Int32(dateFormatter.string(from: selectedDateTransit)) ?? 0
                                        dateFormatter.dateFormat = "mm"
                                        let nMin = Int32(dateFormatter.string(from: selectedDateNatal)) ?? 0
                                        let tMin = Int32(dateFormatter.string(from: selectedDateTransit)) ?? 0
                                        saveChart(chart: Swe.Chart(
                                                nLat: latNatal,
                                                nLng: lngNatal,
                                                nTimeZone: Int32(tzNatal),
                                                nYear: nYear,
                                                nMonth: nMonth,
                                                nDay: nDay,
                                                nHour: nHour,
                                                nMin: nMin,
                                                tLat: latTransit,
                                                tLng: lngTransit,
                                                tTimeZone: Int32(tzTransit),
                                                tYear: tYear,
                                                tMonth: tMonth,
                                                tDay: tDay,
                                                tHour: tHour,
                                                tMin: tMin))
                                        swShowTransit = false
                                    }, label: {
                                        VStack {
                                            Text("Fermer")
                                            Text("")
                                            Text("")
                                        }
                                    })
                                            .padding().foregroundColor(colorScheme == .light ? .black : .white)
                                    Spacer()
                                }
                            }
                                    .foregroundColor(colorScheme == .light ? .black : .white)
                                    .padding()


                            //  .border(colorScheme == .light ? .black : .white, width: 1)
                                   // .background(colorScheme == .light ? .orange : .orange)
                        }
                    }
                    VStack {

                    }.frame(height: 70) // TODO CONST
                    Array2View(
                            swTransit: swTransit,
                            transitType: .NatalNatal,
                            swe: swe)
                    ZStack {
                        VStack {
                            Spacer()
                                    .frame(width: 390, height: 305)
                                    .background(.orange).opacity(0.1)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                        }.offset(x: 0, y: -35)
                        VStack {
                            Image("natalArray").resizable().frame(width: 150, height: 80)
                        }.offset(x: 152, y: -160)
                        ArrayView(
                                swTransit: swTransit,
                                transitType: .NatalNatal,
                                sizeHeight: 305,
                                swe: swe)
                    }
                    VStack {

                    }.frame(height: 35) // TODO CONST
                    if swTransit {
                        ZStack {
                            VStack {
                                Spacer()
                                        .frame(width: 390, height: 285)
                                        .background(.orange).opacity(0.1)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                            }.offset(x: 0, y: -55)
                            VStack {
                                Image("natalArray").resizable().frame(width: 150, height: 80)
                            }.offset(x: 152, y: -170)
                            VStack {
                                Image("transitArray").resizable().frame(width: 210, height: 80)
                            }.offset(x: 145, y: -125)
                            ArrayView(
                                    swTransit: swTransit,
                                    transitType: .NatalTransit,
                                    sizeHeight: 285,
                                    swe: swe)
                        }
                        VStack {

                        }.frame(height: -5) // TODO CONST
                        ZStack {
                            VStack {
                                Spacer()
                                        .frame(width: 390, height: 305)
                                        .background(.orange).opacity(0.1)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                            }.offset(x: 0, y: -35)
                            VStack {
                                Image("transitArray").resizable().frame(width: 210, height: 80)
                            }.offset(x: 145, y: -160)
                            ArrayView(
                                    swTransit: swTransit,
                                    transitType: .TransitTransit,
                                    sizeHeight: 305,
                                    swe: swe)
                        }
                        VStack {

                        }.frame(height: 30) // TODO CONST
                    }
                }
            }
        }
    }
}

func saveChart(chart: Swe.Chart) {
    do {
        let encoded = try JSONEncoder().encode(chart)
        let jsonString = String(data: encoded, encoding: .utf8)
        let url = getDocumentsDirectory().appendingPathComponent("save.json")
        try jsonString?.write(to: url, atomically: true, encoding: .utf8)
    } catch {
        print("Unable to open chart file")
    }
}
