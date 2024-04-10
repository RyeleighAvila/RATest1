//
//  ContentView.swift
//  Ryeleigh's Bakery
//
//  Created by Ryeleigh Avila on 4/3/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                Text("Ryeleigh's Bakery!")
                    .font(.custom("AmericanTypewriter", size: 40)) //made custom font for head title
                    .fontWeight(.heavy)
                
                NavigationLink(destination: SecondView()) {
                    Image("Bakery")
                        .frame(width: 300, height: 300)
                        .background(Color.pink)
                }
                
                Text("Press image for result of profit/loss :)")
                    .font(.system(size: 14)) // Small font size
                    .foregroundColor(.black) // Set text color to black
                    .padding(.top, 8)
                
                // Custom display
            }
            .navigationTitle("")
            .containerRelativeFrame([.horizontal, .vertical])
            .background(Gradient(colors: [.pink, .white, .pink]).opacity(0.3))
            .padding()
            // Personal design of color :)
        }
    }
}
