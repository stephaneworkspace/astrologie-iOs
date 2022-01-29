//
// Created by Stéphane on 26.01.22.
//

import Foundation
import SwiftUI

struct AstrologieView: View {
    @State var swTransit: Bool
    @Binding var swPluton: Bool
    @Binding var swNode: Bool
    @Binding var swChiron: Bool
    @Binding var swCeres: Bool
    @Binding var selectedDate: Date
    @Binding var selectedDateTransit: Date
    @Binding var latNatal: Double
    @Binding var lngNatal: Double
    @Binding var latTransit: Double
    @Binding var lngTransit: Double
    @Binding var tzNatal: Int
    @Binding var tzTransit: Int
    @Binding var swShowNatal: Bool
    @Binding var swShowTransit: Bool
    @Binding var swLock: Bool
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var FONTSIZE = 15.0

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
                        selectedDate: selectedDate,
                        selectedDateTransit: selectedDateTransit,
                        lat: (latNatal, latTransit),
                        lng: (lngNatal, lngTransit),
                        tz: (Int32(tzNatal), Int32(tzTransit))))
        ZStack {
            Image(colorScheme == .light ? "bgl" : "bgd")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.3)
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
                                swPluton: $swPluton,
                                swNode: $swNode,
                                swChiron: $swChiron,
                                swCeres: $swCeres,
                                swe: swe)
                    }
                    Spacer().frame(height: 20)
                    /*ZStack {
                        if swTransit {
                            VStack {
                                Spacer()
                                        .frame(width: 400, height: 168)
                                        .background(Color.orange).opacity(0.1)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        } else {
                            VStack {
                                Spacer()
                                        .frame(width: 400, height: 84)
                                        .background(Color.orange).opacity(0.1)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                        }
                        /*
                        AstrologieInputsView(
                                swTransit: $swTransit,
                                selectedDate: $selectedDate,
                                selectedDateTransit: $selectedDateTransit,
                                latNatal: $latNatal,
                                lngNatal: $lngNatal,
                                latTransit: $latTransit,
                                lngTransit: $lngTransit,
                                tzNatal: $tzNatal,
                                tzTransit: $tzTransit)*/
                    }
                }*/
                    HStack {
                        Button(action: {
                            swShowNatal.toggle()
                        }, label: {
                            Text("Saisie données natal")
                        }).fullScreenCover(isPresented: $swShowNatal) {
                            VStack {
                                AstrologieInputsView(
                                        swLock: $swLock,
                                        selectedDate: $selectedDate,
                                        lat: $latNatal,
                                        lng: $lngNatal,
                                        tz: $tzNatal)
                                Button(action: {
                                    swShowNatal = false
                                }, label: {
                                    Text("Fermer")
                                }).padding().foregroundColor(.white)
                                Spacer()
                            }
                        }
                        if swTransit {
                            Button(action: {
                                swShowTransit.toggle()
                            }, label: {
                                Text("Saisie données transit")
                            }).fullScreenCover(isPresented: $swShowTransit) {
                                VStack {
                                    AstrologieInputsTransitView(
                                            swLock: $swLock,
                                            selectedDate: $selectedDateTransit,
                                            lat: $latTransit,
                                            lng: $lngTransit,
                                            tz: $tzTransit)
                                    Button(action: {
                                        swShowTransit = false
                                    }, label: {
                                        Text("Fermer")
                                    }).padding().foregroundColor(.white)
                                    Spacer()
                                }
                            }
                        }

                    }
                    Array2View(
                            swTransit: swTransit,
                            transitType: .NatalNatal,
                            swe: swe)
                    ZStack {
                        VStack {
                            Spacer()
                                    .frame(width: 390, height: 390)
                                    .background(.orange).opacity(0.1)
                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                        ArrayView(
                                swTransit: swTransit,
                                transitType: .NatalNatal,
                                swe: swe)
                    }
                    if swTransit {
                        ZStack {
                            VStack {
                                Spacer()
                                        .frame(width: 390, height: 390)
                                        .background(.orange).opacity(0.1)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            ArrayView(
                                    swTransit: swTransit,
                                    transitType: .NatalTransit,
                                    swe: swe)
                        }
                        ZStack {
                            VStack {
                                Spacer()
                                        .frame(width: 390, height: 390)
                                        .background(.orange).opacity(0.1)
                                        .clipShape(RoundedRectangle(cornerRadius: 12))
                            }
                            ArrayView(
                                    swTransit: swTransit,
                                    transitType: .TransitTransit,
                                    swe: swe)
                        }

                    }
                }
            }
        }
    }
}