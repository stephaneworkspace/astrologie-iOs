//
// Created by Stéphane on 18.01.22.
//

import Foundation

class Swe17 {
    struct SplitDeg {
        var print: String
        var deg: Int32
        var min: Int32
        var sec: Int32
        var cdegfr: Double
        var sign: Signs
        var result: Double
    }

    func split_deg(ddeg: Double, roundflag: Int32) -> SplitDeg {
        let signCalc = (ddeg / 30.0).rounded(.down)
        let houseCalc = (ddeg / 30.0).rounded(.down)
        let long30 = (houseCalc * 30) - ddeg;
        let degPtr = UnsafeMutablePointer<Int32>.allocate(capacity: 1)
        let minPtr = UnsafeMutablePointer<Int32>.allocate(capacity: 1)
        let secPtr = UnsafeMutablePointer<Int32>.allocate(capacity: 1)
        let cdegfrPtr = UnsafeMutablePointer<Double>.allocate(capacity: 1)
        let isgnPtr = UnsafeMutablePointer<Int32>.allocate(capacity: 1)
        let result = swe_split_deg(long30, roundflag, degPtr, minPtr, secPtr, cdegfrPtr, isgnPtr)
        let print = "\(abs(degPtr[0]))°\(minPtr[0])\'\(secPtr[0])"
        var sign = Signs.aries
        for pos in 1...12 {
            let signTemp: Signs = Signs.init(rawValue: Int32(signCalc) + 1) ?? Signs.aries
            if pos == signTemp.rawValue {
                sign = signTemp
                break
            }
        }
        return SplitDeg(
                print: print,
                deg: degPtr[0],
                min: minPtr[0],
                sec: secPtr[0],
                cdegfr: cdegfrPtr[0],
                sign: sign,
                result: result)
    }
}