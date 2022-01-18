//
//  ContentView.swift
//  astrologiePourIPhone11
//
//  Created by Stéphane on 18.01.22.
//

import SwiftUI

func swe() -> String {
    let swe02 = Swe02()
    // swe02.version()
    swe02.set_ephe_path()
    let path = swe02.get_library_path()
    print("final: " + path)
    let lat = 0.0
    let lng = 0.0
    let swe08: Swe08 = Swe08()
    let julday = swe08.julday(year: 2021, month: 1, day: 24, hour: 0.0, calandar: .gregorian)
    let swe03 = Swe03()
    let bodie = swe03.calc_ut(tjdUt: julday, ipl: .sun, iflag: .speed)
    print(bodie)
    let swe07 = Swe07()
    let phenoUt = swe07.pheno_ut(tjdUt: julday, ipl: .sun, iFlag: .speed)
    // print(phenoUt)
    var utcTimeZone = TimeZone(year: 2021, month: 1, day: 24, hour: 0, min: 0, sec: 0.0)
    utcTimeZone.utc_time_zone(timezone: 2.0)

    let utcToJd = swe08.utc_to_jd(tz: utcTimeZone, calandar: .gregorian)
    // print(utcToJd)

    let swe14 = Swe14()
    let houses = swe14.houses(
            tjdUt: utcToJd.julianDayUt,
            geoLat: lat,
            geoLong: lng,
            hsys: CChar("W") ?? CChar.init())
    /*for house in houses {
        print(house)
    }*/
    swe02.close()
    return bodie.latitude.formatted() + " " + bodie.longitude.formatted()
}

struct ContentView: View {
    var body: some View {
        Text("Hello, world: " + swe())
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
