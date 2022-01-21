//
//  ContentView.swift
//  astrologiePourIPhone11
//
//  Created by Stéphane on 18.01.22.
//

import SwiftUI

struct ContentView: View {
    var chart: Swe.Chart = load_default_value()
    var body: some View {
        ZStack {
            VStack {
                Text("Astrologie").padding()
                ChartView(swe: Swe(chart: chart))
            }
        }
    }
}

private func load_default_value() -> Swe.Chart {
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
    return decode
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
