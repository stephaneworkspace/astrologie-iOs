//
// Created by Stéphane on 26.01.22.
//

import Foundation
import SwiftUI

struct BodieSelectView: View {
    @Binding var swBodie: [Bool]
    @Binding var swPluton: Bool
    @Binding var swNode: Bool
    @Binding var swChiron: Bool
    @Binding var swCeres: Bool
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    let forlopp: [Int] = [0, 1, 2, 3, 4, 5, 6, 7, 8]
    let forloppStr: [String] = ["Soleil", "Lune", "Mercure", "Venus", "Mars", "Jupiter", "Saturn", "Uranus", "Neptune"]

    var body: some View {
        ZStack {
            BgView()
            ScrollView {
                VStack {
                    VStack {
                        HStack {
                        }.frame(height: 40) // TODO ok pour iphone11 les autres je ne sais pas
                        Spacer()
                        ForEach(forlopp, id: \.self) { idx in
                            HStack {
                                Toggle(forloppStr[idx], isOn: $swBodie[idx])
                                Image("b" + String(idx))
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                        .padding()
                            }
                        }
                        HStack {
                            Toggle("Pluton", isOn: $swPluton)
                            Image("b9")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .padding()
                        }
                        HStack {
                            Toggle("Noeud lunaire", isOn: $swNode)
                            Image("b11")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .padding()
                        }
                        HStack {
                            Toggle("Chiron", isOn: $swChiron)
                            Image("b15")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .padding()
                        }
                        HStack {
                            Toggle("Ceres", isOn: $swCeres)
                            Image("b17")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .padding()
                        }
                        Spacer()
                        HStack {
                        }.frame(height: 50) // TODO ok pour iphone11 les autres je ne sais pas
                    }
                }.padding()
            }
        }
    }
}