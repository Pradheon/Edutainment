//
//  TutorialView.swift
//  JoshanRai-Edutainment
//
//  Created by Joshan Rai on 3/1/22.
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
                    Spacer()
                    
                    Text("How to Play")
                        .titleFontAndAutoPadding()
                        .roundedRectangleThickMaterial()
                    
                    HStack {
                        VStack(spacing: 10) {
                            Text("1. Select 'New Game' from the game menu.")
                                .font(.body)
                                .padding(36)
                                .roundedRectangleRegularMaterial()
                            Text("3. Use the picker to select the amount of questions to be asked.")
                                .bodyFontAndAutoPadding()
                                .roundedRectangleRegularMaterial()
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxHeight: 300)
                        VStack(spacing: 10) {
                            Text("2. Use the stepper (+/- buttons) to select which multiplication tables to practice up to.")
                                .bodyFontAndAutoPadding()
                                .roundedRectangleRegularMaterial()
                            Text("4. Press the 'Start Game' button at the bottom of 'New Game Menu'.")
                                .bodyFontAndAutoPadding()
                                .roundedRectangleRegularMaterial()
                        }
                        .fixedSize(horizontal: false, vertical: true)
                        .frame(maxHeight: 300)
                    }
                    
                    Text("How to Win")
                        .titleFontAndAutoPadding()
                        .roundedRectangleThickMaterial()
                    VStack {
                        Text("When in-game, you will be asked a question like 'What is 6 x 8 ?'. \nSelect the correct answer to advance and get a point!")
                            .bodyFontAndAutoPadding()
                            .roundedRectangleRegularMaterial()
                        Text("Selecting the incorrect answer will decrease your score back by one point.")
                            .bodyFontAndAutoPadding()
                            .roundedRectangleRegularMaterial()
                        Text("Get all of the answers correct to win!")
                            .bodyFontAndAutoPadding()
                            .roundedRectangleRegularMaterial()
                    }
                    Spacer()
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
