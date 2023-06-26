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
                .font(.title)
                .padding()

            Button(action: {
                game.selectDifficulty(.easy)
                showingGameScreen = true
            }) {
                Text("Easy")
                    .font(.title2)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Button(action: {
                game.selectDifficulty(.medium)
                showingGameScreen = true
            }) {
                Text("Medium")
                    .font(.title2)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            
            Button(action: {
                game.selectDifficulty(.hard)
                showingGameScreen = true
            }) {
                Text("Hard")
                    .font(.title2)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
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
            Text("Bulls and Cows")
                .font(.title)
                .padding()

            if game.gameState() {
                            if game.getAnswer() == guess {
                                Text("You won!")
                                    .font(.title2)
                                    .padding()
                                    .foregroundColor(.green)
                            } else {
                                Text("Game Over")
                                    .font(.title2)
                                    .padding()
                                    .foregroundColor(.red)
                                Text("The secret number was: \(game.getAnswer())")
                                    .font(.title3)
                                    .padding()
                            }
            } else {
                Text("Number has \(game.getDifficulty().number) digits\nAttempts: \(game.getAttempts())")
                    .font(.title2)
                    .padding()

                HStack {
                    Text("Guess:")
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
                        .background(Color.green)
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
                                Text(guessColor.guess)
                                    .foregroundColor(guessColor.color)
                                    .padding()
                            }
                        }
                    }
                }
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

