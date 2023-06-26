//
//  Logic.swift
//  bullsCows
//
//  Created by Соболев Пересвет on 6/18/23.
//

import SwiftUI

class BullsAndCowsGame: ObservableObject {
    
    enum Difficulty {
        case easy
        case medium
        case hard
        
        var number: Int {
            switch self {
            case .easy:
                return 4
            case .medium:
                return 6
            case .hard:
                return 8
            }
        }
    }
    
    struct GuessColor: Hashable {
        let guess: String
        let color: Color
    }
    
    @Published internal var currentDifficulty = Difficulty.easy
    private var secretNumber = ""
    private var attempts = 0
    private var isGameOver = false
    private var previousAttempts: [[GuessColor]] = []
    
    func generateSecretNumber(digitsCount: Int) -> String {
        var secretNumber = ""
        var digits = Array(0...9)
        digits.shuffle()
        
        for i in 0..<digitsCount {
            secretNumber.append("\(digits[i])")
        }
        
        return secretNumber
    }
    
    func checkGuess(guess: String) {
        var bulls = 0
        var cows = 0
        
        let secretDigits = Array(secretNumber)
        let guessDigits = Array(guess)
        
        var currentAttempt: [GuessColor] = []
        
        for (index, digit) in guessDigits.enumerated() {
            if digit == secretDigits[index] {
                bulls += 1
                currentAttempt.append(GuessColor(guess: "\(digit)", color: .green))
            } else if secretDigits.contains(digit) {
                cows += 1
                currentAttempt.append(GuessColor(guess: "\(digit)", color: .yellow))
            } else {
                currentAttempt.append(GuessColor(guess: "\(digit)", color: .red))
            }
         }
        
        previousAttempts.append(currentAttempt)
        attempts += 1
        
        if bulls == secretNumber.count {
            isGameOver = true
        } else if attempts > 10 {
            isGameOver = true
        } else {
            // Handle game ongoing
        }
    }
    
    func selectDifficulty(_ difficulty: Difficulty) {
        currentDifficulty = difficulty
    }
    
    func getAnswer() -> String {
        return secretNumber
    }
    
    func getDifficulty() -> Difficulty {
        return currentDifficulty
    }

    func gameState() -> Bool {
        return isGameOver
    }
    
    func getAttempts() -> Int {
        return attempts
    }

    func getPreviousAttempts() -> [[GuessColor]] {
        return previousAttempts
    }
    
    func newGame() {
        isGameOver = false
        secretNumber = generateSecretNumber(digitsCount: currentDifficulty.number)
    }
    
}
