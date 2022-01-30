//
//  ContentView.swift
//  astrologiePourIPhone11
//
//  Created by Stéphane on 18.01.22.
//

import SwiftUI
import Foundation


struct ContentView: View {
    @State var selected: Int
    @State var isActive: Bool = false
    @State var swPluton: Bool = false
    @State var swNode: Bool = false
    @State var swChiron: Bool = false
    @State var swCeres: Bool = false
    var chartDefault: Swe.Chart = loadDefaultValue().0
    @State var selectedDateNatal: Date = loadDefaultValue().1
    @State var selectedDateTransit: Date = Date()
    @State var latNatal: Double = loadDefaultValue().0.nLat
    @State var lngNatal: Double = loadDefaultValue().0.nLng
    @State var latTransit: Double = loadDefaultValue().0.tLat
    @State var lngTransit: Double = loadDefaultValue().0.tLng
    @State var tzNatal: Int = Int(loadDefaultValue().0.nTimeZone)
    @State var tzTransit: Int = Int(loadDefaultValue().0.tTimeZone)
    @State var swShowNatal = false
    @State var swShowTransit = false
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        let swe = Swe(
                chart: loadValue(
                        selectedDate: selectedDateNatal,
                        selectedDateTransit: selectedDateTransit,
                        lat: (latNatal, latTransit),
                        lng: (lngNatal, lngTransit),
                        tz: (Int32(tzNatal), Int32(tzTransit))))
        VStack {
            if self.isActive {
                ZStack {
                    Image(colorScheme == .light ? "bgl" : "bgd")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .edgesIgnoringSafeArea(.all)
                    VStack {
                        TabView(selection: $selected) {
                            VStack {
                                AstrologieView(
                                        swTransit: false,
                                        swPluton: $swPluton,
                                        swNode: $swNode,
                                        swChiron: $swChiron,
                                        swCeres: $swCeres,
                                        selectedDateNatal: $selectedDateNatal,
                                        selectedDateNatalC: $selectedDateNatal,
                                        selectedDateTransit: $selectedDateTransit,
                                        selectedDateTransitC: $selectedDateTransit,
                                        latNatal: $latNatal,
                                        latNatalC: $latNatal,
                                        lngNatal: $lngNatal,
                                        lngNatalC: $lngNatal,
                                        latTransit: $latTransit,
                                        latTransitC: $latTransit,
                                        lngTransit: $lngTransit,
                                        lngTransitC: $lngTransit,
                                        tzNatal: $tzNatal,
                                        tzNatalC: $tzNatal,
                                        tzTransit: $tzTransit,
                                        tzTransitC: $tzTransit,
                                        swShowNatal: $swShowNatal,
                                        swShowTransit: $swShowTransit
                                )
                            }.tabItem {
                                VStack {
                                    Image(systemName: "line.3.crossed.swirl.circle.fill")
                                    Text("Natal")
                                }
                            }.tag(1)
                            AstrologieView(
                                    swTransit: true,
                                    swPluton: $swPluton,
                                    swNode: $swNode,
                                    swChiron: $swChiron,
                                    swCeres: $swCeres,
                                    selectedDateNatal: $selectedDateNatal,
                                    selectedDateNatalC: $selectedDateNatal,
                                    selectedDateTransit: $selectedDateTransit,
                                    selectedDateTransitC: $selectedDateTransit,
                                    latNatal: $latNatal,
                                    latNatalC: $latNatal,
                                    lngNatal: $lngNatal,
                                    lngNatalC: $lngNatal,
                                    latTransit: $latTransit,
                                    latTransitC: $latTransit,
                                    lngTransit: $lngTransit,
                                    lngTransitC: $lngTransit,
                                    tzNatal: $tzNatal,
                                    tzNatalC: $tzNatal,
                                    tzTransit: $tzTransit,
                                    tzTransitC: $tzTransit,
                                    swShowNatal: $swShowNatal,
                                    swShowTransit: $swShowTransit
                            ).tabItem {
                                VStack {
                                    Image(systemName: "line.3.crossed.swirl.circle.fill")
                                    Text("Transit")
                                }
                            }.tag(2)
                            BodieSelectView(
                                    swPluton: $swPluton,
                                    swNode: $swNode,
                                    swChiron: $swChiron,
                                    swCeres: $swCeres
                            ).tabItem {
                                VStack {
                                    Image(systemName: "switch.2")
                                    Text("Sélection planètes")
                                }
                            }.tag(3)
                            AboutView().tabItem {
                                VStack {
                                    Image(systemName: "info.circle")
                                    Text("À propos")
                                }
                            }.tag(4)
                        }.onAppear() {
                            UITabBar.appearance().barTintColor = UIColor(Color(hex: "aa9966"))
                            UITabBar.appearance().unselectedItemTintColor = .systemGray5
                        }.accentColor(.white)
                    }
                }
            } else {
                Image("splash")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(minWidth: 0, maxWidth: .infinity)
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .onAppear {
            // 6.
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                // 7.
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}


extension TabView {
    func myTabViewStyle() -> some View {
        self.background(Image("bgl"))              // Replace 'BackgroundImage' with your image name
                // or   self.background(Image(systemName: "questionmark.square"))
                .frame(width: 200, height: 500, alignment: .top)   // Optional, but shows the background
                .opacity(0.5)                                      // Again optional, but shows the effect

        // etc, with other View modifiers, choose the ones you need
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(selected: 0)
    }
}

func loadValue(
        selectedDate: Date,
        selectedDateTransit: Date,
        lat: (Double, Double),
        lng: (Double, Double),
        tz: (Int32, Int32)) -> Swe.Chart {
    let chartDefault: Swe.Chart = loadDefaultValue().0
    //
    let nLng = lng.0 // chartDefault.nLng
    let tLng = lng.1 // chartDefault.tLng
    let nLat = lat.0 // chartDefault.nLat
    let tLat = lat.1 //chartDefault.tLat
    let nTimeZone = tz.0 // chartDefault.nTimeZone
    let tTimeZone = tz.1 // chartDefault.tTimeZone
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YYYY"
    let nYear = Int32(dateFormatter.string(from: selectedDate)) ?? chartDefault.nYear
    let tYear = Int32(dateFormatter.string(from: selectedDateTransit)) ?? chartDefault.tYear
    dateFormatter.dateFormat = "MM"
    let nMonth = Int32(dateFormatter.string(from: selectedDate)) ?? chartDefault.nMonth
    let tMonth = Int32(dateFormatter.string(from: selectedDateTransit)) ?? chartDefault.tMonth
    dateFormatter.dateFormat = "dd"
    let nDay = Int32(dateFormatter.string(from: selectedDate)) ?? chartDefault.nDay
    let tDay = Int32(dateFormatter.string(from: selectedDateTransit)) ?? chartDefault.tDay
    dateFormatter.dateFormat = "hh"
    let nHour = Int32(dateFormatter.string(from: selectedDate)) ?? chartDefault.nHour
    let tHour = Int32(dateFormatter.string(from: selectedDateTransit)) ?? chartDefault.tHour
    dateFormatter.dateFormat = "mm"
    let nMin = Int32(dateFormatter.string(from: selectedDate)) ?? chartDefault.nMin
    let tMin = Int32(dateFormatter.string(from: selectedDateTransit)) ?? chartDefault.tMin
    return Swe.Chart(
            nLat: nLat,
            nLng: nLng,
            nTimeZone: nTimeZone,
            nYear: nYear,
            nMonth: nMonth,
            nDay: nDay,
            nHour: nHour,
            nMin: nMin,
            tLat: tLat,
            tLng: tLng,
            tTimeZone: tTimeZone,
            tYear: tYear,
            tMonth: tMonth,
            tDay: tDay,
            tHour: tHour,
            tMin: tMin)
}

func loadDefaultValue() -> (Swe.Chart, Date, Date) {
    var decode: Swe.Chart = Swe.Chart.init(
            nLat: 46.12,
            nLng: 6.09,
            nTimeZone: 2,
            nYear: 1981,
            nMonth: 1,
            nDay: 1,
            nHour: 0,
            nMin: 0,
            tLat: 46.12,
            tLng: 6.09,
            tTimeZone: 2,
            tYear: 2022,
            tMonth: 1,
            tDay: 24,
            tHour: 12,
            tMin: 0)
    do {
        let path = Bundle.main.path(forResource: "data", ofType: "json")
        let jsonData = try! String(contentsOfFile: path!).data(using: .utf8)!
        decode = try JSONDecoder().decode(Swe.Chart.self, from: jsonData)
    } catch {
        print("Unable to open chart file")
    }
    var dateN = DateComponents()
    dateN.year = Int(decode.nYear)
    dateN.month = Int(decode.nMonth)
    dateN.day = Int(decode.nDay)
    dateN.hour = Int(decode.nHour)
    dateN.minute = Int(decode.nMin)
    let calandarNatal = Calendar(identifier: .gregorian).date(from: dateN)
    let dateNatal = calandarNatal.unsafelyUnwrapped

    var dateT = DateComponents()
    dateT.year = Int(decode.tYear)
    dateT.month = Int(decode.tMonth)
    dateT.day = Int(decode.tDay)
    dateT.hour = Int(decode.nHour)
    dateT.minute = Int(decode.nMin)
    let calandarTransit = Calendar(identifier: .gregorian).date(from: dateT)
    let dateTransit = calandarTransit.unsafelyUnwrapped

    return (decode, dateNatal, dateTransit)
}
