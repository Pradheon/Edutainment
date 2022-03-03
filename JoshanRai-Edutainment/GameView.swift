//
//  GameView.swift
//  EdutainmentTest
//
//  Created by Joshan Rai on 3/2/22.
//

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
            .foregroundColor(.black)
            .background(.clear)
            .overlay(
                Capsule()
                    .stroke(.black, lineWidth: 3)
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

import SwiftUI

struct GameView: View {
    @ObservedObject var settings: Settings
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    @State private var displayAlert = false
    @State private var gameOver = false
    @State private var reset = false
    @State private var returnHome = false
    
    @State private var questionProgress: Float = 0.0
    @State private var currentQuestion = 0
    @State private var selectedOption = 0
    @State private var score = 0
    
    @State private var animationOpacity = 1.0
    @State private var animationCount = 0.0
    
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
                        .rotation3DEffect(number != selectedOption ? .degrees(animationCount) : .degrees(0), axis: (x: 2, y: 0, z: 0))
                        .opacity(number != selectedOption ? animationOpacity : 1.0)
                    }
                }
                .materialUnderlayStyle()
                
                //  Progression View
                ProgressView(value: questionProgress, label: {
                    Text("Progress")
                }, currentValueLabel: {
                    //let _ = debugPrint(settings.selection.rawValue)
                    Text("\(currentQuestion) of \(settings.selection.rawValue)")
                })
                    .padding()
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                
                //  Score View
                Text("Score: \(score)")
                    .materialUnderlayStyle()
            }
        }
        .onAppear(perform: {
            createQuestions()
            createAnswers()
        })
        .alert(alertTitle, isPresented: $displayAlert) {
            Button("Continue", action: askQuestion)
        } message: {
            Text(alertMessage)
        }
        .alert(alertTitle, isPresented: $gameOver) {
            Button("Reset", action: resetGame)
            NavigationLink("Return", destination: HomeView())
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
        let progression = Float(Float(currentQuestion) / Float(settings.selection.rawValue)!)
        
        if answersArray[number].product == questionsArray[currentQuestion].product {
            questionProgress += progression
            score += 1
            alertTitle = "Hurray!"
            alertMessage = "You got it right. \n🥳"
            
            withAnimation {
                animationCount += 360
            }
        } else {
            score -= 1
            alertTitle = "Oh no!"
            alertMessage = "You got it wrong. \n😢"
            
            withAnimation {
                animationCount += 360
            }
        }
        
        displayAlert = true
    }
    
    func askQuestion() {
        let _ = debugPrint(settings.selection.rawValue)
        if currentQuestion == Int(settings.selection.rawValue) {
            resetGame()
        } else {
            currentQuestion += 1
            answersArray = []
            createAnswers()
        }
    }
    
    func resetGame() {
        gameOver = true
        
        alertTitle = "Game Over"
        alertMessage = "Great Job! \nReset or Return to Home?"
        
        questionsArray = []
        answersArray = []
        currentQuestion = 0
        
        createQuestions()
        createAnswers()
    }
}

struct GameView_Previews: PreviewProvider {
    static var previews: some View {
        GameView(settings: Settings())//.environmentObject(Settings())
    }
}
