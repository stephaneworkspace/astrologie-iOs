//
// Created by Stéphane on 18.01.22.
//

import Foundation

class Swe14 {
    struct House {
        var objectId: Int32
        var longitude: Double
        var split: Swe17.SplitDeg
        var angle: Angle
    }

    struct HouseResult {
        var cusps: [Double]
        var ascmc: [Double]
        var result: Int32
    }

    func houses(tjdUt: Double, geoLat: Double, geoLong: Double, hsys: CChar) -> [House] {
        let cuspsPtr = UnsafeMutablePointer<Double>.allocate(capacity: 37)
        let ascmcPtr = UnsafeMutablePointer<Double>.allocate(capacity: 10)
        let _ = swe_houses_ex(tjdUt, 0, geoLat, geoLong, Int32(hsys), cuspsPtr, ascmcPtr)
        var house: [House] = []
        for pos in 1...12 {
            var angle = Angle.nothing
            if pos == 1 {
                angle = Angle.asc
            }
            if pos == 4 {
                angle = Angle.fc
            }
            if pos == 7 {
                angle = Angle.desc
            }
            if pos == 10 {
                angle = Angle.mc
            }
            house.append(House.init(objectId: Int32(pos), longitude: cuspsPtr[pos], angle: angle))
        }
        return house
    }
}


extension Swe14.House {
    init(objectId: Int32, longitude: Double, angle: Angle) {
        let swe17 = Swe17()
        let splitdeg = swe17.split_deg(ddeg: longitude, roundflag: 0)
        self.init(objectId: objectId, longitude: longitude, split: splitdeg, angle: angle)
    }
}
