//
//  ContentView.swift
//  astrologiePourIPhone11
//
//  Created by Stéphane on 18.01.22.
//

import SwiftUI
import Foundation


struct ContentView: View {
    @State var selected: Int
    @State var swRefresh: Bool = false
    @State var timeRemaining = 2
    @State var isActive: Bool = false
    @State var swChiron: Bool = true
    @State var swCeres: Bool = true

    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack {
            if self.isActive {
                ZStack {
                    Image("bgl")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .edgesIgnoringSafeArea(.all)
                    VStack {
                        TabView(selection: $selected) {
                            VStack {
                                if swRefresh == false {
                                    AstrologieView(
                                            swTransit: false,
                                            swChiron: $swChiron,
                                            swCeres: $swCeres
                                    )
                                } else {
                                    Text("\(timeRemaining)")
                                            .onReceive(timer) { _ in
                                                if timeRemaining > 0 {
                                                    timeRemaining -= 1
                                                } else {
                                                    timeRemaining = 2
                                                    swRefresh = false
                                                }
                                            }
                                }
                            }.tabItem {
                                VStack {
                                    Image(systemName: "eye")
                                    Text("Natal")
                                }
                            }.tag(0)
                            AstrologieView(
                                    swTransit: true,
                                    swChiron: $swChiron,
                                    swCeres: $swCeres
                            ).tabItem {
                                VStack {
                                    Image(systemName: "eye")
                                    Text("Natal et Transit")
                                }
                            }.tag(1)
                            BodieSelectView(
                                    swChiron: $swChiron,
                                    swCeres: $swCeres,
                                    swRefresh: $swRefresh,
                                    timeRemaining: $timeRemaining
                            ).tabItem {
                                VStack {
                                    Image(systemName: "c.circle.fill")
                                    Text("Sélection planètes")
                                }
                            }.tag(2)
                            VStack {
                                Text("Développé par bressani.dev (Stéphane Bressani)")
                                Text("Cette application est sous license GNU public license version 3.")
                                Text("Elle utilise la libraiaire swiss ephemeris developé par Dieter Koch and Alois Treindl en Dual license (GNU v2 ou supérieur ou commercial)")
                                Text("Cette application utilise aussi le package swift Zip en MIT par Roy Marmelstein")
                            }.tabItem {
                                VStack {
                                    Image(systemName: "info.circle")
                                    Text("À propos")
                                }
                            }.tag(3)
                        }.onAppear() {
                            UITabBar.appearance().barTintColor = UIColor(Color(hex: "aa9966"))
                            UITabBar.appearance().unselectedItemTintColor = .systemGray5
                        }.accentColor(.white)
                    }
                }
            } else {
                Image("splash")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(minWidth: 0, maxWidth: .infinity)
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .onAppear {
            // 6.
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                // 7.
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}


extension TabView {
    func myTabViewStyle() -> some View {
        self.background(Image("bgl"))              // Replace 'BackgroundImage' with your image name
                // or   self.background(Image(systemName: "questionmark.square"))
                .frame(width: 200, height: 500, alignment: .top)   // Optional, but shows the background
                .opacity(0.5)                                      // Again optional, but shows the effect

        // etc, with other View modifiers, choose the ones you need
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(selected: 0)
    }
}
