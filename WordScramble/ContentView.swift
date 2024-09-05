//
//  ContentView.swift
//  WordScramble
//
//  Created by Rafael Fagundes on 2024-09-05.
//

import SwiftUI

struct ContentView: View {
  
  @State private var usedWords: [String] = []
  @State private var rootWord: String = ""
  @State private var newWord: String = ""

  @State private var errorTitle = ""
  @State private var errorMessage = ""
  @State private var showingError = false

  @FocusState private var isTextFieldFocused
  
  var body: some View {
    NavigationStack{
      List{
        Section {
          TextField("Enter your word", text: $newWord)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .focused($isTextFieldFocused)
        }
        
        Section {
          ForEach(usedWords, id: \.self) { word in
            HStack{
              Image(systemName: "\(word.count).circle")
              Text(word)
            }
          }
        }
      }
      .navigationTitle(rootWord)
      .onSubmit(addNewWord)
      .onAppear(perform: {
        startGame()
      })
      .alert(errorTitle, isPresented: $showingError) {
        Button("OK") {}
      } message: {
        Text(errorMessage)
      }
    }
  }
  
  func addNewWord() {
    let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
    
    guard answer.count > 0 else { return }
    
    guard isOriginal(word: answer) else {
      wordError(title: "Word used already", message: "Be more original!")
      return
    }
   
    guard isPossible(word: answer) else {
      wordError(title: "Word not possible", message: "You can't spell that word from '\(rootWord)'!")
      return
    }
    
    guard isReal(word: answer) else {
      wordError(title: "Word not recognized", message: "Make up words are not accepted!")
      return
    }
    
    withAnimation{
      usedWords.insert(answer, at: 0)
    }
    
    isTextFieldFocused = true
    newWord = ""
  }
  
  func startGame() {
    isTextFieldFocused = true
    if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt"){
      if let startWords = try? String(contentsOf: startWordsURL){
        let allWords = startWords.components(separatedBy: "\n")
        rootWord = allWords.randomElement() ?? "humorous"
        return
      }
    }
    
    fatalError("Could not load start.txt from bundle.")
  }
  
  func isOriginal(word: String) -> Bool {
    !usedWords.contains(word)
  }
  
  func isPossible(word: String) -> Bool {
    var tempWord = rootWord
    
    for letter in word {
      if let pos = tempWord.firstIndex(of: letter){
        tempWord.remove(at: pos)
      } else {
        return false
      }
    }
    
    return true
  }
  
  func isReal(word: String) -> Bool {
    let checker = UITextChecker()
    let range = NSRange(location: 0, length: word.utf16.count)
    let mispelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")
    return mispelledRange.location == NSNotFound
  }
  
  func wordError(title: String, message: String) {
    errorTitle = title
    errorMessage = message
    showingError = true
    isTextFieldFocused = true
  }
}

#Preview {
  ContentView()
}
