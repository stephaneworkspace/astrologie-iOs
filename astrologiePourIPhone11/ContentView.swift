//
//  ContentView.swift
//  astrologiePourIPhone11
//
//  Created by Stéphane on 18.01.22.
//

import SwiftUI

func swe() -> String {
    let swe = Swe()
    return swe.bodies[0].calculUt.longitude.formatted()
}

struct ContentView: View {
    let size = 100
    let mult = 3
    let s = 300.0
    let b = 1.0
    var body: some View {
        ZStack {
            VStack {
                Text("Astrologie").padding()
                Circle()
                        .stroke(.black)
                        .frame(width: s, height: s)
                Text("Éphémérides").padding()
            }.frame(width: .infinity, height: .infinity)

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
