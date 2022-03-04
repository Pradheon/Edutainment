//
//  GameSettingsView.swift
//  EdutainmentTest
//
//  Created by Joshan Rai on 3/2/22.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    
    @StateObject var settings = Settings()
    
    var body: some View {
        VStack {
            Form {
                //  Multiplication Tables Up To Section
                Section {
                    Stepper(value: $settings.multiTablesUpTo, in: 1...12) {
                        Text("\(settings.multiTablesUpTo)")
                    }
                } header: {
                    Text("Multiplication Tables")
                } footer: {
                    Text("Select which multiplication tables to practice.")
                }
                
                //  Questions Amount Section
                Section {
                    Picker("Amount of Questions", selection: $settings.selection) {
                        //let _ = debugPrint(settings.selection.rawValue)
                        ForEach(settings.numQuestionsIndex) { value in
                            Text(value.rawValue)
                        }
                    }
                    .pickerStyle(.segmented)
                } header: {
                    Text("Amount of Questions")
                } footer: {
                    Text("Select the amount of questions to be asked.")
                }
            }
            
            //  Game View NavLink
            NavigationLink(destination: GameView(settings: settings)) {
                Text("Start Game")
                    .capsuleButtonStyle()
            }
        }
        .navigationTitle("Game Settings")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.gray.opacity(0.25))
        .environmentObject(settings)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "arrow.left.circle")
                        .foregroundColor(.primary)
                }
            }
        }
        .tint(.primary)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
