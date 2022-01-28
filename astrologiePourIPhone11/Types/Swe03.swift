//
// Created by Stéphane on 18.01.22.
//
// The functions swe_calc_ut() and swe_calc()
//
// Before calling one of these functions or any other Swiss Ephemeris function,
// it is strongly recommended to call the function swe_set_ephe_path(). Even if
// you don’t want to set an ephemeris path and use the Moshier ephemeris, it is
// nevertheless recommended to call swe_set_ephe_path(NULL), because this
// function makes important initializations. If you don’t do that, the Swiss
// Ephemeris may work but the results may be not 100% consistent.
//

import Foundation

class Swe03 {
    struct CalcUt{
        var longitude: Double
        var latitude: Double
        var distanceAu: Double
        var speedLongitude: Double
        var speedLatitude: Double
        var speedDistanceAu: Double
        var status: Int32
        var serr: String
        var split: Swe17.SplitDeg
    }

    func calc_ut(tjdUt: Double, ipl: Swe.Bodies, iflag: Swe.OptionalFlag) -> CalcUt {
        let xxPtr = UnsafeMutablePointer<Double>.allocate(capacity: 6)
        let serrPtr = UnsafeMutablePointer<Int8>.allocate(capacity: 255)
        let status: Int32
        // TODO make proper Node South/True later
        if ipl == Swe.Bodies.southNode {
            status = swe_calc_ut(tjdUt, Swe.Bodies.trueNode.rawValue, iflag.rawValue, xxPtr, serrPtr)
        } else {
            status = swe_calc_ut(tjdUt, ipl.rawValue, iflag.rawValue, xxPtr, serrPtr)
        }
        // TODO make proper Node South/True later
        if ipl == Swe.Bodies.southNode {
            xxPtr[0] += 180.0
            if xxPtr[0] >= 360.0 {
                xxPtr[0] -= 360.0
            }
        }
        let swe17 = Swe17()
        let splitdeg = swe17.split_deg(ddeg: xxPtr[0], roundflag: 0)
        let res = CalcUt(
                longitude: xxPtr[0],
                latitude: xxPtr[1],
                distanceAu: xxPtr[2],
                speedLongitude: xxPtr[3],
                speedLatitude: xxPtr[4],
                speedDistanceAu: xxPtr[5],
                status: status,
                serr: String(cString: serrPtr),
                split: splitdeg)
        free(xxPtr)
        free(serrPtr)
        return res
    }
}