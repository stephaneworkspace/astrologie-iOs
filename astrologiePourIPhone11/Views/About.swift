//
// Created by Stéphane on 26.01.22.
//

import Foundation
import SwiftUI

struct AboutView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    var body: some View {
        ZStack {
            BgView()
            VStack {
                Image("bressani.dev")
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                VStack(alignment: .trailing) {
                    Text("""
                         Développé par bressani.dev (Stéphane Bressani)\n
                         Cette application est sous license GNU public license version 3.\n
                         """)
                    Link("Code source", destination: URL(
                            string: "https://github.com/stephaneworkspace/astrologiePourIPhone11")!).foregroundColor(colorScheme == .light ? .black : .white)
                    VStack {}.frame(height: 10)
                    Text("""
                         Elle utilise la libraiaire swiss ephemeris developé par Dieter Koch and Alois Treindl ainsi que le package swift Zip par Roy Marmelstein
                         """)
                }
            }.padding()
        }
    }
}
