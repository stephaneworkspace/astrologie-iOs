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
    @FocusState private var swlatNatal: Bool
    @FocusState private var swlngNatal: Bool
    @FocusState private var swtzNatal: Bool
    @FocusState private var swlatTransit: Bool
    @FocusState private var swlngTransit: Bool
    @FocusState private var swtzTransit: Bool
    @Environment(\.colorScheme) var colorScheme: ColorScheme
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
                )
                        .focused($swlatNatal)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .foregroundColor(colorScheme == .light ? .black : .white)
            Text("Lng")
                TextField(
                        "Longitude",
                        value: $lngNatal,
                        formatter: formatter
                )
                        .focused($swlngNatal)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                Text("Tz")
                TextField(
                        "Timezone",
                        value: $tzNatal,
                        formatter: formatterNoFloat
                )
                        .focused($swtzNatal)
                        .keyboardType(.decimalPad)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
            }
                    .font(.system(size: FONTSIZE, weight: .light, design: .default))
            if swlatNatal || swlngNatal || swtzNatal {
                Button("Close keyboard") {
                    swlatNatal = false
                    swlngNatal = false
                    swtzNatal = false
                    swlatTransit = false
                    swlngTransit = false
                    swtzTransit = false
                }.foregroundColor(colorScheme == .light ? .black : .white)
            }
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
                    )
                            .focused($swlatTransit)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    Text("Lng")
                    TextField(
                            "Longitude",
                            value: $lngTransit,
                            formatter: formatter
                    )
                            .focused($swlngTransit)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    Text("Tz")
                    TextField(
                            "Timezone",
                            value: $tzNatal,
                            formatter: formatterNoFloat
                    )
                            .focused($swtzNatal)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                }.font(.system(size: FONTSIZE, weight: .light, design: .default))
                Button("Close keyboard") {
                    swlatNatal = false
                    swlngNatal = false
                    swtzNatal = false
                    swlatTransit = false
                    swlngTransit = false
                    swtzTransit = false
                }.foregroundColor(colorScheme == .light ? .black : .white)
            }
        }.padding()

    }
}
