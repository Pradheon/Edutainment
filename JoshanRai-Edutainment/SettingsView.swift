//
//  GameSettingsView.swift
//  EdutainmentTest
//
//  Created by Joshan Rai on 3/2/22.
//

import SwiftUI

struct SettingsView: View {
    @StateObject var settings = Settings()
    
    var body: some View {
        VStack {
            Form {
                //  Multiplication Tables Up To Section
                Section {
                    Stepper(value: $settings.multiTablesUpTo, in: 1...12) {
                        Text("\(settings.multiTablesUpTo)")
                    }
                }
                
                //  Questions Amount Section
                Section {
                    Picker("Amount of Questions", selection: $settings.selection) {
                        let _ = debugPrint(settings.selection.rawValue)
                        ForEach(settings.numQuestionsIndex) { value in
                            Text(value.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
            
            //  Game View NavLink
            NavigationLink(destination: GameView(settings: settings)) {
                Text("Start Game")
                    .capsuleButtonStyle()
            }
        }
        .background(Color.gray.opacity(0.25))
        .environmentObject(settings)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
