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
  
  @Binding var problemIndex:Int;
  @Binding var sectionIndex:Int;
  @Binding var showSectionCompletion:Bool;

  @State private var showHint = false
  @State private var showToast = false
  @State private var showVideo = false
  @State var showMenu = false

  let youTubePlayer: YouTubePlayer = "https://youtube.com/watch?v=dQw4w9WgXcQ"
  
  func checkAnswer (problems:[Any], answerChoice:Int, correctAnswer:Int) {
    if let sections = API.loadCurriculum() {
      let section = sections[sectionIndex]
      let problem = section.problems[problemIndex]
      API.saveUserAnswer(problemID: problem.id, sectionID: section.id, answerIndex: answerChoice)
      API.printKeychain()
      if (answerChoice == correctAnswer) {
        problemIndex += 1
        showHint = false
      } else {
        showHint = true
      }
      if (problemIndex >= problems.count) {
        problemIndex = 0
        sectionIndex += 1
        showSectionCompletion = true
        if (sectionIndex >= sections.count) {
          sectionIndex = 0
        }
      } else if (answerChoice == correctAnswer) {
        showToast = true
      }
    }
    API.saveLastQuestion(sectionIndex: sectionIndex, problemIndex: problemIndex)
  }
  
  var ProblemView: some View {
    if let sections = API.loadCurriculum() {
      let section = sections[sectionIndex]
      let problems = section.problems
      let problem = problems[problemIndex]
      let correctAnswer = problem.answer
      let textPrompt = problem.prompt
      let textFormula =  problem.formula
      let textHint = problem.hint
      let buttonTitles:[String] = problem.buttonTitles
        return AnyView(
          GeometryReader { geometry in
            ZStack {
              VStack {
                HStack {
                  Image(systemName: "star")
                    .imageScale(.large)
                  Text("\(Strings.sectionTitleString) \(sectionIndex + 1) / \(sections.count)")
                    .padding([.trailing], Style.padding)
                  Text("\(Strings.problemTitleString) \(problemIndex + 1) / \(problems.count)")
                  Spacer()
                  Button(action: { withAnimation { showMenu = !showMenu } })
                  {
                    Image(systemName: "person")
                      .foregroundColor(.white)
                      .imageScale(.large)
                  }
                }
                  .padding()
                  .background(Style.mainColor)
                Button(action: withAnimation {{ showVideo = true }})
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
                          { withAnimation {checkAnswer(problems: problems, answerChoice: answerChoice, correctAnswer: correctAnswer)}}
                    )
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
              .frame(width: self.showMenu ? geometry.size.width/4*3: geometry.size.width, height: geometry.size.height)
              .zIndex(1)
              .toast(message: "Correct, good job!", isShowing: $showToast, duration: Toast.short)
          }
          if self.showMenu {
            MenuView(showMenu: $showMenu, sectionIndex: $sectionIndex, problemIndex: $problemIndex)
                .background(.black)
                .frame(width: geometry.size.width/4, height: geometry.size.height)
                .offset(x: geometry.size.width/4*3)
                .transition(.move(edge: .trailing))
                .zIndex(2)
          }
        }
      )
    }
    return AnyView(EmptyView())
  }
  
  var body: some View {
    VStack {
      if (self.showVideo) {
          Button(action:
            withAnimation {
              {
                showVideo = false
              }
            }
          )
          {
            HStack { Image(systemName: "arrowshape.turn.up.backward.fill"); Text("Done") }
              .foregroundColor(Style.mainColor)
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding()
          }
          YouTubePlayerView(self.youTubePlayer)
            .onAppear { youTubePlayer.configuration = .init(autoPlay: true) }
      } else {
        ProblemView
          .zIndex(1)
      }
    }
  }

}

