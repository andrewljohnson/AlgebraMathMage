//
//  ProblemNavigatorView.swift
//  AlgebraMathMage
//
//  Created by Andrew Johnson on 8/19/22.
//

import SwiftUI
import YouTubePlayerKit

struct ProblemNavigatorView: View {
  
  @Binding var problemIndex:Int;
  @Binding var sectionIndex:Int;
  @Binding var showSectionCompletion:Bool;
  @State var showHint = false
  @State var showMenu = false
  @State private var showToast = false
  @State private var showVideo = false
  // rick roll
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
  
  var body: some View {
    VStack {
      if (self.showVideo) {
          Button(action: withAnimation {{ showVideo = false }})
          {
            HStack { Image(systemName: "arrowshape.turn.up.backward.fill"); Text(Strings.done.capitalized) }
              .foregroundColor(Style.mainColor)
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding()
          }
          YouTubePlayerView(self.youTubePlayer)
            .onAppear { youTubePlayer.configuration = .init(autoPlay: true) }
      } else {
        if let sections = API.loadCurriculum() {
          let section = sections[sectionIndex]
          let problems = section.problems
              GeometryReader { geometry in
                ZStack {
                  VStack {
                    HStack {
                      Image(systemName: "star")
                        .imageScale(.large)
                      Text("\(Strings.section.capitalized) \(sectionIndex + 1) / \(sections.count)")
                        .padding([.trailing], Style.padding)
                      Text("\(Strings.problem.capitalized) \(problemIndex + 1) / \(problems.count)")
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
                        Text(Strings.playHelperVideo.capitalized)
                      }
                        .foregroundColor(Style.mainColor)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                    }
                    ProblemView(problemNavigatorView: self)
                }
                  .frame(width: self.showMenu ? geometry.size.width/4*3: geometry.size.width, height: geometry.size.height)
                  .toast(message: Strings.correctGoodJob, isShowing: $showToast, duration: Toast.short)
              }
              if self.showMenu {
                MenuView(showMenu: $showMenu, sectionIndex: $sectionIndex, problemIndex: $problemIndex)
                    .background(.black)
                    .frame(width: geometry.size.width/4, height: geometry.size.height)
                    .offset(x: geometry.size.width/4*3)
                    .transition(.move(edge: .trailing))
              }
            }
        }
      }
    }
  }

}

