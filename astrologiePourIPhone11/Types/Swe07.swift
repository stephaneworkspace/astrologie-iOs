//
// Created by Stéphane on 18.01.22.
//
// Eclipses, risings, settings, meridian transits, planetary phenomena
//

import Foundation

class Swe07 {
    struct PhenoUt {
        var phaseAngle: Double
        var phaseIlluminated: Double
        var elongationOfPlanet: Double
        var apparentDimaeterOfDisc: Double
        var apparentMagnitude: Double
        var status: Int
        var serr: String
    }

    func pheno_ut(tjdUt: Double, ipl: Bodies, iFlag: OptionalFlag) -> PhenoUt {
        let attrPtr = UnsafeMutablePointer<Double>.allocate(capacity: 20)
        let serrPtr = UnsafeMutablePointer<Int8>.allocate(capacity: 255)
        let status = swe_pheno_ut(
                tjdUt,
                ipl.rawValue,
                iFlag.rawValue,
                attrPtr,
                serrPtr)
        return PhenoUt(
                phaseAngle: attrPtr[0],
                phaseIlluminated: attrPtr[1],
                elongationOfPlanet: attrPtr[2],
                apparentDimaeterOfDisc: attrPtr[3],
                apparentMagnitude: attrPtr[4],
                status: Int(status),
                serr: String(cString: serrPtr))
    }
}
