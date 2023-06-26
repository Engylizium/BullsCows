//
//  ContentView.swift
//  bullsCows
//
//  Created by Соболев Пересвет on 6/18/23.
//

import SwiftUI

struct BullsAndCowsView: View {
    @ObservedObject var game = BullsAndCowsGame()
        @State private var showingGameScreen = false

        var body: some View {
            VStack {
                if showingGameScreen {
                    GameScreen(game: game, showingGameScreen: $showingGameScreen)
                } else {
                    DifficultySelectionScreen(game: game, showingGameScreen: $showingGameScreen)
                }
            }
        }
    }

struct DifficultySelectionScreen: View {
    @ObservedObject var game: BullsAndCowsGame
    @Binding var showingGameScreen: Bool

    var body: some View {
        VStack {
            Text("Select Difficulty")
                .font(.largeTitle)
                .fontWeight(.medium)
                .padding()
            
            VStack {
                Button(action: {
                    game.selectDifficulty(.easy)
                    showingGameScreen = true
                }) {
                    Text("Easy")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.green)
                
                Button(action: {
                    game.selectDifficulty(.medium)
                    showingGameScreen = true
                }) {
                    Text("Medium")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.yellow)
                
                Button(action: {
                    game.selectDifficulty(.hard)
                    showingGameScreen = true
                }) {
                    Text("Hard")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding()
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.red)
            }
            .padding()
        }
        .padding()
    }
}

struct GameScreen: View {
    @ObservedObject var game: BullsAndCowsGame
    @Binding var showingGameScreen: Bool
    @State private var guess = ""

    var body: some View {
        VStack {
            if game.gameState() {
                if game.getAnswer() == game.getLastGuess() {
                    Text("You won!")
                        .font(.title2)
                        .padding()
                        .foregroundColor(.green)
                    Button(action: {
                        showingGameScreen = false
                        game.cleanUp()
                    }) {
                        Text("New Game")
                            .font(.title2)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                } else {
                    Text("Game Over")
                        .font(.title2)
                        .padding()
                        .foregroundColor(.red)
                    Text("The secret number was: \(game.getAnswer()) and your guess was \(game.getLastGuess()!)")
                        .font(.title3)
                        .padding()
                }
            } else {
                Text("Number has \(game.getDifficulty().number) digits\nAttempts: \(game.getAttempts())")
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding()
                
                Spacer()
                    .frame(height: 40.0)
                
                HStack {
                    Text("Guess:")
                        .font(.headline)
                    TextField("Enter your guess", text: $guess)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                .padding()
                
                Button(action: {
                    game.checkGuess(guess: guess)
                    guess = ""
                }) {
                    Text("Submit")
                        .font(.title2)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                
                VStack {
                    Text("Previous Attempts")
                        .font(.title2)
                        .padding()
                    
                    ForEach(game.getPreviousAttempts(), id: \.self) { attempt in
                        HStack {
                            ForEach(attempt, id: \.self) { guessColor in
                                Circle()
                                    .foregroundColor(guessColor.color)
                                    .overlay(
                                        Text("\(guessColor.guess)")
                                                        .foregroundColor(.white)
                                                        .font(.system(size: 35, weight: .bold))
                                                        .minimumScaleFactor(0.5)
                                                )
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .onAppear{game.newGame()}
        .padding()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        BullsAndCowsView()
    }
}

