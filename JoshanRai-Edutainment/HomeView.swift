//
//  HomeView.swift
//  JoshanRai-Edutainment
//
//  Created by Joshan Rai on 3/1/22.
//

import SwiftUI

//  Splash Screen made with help from https://mobiraft.com/ios/swiftui/how-to-add-splash-screen-in-swiftui/
struct SplashView: View {
    @State var isActive = false
    
    var body: some View {
        ZStack {
            //  Background
            LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            VStack {
                if isActive {
                    HomeView()
                } else {
                    VStack(spacing: 10) {
                        Image("MultiplicationSignGraphic")
                            .resizable()
                            .frame(width: 180.0, height: 180.0, alignment: .center)
                        Text("Edutainment")
                            .font(.largeTitle.bold())
                            .shadow(color: .white, radius: 18, x: 0, y: 0)
                        Text("An app for kids")
                            .font(.footnote.monospaced())
                    }
                }
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.3) {
                withAnimation {
                    isActive = true
                }
            }
        }
    }
}

struct HomeView: View {
    ///@StateObject var settings = Settings()
    
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
                    VStack(spacing: 10) {
                        Image("MultiplicationSignGraphic")
                            .resizable()
                            .frame(width: 180.0, height: 180.0, alignment: .center)
                        Text("Edutainment")
                            .font(.largeTitle.bold())
                            .shadow(color: .white, radius: 18, x: 0, y: 0)
                        Text("An app for kids")
                            .font(.footnote.monospaced())
                    }
                    
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
            /*
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {}) {
                        Image(systemName: "line.horizontal.3")
                            .padding(.horizontal)
                    }
                }
            }
             */
        }
        .tint(.primary)
        ///.environmentObject(settings)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
