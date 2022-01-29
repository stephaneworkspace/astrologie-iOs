//
// Created by Stéphane on 27.01.22.
//

import Foundation
import SwiftUI

struct AstrologieInputsTransitView: View {
    @Binding var swLock: Bool
    @Binding var selectedDate: Date
    @Binding var lat: Double
    @Binding var lng: Double
    @State var latC: Double = loadDefaultValue().0.tLat
    @State var lngC: Double = loadDefaultValue().0.tLng
    @Binding var tz: Int
    @FocusState private var swlat: Bool
    @FocusState private var swlng: Bool
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
        ZStack {
            Image(colorScheme == .light ? "bgl" : "bgd")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.3)
            VStack {
                HStack {
                    Spacer()
                    VStack {
                            Text("Transit")
                            DatePicker(
                                    "Date de naissance",
                                    selection: $selectedDate,
                                    displayedComponents: [.date, .hourAndMinute]
                            )
                                    .disabled(swLock)
                                    .font(.system(size: FONTSIZE, weight: .light, design: .default))
                            HStack {
                                Text("Lat")
                                TextField(
                                        "Latitude",
                                        value: $latC,
                                        formatter: formatter
                                )
                                        .disabled(swLock)
                                        .focused($swlat)
                                        .keyboardType(.decimalPad)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .foregroundColor(colorScheme == .light ? .black : .white)
                                Text("Lng")
                                TextField(
                                        "Longitude",
                                        value: $lngC,
                                        formatter: formatter
                                )
                                        .disabled(swLock)
                                        .focused($swlng)
                                        .keyboardType(.decimalPad)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            HStack {
                                Text("Timezone")
                                Picker("Timezone", selection: $tz, content: {
                                    ForEach(-12...0, id: \.self) { idx in
                                        if idx != 0 {
                                            Text("GMT " + idx.formatted()).tag(idx)
                                        }
                                    }
                                    ForEach(0...12, id: \.self) { idx in
                                        Text("GMT +" + idx.formatted()).tag(idx)
                                    }
                                })
                                        .disabled(swLock)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .foregroundColor(colorScheme == .light ? .black : .white)
                                        .font(.system(size: FONTSIZE, weight: .light, design: .default))
                                        .pickerStyle(WheelPickerStyle())
                            }
                            //     .font(.system(size: FONTSIZE, weight: .light, design: .default))
                            HStack {
                                if swlat || swlng {
                                    Button("Close keyboard") {
                                        swlat = false
                                        swlng = false
                                    }
                                            .foregroundColor(colorScheme == .light ? .black : .white)
                                            .padding()
                                            .cornerRadius(10)
                                            .border(colorScheme == .light ? .black : .white, width: 1)
                                            .background(!swLock ? .orange : .white)
                                }
                                Button("Valider") {
                                    swlat = false
                                    swlng = false
                                    lat = latC
                                    lng = lngC
                                    swLock = true
                                }
                                        .disabled(swLock)
                                        .foregroundColor(colorScheme == .light ? .black : .white)
                                        .padding()
                                        .cornerRadius(10)
                                        .border(colorScheme == .light ? .black : .white, width: 1)
                                        .background(!swLock ? .orange : .white)
                                Button("Dévalider") {
                                    swLock = false
                                }
                                        .disabled(swLock == false)
                                        .foregroundColor(colorScheme == .light ? .black : .white)
                                        .padding()
                                        .cornerRadius(10)
                                        .border(colorScheme == .light ? .black : .white, width: 1)
                                        .background(swLock ? .orange : .white)
                            }
                    }
                            .padding()
                    }
                    Spacer()
                }
            }
                    .padding()
        }
    }