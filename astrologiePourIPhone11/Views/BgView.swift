//
// Created by Stéphane on 30.01.22.
//

import Foundation
import SwiftUI

struct BgView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var screenSize: CGRect = UIScreen.main.bounds
    var body: some View {
        if screenSize.width == 414 && screenSize.height == 736 {
            // iPhone 8 Plus 7 Plus 6 Plus
            Image(colorScheme == .light ? "bgl8s7s6s" : "bgd8s7s6s")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.3)
        } else if screenSize.width == 375 && screenSize.height == 667  {
            // iPhone 8 7 6
            Image(colorScheme == .light ? "bgl876" : "bgd876")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.3)
        } else if screenSize.width == 1024 && screenSize.height == 1366 {
            // iPad Pro
            Image(colorScheme == .light ? "bgliPadPro" : "bgdiPadPro")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.3)

        } else {
            //
            Image(colorScheme == .light ? "bgl" : "bgd")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .edgesIgnoringSafeArea(.all)
                    .opacity(0.3)
        }
    }
}

