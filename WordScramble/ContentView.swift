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
  
  @State private var score = 0
  let scoreSize: Double = 40
  
  @State private var isKeyboardVisible = false
  
  @FocusState private var isTextFieldFocused
  
  let purple: Color = Color(red: 0.16, green: 0.07, blue: 0.18, opacity: 1.00)
  let lightGreen: Color = Color(red: 0.61, green: 0.94, blue: 0.28, opacity: 1.00)
  let lightBlue: Color = Color(red: 0.67, green: 0.85, blue: 0.89, opacity: 1.00)
  
  let boxRadius: CGFloat = 10
  let horizontalPadding: Double = 20
  
  var body: some View {
    NavigationStack{
      VStack{
        HStack{
          VStack{
            ZStack{
              RoundedRectangle(cornerRadius: 100)
                .fill(
                  LinearGradient(gradient: Gradient(colors: [Color.purple, Color(red: 0.82, green: 0.31, blue: 0.31, opacity: 1.00)]),
                                 startPoint: .top,
                                 endPoint: .bottom)
                )
                .frame(width: scoreSize, height: scoreSize)
              
              Text("\(score)")
                .foregroundStyle(Color.white)
            }
            Text("Points").font(.caption).padding(.vertical, 1)
          }.frame(width: scoreSize * 1.5, height: scoreSize)
          Spacer()
          Image("logo")
            .resizable()
            .frame(width: 100, height: 100)
          Spacer()
          VStack{
            Button(action: startGame){
              Image(systemName: "forward.circle.fill").resizable().frame(width: scoreSize, height: scoreSize).foregroundColor(lightGreen)
            }.frame(width: scoreSize, height: scoreSize)
            Text("Next Word").font(.caption).padding(.vertical, 1)
          }.frame(width: scoreSize * 1.5, height: scoreSize)
        }
        .padding(.horizontal, horizontalPadding)
        StylizedWord(word: rootWord)
          .padding()
        
        TextField("Type your word here", text: $newWord)
          .preferredColorScheme(/*@START_MENU_TOKEN@*/.dark/*@END_MENU_TOKEN@*/)
          .padding()
          .textInputAutocapitalization(.never)
          .autocorrectionDisabled()
          .focused($isTextFieldFocused)
          .background(Color.black)
          .cornerRadius(boxRadius)
          .foregroundStyle(lightBlue)
          .padding(.horizontal, horizontalPadding)
          .onSubmit(addNewWord)
        
        Text("Create new words using the letters from the word above")
          .foregroundStyle(lightGreen)
          .opacity(/*@START_MENU_TOKEN@*/0.8/*@END_MENU_TOKEN@*/)
          .padding(.horizontal, horizontalPadding)
          .font(.caption)
        
        List{
            ForEach(usedWords, id: \.self) { word in
              HStack{
                Image(systemName: "\(word.count).circle").foregroundStyle(Color.black)
                Text(word).foregroundStyle(Color.black)
              }
            }.listRowBackground(lightBlue)
        }
        .scrollContentBackground(.hidden)
        .onAppear(perform: {
          startGame()
        })
        .alert(errorTitle, isPresented: $showingError) {
          Button("OK") {}
        } message: {
          Text(errorMessage)
        }
      }
      .background(purple)
      .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification), perform: { _ in
        isKeyboardVisible = true
      })
      .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification), perform: { _ in
        isKeyboardVisible = false
      })
      .onTapGesture {
        isTextFieldFocused = false
      }
    }
  }
  
  func addNewWord() {
    isTextFieldFocused = true
    let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
    
    guard answer.count > 0 else { return }
    
    guard isOriginal(word: answer) else {
      wordError(title: "Word Already Used", message: "Please enter a word you haven't used before.")
      return
    }
    
    guard isPossible(word: answer) else {
      wordError(title: "Invalid Word", message: "'\(answer)' can't be formed using the letters from '\(rootWord)'.")
      return
    }
    
    guard isReal(word: answer) else {
      wordError(title: "Word Not Recognized", message: "'\(answer)' doesn't appear to be a valid English word.")
      return
    }
    
    withAnimation{
      usedWords.insert(answer, at: 0)
    }
    score += answer.count
    newWord = ""
  }
  
  func startGame() {
    isTextFieldFocused = true
    score = 0
    usedWords.removeAll()
    if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt"){
      if let startWords = try? String(contentsOf: startWordsURL){
        let allWords = startWords.components(separatedBy: "\n")
        rootWord = allWords.randomElement() ?? "scramble"
        return
      }
    }
    
    fatalError("Unable to load 'start.txt' from the app bundle.")
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

struct StylizedWord: View {
  var word: String?
  var body: some View{
    getLetters(word: word ?? "error")
  }
  
  func getLetters(word: String) -> some View{
    let letters = word.map { letter in
      Image(systemName: "\(letter).square")
        .resizable()
        .frame(width: 30, height: 30)
        .foregroundStyle(Color.white)
    }
    return HStack{
      Spacer()
      ForEach(letters.indices, id: \.self) {index in
        letters[index]
      }
      Spacer()
    }
  }
}

#Preview {
  ContentView()
}
