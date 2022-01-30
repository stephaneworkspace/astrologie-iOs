//
// Created by Stéphane on 26.01.22.
//

import Foundation
import SwiftUI

struct BodieSelectView: View {
    @Binding var swPluton: Bool
    @Binding var swNode: Bool
    @Binding var swChiron: Bool
    @Binding var swCeres: Bool
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    var body: some View {
        ZStack {
            BgView()
            VStack {
                VStack {
                    Spacer()
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
                }
            }.padding()
        }
    }
}
