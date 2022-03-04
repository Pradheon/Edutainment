//
//  GameView.swift
//  EdutainmentTest
//
//  Created by Joshan Rai on 3/2/22.
//

import SwiftUI

//  Shake effect made with help from https://www.objc.io/blog/2019/10/01/swiftui-shake-animation/
struct Shake: GeometryEffect {
    var amount: CGFloat = 10
    var shakesPerUnit = 3
    var animatableData: CGFloat
    
    func effectValue(size: CGSize) -> ProjectionTransform {
        ProjectionTransform(CGAffineTransform(translationX: amount * sin(animatableData * .pi * CGFloat(shakesPerUnit)), y: 0))
    }
}

struct MaterialUnderlay: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

extension View {
    func materialUnderlayStyle() -> some View {
        modifier(MaterialUnderlay())
    }
}

struct HollowCapsuleButton: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: 200)
            .padding(12)
            .foregroundColor(Color.white)
            .background(Color.accentColor)
            .overlay(
                Capsule()
                    .stroke(Color.white, lineWidth: 3)
                    .shadow(color: .black, radius: 6, x: 0, y: 4)
            )
            .cornerRadius(100)
    }
}

extension View {
    func hollowCapsuleButtonStyle() -> some View {
        modifier(HollowCapsuleButton())
    }
}

struct GameView: View {
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var settings: Settings
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    @State private var displayAlert = false
    @State private var gameOver = false
    @State private var reset = false
    @State private var returnHome = false
    @State private var exitGame = false
    
    @State private var questionProgress: Float = 0.0
    @State private var currentQuestion = 1
    @State private var selectedOption = 0
    @State private var score = 0
    
    @State private var animationOpacity = 1.0
    @State private var animationCount = 0.0
    @State private var animationIncorrectCount = 0.0
    
    @State private var questionsArray = [Question]()
    @State private var answersArray = [Question]()
    
    var body: some View {
        ZStack {
            //let _ = debugPrint(settings.selection.rawValue)
            //  Background
            LinearGradient(gradient: Gradient(colors: [.purple, .blue]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .ignoresSafeArea()
            
            //  Game Content View
            VStack {
                //  Question View
                VStack {
                    if questionsArray.isEmpty {
                        Text("Loading...")
                    } else {
                        Text("\(questionsArray[currentQuestion].text)")
                    }
                }
                .materialUnderlayStyle()
                
                //  Answers View
                VStack(spacing: 15) {
                    ForEach(0..<4, id: \.self) { number in
                        Button {
                            withAnimation {
                                optionTapped(number)
                            }
                        } label: {
                            if answersArray.isEmpty {
                                Text("Loading...")
                            } else {
                                Text("\(answersArray[number].product)")
                                    .hollowCapsuleButtonStyle()
                            }
                        }
                        .rotation3DEffect(number == selectedOption ? .degrees(animationCount) : .degrees(0), axis: (x: 0, y: 1, z: 0))
                        .modifier(Shake(animatableData: CGFloat(animationIncorrectCount)))
                        //.rotation3DEffect(number != selectedOption ? .degrees(animationCount) : .degrees(0), axis: (x: 2, y: 0, z: 0))
                        .opacity(number != selectedOption ? animationOpacity : 1.0)
                    }
                }
                .materialUnderlayStyle()
                
                //  Score View
                Text("Score: \(score)")
                    .materialUnderlayStyle()
                
                //  Progression View
                ProgressView(value: questionProgress, total: Float(settings.selection.rawValue)!, label: {
                    Text("Progress")
                }, currentValueLabel: {
                    //let _ = debugPrint(settings.selection.rawValue)
                    Text("\(currentQuestion) of \(settings.selection.rawValue)")
                })
                    .tint(.mint)
                    .padding()
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
        .onAppear(perform: {
            createQuestions()
            createAnswers()
        })
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigation) {
                Button(action: {
                    alertTitle = "Exit Game?"
                    alertMessage = "Are you sure you want to exit the game? \nAll progress will be lost."
                    exitGame = true
                }) {
                    Image(systemName: "x.circle")
                        .foregroundColor(.primary)
                }
            }
        }
        .tint(.primary)
        .alert(alertTitle, isPresented: $displayAlert) {
            Button("Continue", action: askQuestion)
        } message: {
            Text(alertMessage)
        }
        .alert(alertTitle, isPresented: $gameOver) {
            Button("Reset") {
                resetGame()
            }
            Button("Return") {
                dismiss()
            }
        } message: {
            Text(alertMessage)
        }
        .alert(alertTitle, isPresented: $exitGame) {
            Button("Exit", role: .destructive) {
                exitTheGame()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text(alertMessage)
        }
    }
    
    func createQuestions() {
        for i in 1...settings.multiTablesUpTo {
            for j in 1...12 {
                let newQuestion = Question(text: "What is \(i) x \(j) ?", product: i * j)
                questionsArray.append(newQuestion)
            }
        }
        questionsArray.shuffle()
        answersArray = []
        currentQuestion = 0
    }
    
    func createAnswers() {
        if ((currentQuestion + 4) < questionsArray.count) {
            for item in currentQuestion...(currentQuestion + 3) {
                answersArray.append(questionsArray[item])
            }
        } else {
            for item in (questionsArray.count - 4)..<questionsArray.count {
                answersArray.append(questionsArray[item])
            }
        }
        answersArray.shuffle()
    }
    
    func optionTapped(_ number: Int) {
        selectedOption = number
        //debugPrint(settings.selection.rawValue)
        let progression = Float(Float(currentQuestion) / Float(settings.selection.rawValue)!) * 2
        //Float(((Float(currentQuestion) / Float(settings.selection.rawValue)!) * Float(settings.selection.rawValue)!) / 10)
        
        if answersArray[number].product == questionsArray[currentQuestion].product {
            questionProgress += progression
            score += 1
            alertTitle = "Hurray!"
            alertMessage = "You got it right. \n🥳"
            
            withAnimation(.easeInOut(duration: 1.5)) {
                animationCount += 360
            }
        } else {
            if score == 0 {
                score = 0
            } else {
                score -= 1
            }
            alertTitle = "Oh no!"
            alertMessage = "You got it wrong. \n😢"
            
            withAnimation(.easeInOut) {
                animationIncorrectCount += 1
                animationOpacity = 0.25
            }
        }
        
        displayAlert = true
    }
    
    func askQuestion() {
        //let _ = debugPrint(settings.selection.rawValue)
        if currentQuestion == Int(settings.selection.rawValue) {
            gameOver = true
            resetGame()
        } else {
            currentQuestion += 1
            answersArray = []
            createAnswers()
        }
    }
    
    func resetGame() {
        alertTitle = "Game Over"
        alertMessage = "Great Job! \nYou got \(score) of \(settings.selection.rawValue) correct. \nReset or Return to Home?"
        
        questionsArray = []
        answersArray = []
        currentQuestion = 1
        score = 0
        
        createQuestions()
        createAnswers()
    }
    
    func exitTheGame() {
        dismiss()
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(settings: Settings())//.environmentObject(Settings())
    }
}
