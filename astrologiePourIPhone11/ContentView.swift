//
//  ContentView.swift
//  astrologiePourIPhone11
//
//  Created by Stéphane on 18.01.22.
//

import SwiftUI

private func loadValue(selectedDate: Date, selectedDateTransit: Date) -> Swe.Chart {
    var chartDefault: Swe.Chart = loadDefaultValue().0
    //
    var nLng = chartDefault.nLng
    var tLng = chartDefault.tLng
    var nLat = chartDefault.nLat
    var tLat = chartDefault.tLat
    var nTimeZone = chartDefault.nTimeZone
    var tTimeZone = chartDefault.tTimeZone
    var dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "YYYY"
    var nYear = Int32(dateFormatter.string(from: selectedDate)) ?? chartDefault.nYear
    var tYear = Int32(dateFormatter.string(from: selectedDateTransit)) ?? chartDefault.tYear
    dateFormatter.dateFormat = "MM"
    var nMonth = Int32(dateFormatter.string(from: selectedDate)) ?? chartDefault.nMonth
    var tMonth = Int32(dateFormatter.string(from: selectedDateTransit)) ?? chartDefault.tMonth
    dateFormatter.dateFormat = "dd"
    var nDay = Int32(dateFormatter.string(from: selectedDate)) ?? chartDefault.nDay
    var tDay = Int32(dateFormatter.string(from: selectedDateTransit)) ?? chartDefault.tDay
    var nHour = chartDefault.nHour
    var tHour = chartDefault.tHour
    var nMin = chartDefault.nMin
    var tMin = chartDefault.tMin
    //
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

struct ContentView: View {
    var chartDefault: Swe.Chart = loadDefaultValue().0
    @State var selectedDate: Date = loadDefaultValue().1
    @State var selectedDateTransit: Date = Date()
    var body: some View {
        ZStack {
            VStack {
                Text("Astrologie").padding()
                DatePicker("Date de naissance", selection: $selectedDate, displayedComponents: .date)
                DatePicker("Transit", selection: $selectedDateTransit, displayedComponents: .date)
                ChartView(swe: Swe(chart: loadValue(selectedDate: selectedDate, selectedDateTransit: selectedDateTransit)))
            }
        }
    }
}

private func loadDefaultValue() -> (Swe.Chart, Date, Date) {
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
    let calandarNatal = Calendar(identifier: .gregorian).date(from: dateN)
    let dateNatal = calandarNatal.unsafelyUnwrapped

    var dateT = DateComponents()
    dateT.year = Int(decode.tYear)
    dateT.month = Int(decode.tMonth)
    dateT.day = Int(decode.tDay)

    let calandarTransit = Calendar(identifier: .gregorian).date(from: dateT)
    let dateTransit = calandarTransit.unsafelyUnwrapped

    return (decode, dateNatal, dateTransit)
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
