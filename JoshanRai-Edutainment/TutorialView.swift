//
//  TutorialView.swift
//  EdutainmentTest
//
//  Created by Joshan Rai on 3/2/22.
//

import SwiftUI

struct TutorialView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            VStack {
                VStack {
                    Text("How to Play")
                        .font(.title)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.thickMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    HStack {
                        VStack(spacing: 10) {
                            Text("1. Select 'New Game' from the game menu.")
                                .font(.body)
                                .padding(36)
                                .frame(maxWidth: .infinity)
                                .background(.regularMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                            Text("3. Use the picker to select the amount of questions to be asked.")
                                .font(.body)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(.regularMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxHeight: 300)
                        VStack(spacing: 10) {
                            Text("2. Use the stepper (+/- buttons) to select which multiplication tables to practice up to.")
                                .font(.body)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(.regularMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                            Text("4. Press the 'Start Game' button at the bottom of 'New Game Menu'.")
                                .font(.body)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(.regularMaterial)
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxHeight: 300)
                    }
                    Text("When in-game, you will be asked a question like 'What is 6 x 8 ?'. \nSelect the correct answer to advance!")
                        .font(.body)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.regularMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                    Text("Selecting the incorrect answer will move your progress back by one question and show you the correct answer.")
                        .font(.body)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(.regularMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                }
            }
        }
        .navigationTitle("How to Play")
        .navigationBarTitleDisplayMode(.inline)
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

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView()
    }
}
