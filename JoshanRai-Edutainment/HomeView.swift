//
//  ContentView.swift
//  EdutainmentTest
//
//  Created by Joshan Rai on 3/2/22.
//

import SwiftUI

struct CapsuleButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: 200)
            .padding(12)
            .foregroundColor(.black)
            .background(.orange)
            .overlay(
                Capsule()
                    .stroke(.black, lineWidth: 3)
                    .shadow(color: .black, radius: 6, x: 0, y: 4)
            )
            .cornerRadius(100)
    }
}

extension View {
    func capsuleButtonStyle() -> some View {
        modifier(CapsuleButton())
    }
}

struct HomeView: View {
    var body: some View {
        //  Home Nav View
        NavigationView {
            ZStack {
                //  Background
                LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    .ignoresSafeArea()
                
                //  Title and NavLink Buttons
                VStack {
                    //  Title
                    Text("Edutainment")
                        .font(.title.bold())
                        .shadow(color: .white, radius: 18, x: 0, y: 0)
                    
                    //  Game Settings View
                    NavigationLink(destination: SettingsView()) {
                        Text("Play Game")
                            .capsuleButtonStyle()
                    }
                    .padding()
                    
                    //  Tutorial View
                    NavigationLink(destination: TutorialView()) {
                        Text("How to Play")
                            .capsuleButtonStyle()
                    }
                }
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
