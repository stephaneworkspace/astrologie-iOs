//
// Created by Stéphane on 26.01.22.
//

import Foundation
import SwiftUI

struct BodieSelectView: View {
    @Binding var swChiron: Bool
    @Binding var swCeres: Bool
    @Binding var swRefresh: Bool
    @Binding var timeRemaining: Int

    var body: some View {
        ZStack {
            Image("bgl")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.3)
            VStack {
                Spacer()
                HStack {
                    Toggle("Ceres", isOn: $swCeres).onChange(of: swCeres, perform: { value in
                        timeRemaining = 1
                        swRefresh = true
                    })
                    Image("b17").padding()
                    Toggle("Chiron", isOn: $swChiron).onChange(of: swChiron, perform: { value in
                        timeRemaining = 1
                        swRefresh = true
                    })
                    Image("b15").padding()
                }
                Spacer()
            }.padding()
        }
    }
}
