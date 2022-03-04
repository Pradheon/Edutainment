//
//  Settings.swift
//  JoshanRai-Edutainment
//
//  Created by Joshan Rai on 3/1/22.
//

import Foundation
import SwiftUI

enum NumQuestions: String, Equatable, CaseIterable, Identifiable {
    case five = "5"
    case ten = "10"
    case twenty = "20"
    case all = "All"
    
    var id: Self { self }
}

class Settings: ObservableObject {
    @Published var multiTablesUpTo = 1
    @Published var numQuestionsIndex = NumQuestions.allCases
    @Published var numQuestions = NumQuestions.allCases.count
    @Published var selection: NumQuestions = .five
}

struct Question {
    var text: String
    var product: Int
}
