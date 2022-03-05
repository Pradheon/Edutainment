//
//  GameView.swift
//  JoshanRai-Edutainment
//
//  Created by Joshan Rai on 3/1/22.
//

import SwiftUI

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
    @State private var isCorrect = false
    
    @State private var questionProgress: Double = 0.0
    @State private var currentQuestion: Int = 0
    @State private var selectedOption: Int = 0
    @State private var score: Int = 0
    @State private var questionCount: Int = 0
    
    @State var animationOpacity: Double = 1.0
    @State var animationCount: Double = 0.0
    @State var animationIncorrectCount: Double = 0.0
    @State var confettiCounter: Int = 0
    
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
                
                if isCorrect {
                    ZStack {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 12, height: 12)
                            .modifier(ParticlesModifier())
                            .offset(x: -100, y: -60)
                        Circle()
                            .fill(Color.red)
                            .frame(width: 12, height: 12)
                            .modifier(ParticlesModifier())
                            .offset(x: 60, y: 70)
                    }
                }
                
                //  Score View
                Text("Score: \(score)")
                    .materialUnderlayStyle()
                
                //  Progression View
                ProgressView(value: questionProgress, total: 1.0, label: {
                    Text("Progress")
                }, currentValueLabel: {
                    Text("\(currentQuestion) of \(questionCount)")
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
            countOfQuestions()
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
    
    //  Functions
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
    
    @discardableResult func countOfQuestions() -> Int {
        guard let count = Int(settings.selection.rawValue) else {
            questionCount = questionsArray.count
            return questionCount
        }
        questionCount = count
        return questionCount
    }
    
    func optionTapped(_ number: Int) {
        selectedOption = number
        
        if answersArray[number].product == questionsArray[currentQuestion].product {
            isCorrect = true
            
            score += 1
            alertTitle = "Hurray!"
            alertMessage = "You got it right. \n🥳"
            
            withAnimation(.easeInOut(duration: 1.5)) {
                animationOpacity = 1.0
                animationCount += 360
                confettiCounter += 1
            }
        } else {
            isCorrect = false
            
            if score == 0 {
                score += 0
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
        
        currentQuestion += 1
        questionProgress = Double((Double(currentQuestion) / Double(questionCount)))
        displayAlert = true
    }
    
    func askQuestion() {
        //let _ = debugPrint(settings.selection.rawValue)
        if currentQuestion == questionCount {
            gameOver = true
            resetGame()
        } else {
            isCorrect = false
            
            answersArray = []
            createAnswers()
            
            animationOpacity = 1.0
            animationCount = 0.0
            animationIncorrectCount = 0.0
        }
    }
    
    func resetGame() {
        alertTitle = "Game Over"
        alertMessage = "Great Job! \nYou got \(score) of \(questionCount) correct. \nReset or Return to Home?"
        
        questionsArray = []
        answersArray = []
        currentQuestion = 0
        score = 0
        
        animationOpacity = 1.0
        animationCount = 0.0
        animationIncorrectCount = 0.0
        
        createQuestions()
        createAnswers()
        countOfQuestions()
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
