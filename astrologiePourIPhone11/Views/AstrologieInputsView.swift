//
// Created by Stéphane on 27.01.22.
//

import Foundation
import SwiftUI

struct AstrologieInputsView: View {
    @Binding var swTransit: Bool
    @Binding var selectedDate: Date
    @Binding var selectedDateTransit: Date
    @Binding var latNatal: Double
    @Binding var lngNatal: Double
    @Binding var latTransit: Double
    @Binding var lngTransit: Double
    @Binding var tzNatal: Int32
    @Binding var tzTransit: Int32
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
    var FONTSIZE = 15.0
    var body: some View {
        VStack {
            DatePicker(
                    "Date de naissance",
                    selection: $selectedDate,
                    displayedComponents: [.date, .hourAndMinute])
                    .font(.system(size: FONTSIZE, weight: .light, design: .default))
            HStack {
                Text("Lat")
                TextField(
                        "Latitude",
                        value: $latNatal,
                        formatter: formatter
                ).textFieldStyle(RoundedBorderTextFieldStyle())
                Text("Lng")
                TextField(
                        "Longitude",
                        value: $lngNatal,
                        formatter: formatter
                ).textFieldStyle(RoundedBorderTextFieldStyle())
                Text("Tz")
                TextField(
                        "Timezone",
                        value: $tzNatal,
                        formatter: formatterNoFloat
                ).textFieldStyle(RoundedBorderTextFieldStyle())
            }.font(.system(size: FONTSIZE, weight: .light, design: .default))
            if swTransit {
                DatePicker(
                        "Transit",
                        selection: $selectedDateTransit,
                        displayedComponents: [.date, .hourAndMinute])
                        .font(.system(size: FONTSIZE, weight: .light, design: .default))
                HStack {
                    Text("Lat")
                    TextField(
                            "Latitude",
                            value: $latTransit,
                            formatter: formatter
                    ).textFieldStyle(RoundedBorderTextFieldStyle())
                    Text("Lng")
                    TextField(
                            "Longitude",
                            value: $lngTransit,
                            formatter: formatter
                    ).textFieldStyle(RoundedBorderTextFieldStyle())
                    Text("Tz")
                    TextField(
                            "Timezone",
                            value: $tzNatal,
                            formatter: formatterNoFloat
                    ).textFieldStyle(RoundedBorderTextFieldStyle())
                }.font(.system(size: FONTSIZE, weight: .light, design: .default))
            }

        }.padding()

    }
}
