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
                         \n
                         Cette application est sous license GNU public license version 3.\n
                         \n
                         Elle utilise la libraiaire swiss ephemeris developé parDieter Koch and Alois Treindl en Dual license(GNU v2 ou supérieur / commercial)\n
                         \nAinsi que le package swift Zip en MIT par Roy Marmelstein
                         """)
                }
            }.padding()
        }
    }
}
