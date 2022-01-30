//
// Created by Stéphane on 27.01.22.
//

import Foundation
import SwiftUI
import CoreLocation

struct AstrologieInputsTransitView: View {
    @Binding var selectedDate: Date
    @Binding var lat: Double
    @Binding var lng: Double
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
    private func localize() {
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
    }
    var body: some View {
        ZStack {
            BgView()
            VStack {
                HStack {
                    Spacer()
                    VStack {
                        Image("transit")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(minWidth: 0, maxWidth: .infinity)
                                .frame(height: 100)
                        DatePicker(
                                    "Date de naissance",
                                    selection: $selectedDate,
                                    displayedComponents: [.date, .hourAndMinute]
                            )
                                    .font(.system(size: FONTSIZE, weight: .light, design: .default))
                            HStack {
                                Text("Lat")
                                TextField(
                                        "Latitude",
                                        value: $lat,
                                        formatter: formatter
                                )
                                        .focused($swlat)
                                        .keyboardType(.decimalPad)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .foregroundColor(colorScheme == .light ? .black : .white)
                                Text("Lng")
                                TextField(
                                        "Longitude",
                                        value: $lng,
                                        formatter: formatter
                                )
                                        .focused($swlng)
                                        .keyboardType(.decimalPad)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                if CLLocationManager.authorizationStatus() == .restricted
                                           || CLLocationManager.authorizationStatus() == .denied {

                                } else {
                                    Button(action: {
                                        if (CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                                                CLLocationManager.authorizationStatus() == .authorizedAlways) {
                                            let locationManager = CLLocationManager()
                                            locationManager.requestWhenInUseAuthorization()
                                            var currentLoc: CLLocation!
                                            currentLoc = locationManager.location
                                            swlat = false
                                            swlng = false
                                            lat = currentLoc.coordinate.latitude
                                            lng = currentLoc.coordinate.longitude
                                        }
                                    }, label: {
                                        ZStack {
                                            Spacer()
                                                    .frame(width: 150, height: 50)
                                                    .background(.orange).opacity(0.1)
                                                    .clipShape(RoundedRectangle(cornerRadius: 12))
                                            if colorScheme == .light {
                                                Image("bouton")
                                                        .resizable()
                                                        .frame(width: 150, height: 50)
                                                        .opacity(0.3)
                                            }
                                            Text("Position actuel")
                                        }
                                                .frame(width: 150, height: 50)
                                                .overlay(RoundedRectangle(cornerRadius: 10)
                                                        .stroke(lineWidth: 1)
                                                        .foregroundColor(colorScheme == .light ? .black : .white))
                                    })

                                }
                            }
                        HStack {
                            if swlat || swlng {
                                ZStack {
                                    Spacer()
                                            .frame(width: 150, height: 50)
                                            .background(.orange).opacity(0.1)
                                            .clipShape(RoundedRectangle(cornerRadius: 12))
                                    Button("Close keyboard") {
                                        swlat = false
                                        swlng = false
                                    }
                                            .foregroundColor(colorScheme == .light ? .black : .white)
                                            .padding()
                                            .frame(width: 150, height: 50)
                                            .overlay(RoundedRectangle(cornerRadius: 10)
                                                    .stroke(lineWidth: 1)
                                                    .foregroundColor(colorScheme == .light ? .black : .white))

                                }

                            }
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
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                        .foregroundColor(colorScheme == .light ? .black : .white)
                                        .font(.system(size: FONTSIZE, weight: .light, design: .default))
                                        .pickerStyle(WheelPickerStyle())
                            }
                            //     .font(.system(size: FONTSIZE, weight: .light, design: .default))
                    }
                            .padding()
                    Spacer()
                    }
                    Spacer()
                }
            }
                .padding()
                .onAppear(perform: localize)
        }
    }
