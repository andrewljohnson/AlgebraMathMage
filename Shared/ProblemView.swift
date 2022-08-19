//
//  ProblemView.swift
//  AlgebraMathMage
//
//  Created by Andrew Johnson on 8/19/22.
//

//
//  ContentView.swift
//  Shared
//
//  Created by Andrew Johnson on 8/14/22.
//

import SwiftUI
import YouTubePlayerKit

struct ProblemView: View {
  
  @State private var showHint = false
  @State private var showToast = false
  @State private var showVideo = false
  var owner:MainView

  let youTubePlayer: YouTubePlayer = "https://youtube.com/watch?v=dQw4w9WgXcQ"
  
  func checkAnswer (problems:[Any], answerChoice:Int, correctAnswer:Int) {
    if let sections = API.loadCurriculum() {
      let section = sections[owner.sectionIndex]
      let problem = section.problems[owner.problemIndex]
      API.saveUserAnswer(problemID: problem.id, sectionID: section.id, answerIndex: answerChoice)
      API.printKeychain()
      if (answerChoice == correctAnswer) {
        owner.problemIndex += 1
        showHint = false
      } else {
        showHint = true
      }
      if (owner.problemIndex >= problems.count) {
        owner.problemIndex = 0
        owner.sectionIndex += 1
        owner.showSectionCompletion = true
        if (owner.sectionIndex >= sections.count) {
          owner.sectionIndex = 0
        }
      } else if (answerChoice == correctAnswer) {
        showToast = true
      }
    }
    API.saveLastQuestion(sectionIndex: owner.sectionIndex, problemIndex: owner.problemIndex)
  }
  
  var ProblemView: some View {
    if let sections = API.loadCurriculum() {
      let section = sections[owner.sectionIndex]
      let problems = section.problems
      let problem = problems[owner.problemIndex]
      let correctAnswer = problem.answer
      let textPrompt = problem.prompt
      let textFormula =  problem.formula
      let textHint = problem.hint
      let buttonTitles:[String] = problem.buttonTitles
      return AnyView(VStack {
        HStack {
          Image(systemName: "star")
                  .imageScale(.large)
          Text("\(Strings.sectionTitleString) \(owner.sectionIndex + 1) / \(sections.count)")
            .padding([.trailing], Style.padding)
          Text("\(Strings.problemTitleString) \(owner.problemIndex + 1) / \(problems.count)")
          Spacer()
          Button(
            action:
              {
                withAnimation { owner.showMenu = !owner.showMenu }
              }
          )
          {
            Image(systemName: "person")
                    .foregroundColor(.white)
                    .imageScale(.large)
          }
        }
          .padding()
          .background(Style.mainColor)
        
        Button(action:
          withAnimation {
            {
              showVideo = true
            }
          }
        )
        {
          HStack {
              Image(systemName: "play")
              Text("Play Helper Video")
            }
          .foregroundColor(Style.mainColor)
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding()
        }
        Spacer()
        Text(textPrompt)
          .padding()
          .font(.largeTitle)
          .transition(.scale)
          .id(textPrompt)
        Text(textFormula)
          .padding()
          .font(.title)
          .padding([.bottom], Style.paddingBelowPrompt)
          .transition(.scale)
          .id(textFormula)
        HStack {
          ForEach(Array(buttonTitles.enumerated()), id: \.element) {
            answerChoice, title in
            Button(action:
                    { withAnimation {checkAnswer(problems: problems, answerChoice: answerChoice, correctAnswer: correctAnswer)}})
              {
                Text(title)
                  .fontWeight(.bold)
                  .font(.largeTitle)
                  .foregroundColor(Style.mainColor)
                  .frame(width:Style.buttonSize * 2, height:Style.buttonSize)
                  .overlay(
                    RoundedRectangle(cornerRadius: Style.padding)
                        .stroke(Color.purple, lineWidth: Style.buttonStrokeWidth)
                  )
                  .id(title)

              }
              .transition(.scale)
              .padding()
          }
        }
        if (showHint) {
          Text(textHint)
        } else {
          Text("")
            .frame(minHeight: 20)
        }
        Spacer()
      }
        .toast(message: "Correct, good job!",
                     isShowing: $showToast,
                     duration: Toast.short)
      )
    }
    return AnyView(EmptyView())
  }
  
  var body: some View {
    GeometryReader { geometry in
      if (self.showVideo) {
        VStack {
          Button(action:
            withAnimation {
              {
                showVideo = false
              }
            }
          )
          {
            HStack {
                Image(systemName: "arrowshape.turn.up.backward.fill")
                Text("Done")
              }
            .foregroundColor(Style.mainColor)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
          }

          YouTubePlayerView(self.youTubePlayer)
            .onAppear { youTubePlayer.configuration = .init(
              autoPlay: true
            ) }
        }
      } else {
        ProblemView
          .zIndex(1)
      }
    }
    .transition(AnyTransition.opacity.animation(.easeInOut(duration: 0.2)))
  }
}
