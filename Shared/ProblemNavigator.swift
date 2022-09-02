//
//  ProblemNavigator.swift
//  AlgebraMathMage
//
//  Created by Andrew Johnson on 8/19/22.
//

import SwiftUI
import YouTubePlayerKit

struct ProblemNavigator: View {
  
  @Binding var problemIndex:Int;
  @Binding var sectionIndex:Int;
  @Binding var chapterIndex:Int;
  @Binding var showSectionCompletion:Bool;
  @Binding var showChapterCompletion:Bool;
  @State var showLast = false
  @State var showHint = false
  @State var showMenu = false
  @State private var showToast = false
  @State private var showVideo = false
  // rick roll
  let youTubePlayer: YouTubePlayer = "https://youtube.com/watch?v=dQw4w9WgXcQ"
  
  func checkAnswer(answer:Int, gotoNext:Bool) -> Bool {
    if let curriculum = API.loadCurriculum() {
      let chapter = curriculum.chapters[chapterIndex]
      let section = chapter.sections[sectionIndex]
      let problems = API.problemsForIDs(problemIDs: section.problemIDs)
      let problem = problems[problemIndex]
      let correctAnswer = problem.answer
      API.saveUserAnswer(problemID: problem.id, sectionID: section.id, chapterID: chapter.id, answerGiven: answer)
      API.printKeychain()
      if (problemIndex < problems.count && answer == correctAnswer) {
        showToast = true
      }
      if (answer == correctAnswer) {
        if (gotoNext) {
          gotoNextProblem()
        }
        showHint = false
      } else {
        showHint = true
      }
      return answer == correctAnswer
    }
    // should never get here
    return false
  }

  func gotoNextProblem() {
    if let curriculum = API.loadCurriculum() {
      let chapters = curriculum.chapters
      let chapter = chapters[chapterIndex]
      let sections = chapter.sections
      let section = chapter.sections[sectionIndex]
      let problemIDs = section.problemIDs
      problemIndex += 1
      if (problemIndex >= problemIDs.count) {
        showLast = false
        problemIndex = 0
        sectionIndex += 1
        showSectionCompletion = true
        if (sectionIndex >= sections.count) {
          chapterIndex += 1
          // showChapterCompletion = true
        }

        if (chapterIndex >= chapters.count) {
          chapterIndex = 0
          sectionIndex = 0
        } else if (sectionIndex >= sections.count) {
          sectionIndex = 0
        }
      } else {
        showLast = true
      }
    }
    API.saveLastQuestion(chapterIndex: chapterIndex, sectionIndex: sectionIndex, problemIndex: problemIndex)
  }
  
  var body: some View {
    VStack {
      if (self.showVideo) {
          Button(action: withAnimation {{ showVideo = false }})
          {
            HStack { Image(systemName: "arrowshape.turn.up.backward.fill"); Text(Strings.done.capitalized) }
              .foregroundColor(Style.colorMain)
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding()
          }
          YouTubePlayerView(self.youTubePlayer)
            .onAppear { youTubePlayer.configuration = .init(autoPlay: true) }
      } else {
        if let curriculum = API.loadCurriculum() {
          let chapters = curriculum.chapters
          let chapter = chapters[chapterIndex]
          let sections = chapter.sections
          let section = sections[sectionIndex]
          let problemIDs = section.problemIDs
              GeometryReader { geometry in
                ZStack {
                  VStack {
                    HStack {
                      Image("dalle-icon")
                      Text("\(Strings.chapter.capitalized) \(chapterIndex + 1) / \(chapters.count)")
                        .padding([.trailing], Style.padding)
                      Text("\(Strings.section.capitalized) \(sectionIndex + 1) / \(sections.count)")
                        .padding([.trailing], Style.padding)
                      Text("\(Strings.problem.capitalized) \(problemIndex + 1) / \(problemIDs.count)")
                      Spacer()
                      Button(action: { withAnimation { showMenu = !showMenu } })
                      {
                        Image(systemName: "person")
                          .foregroundColor(.white)
                          .imageScale(.large)
                      }
                    }
                      .padding()
                      .background(Style.colorMain)
                    Button(action: withAnimation {{ showVideo = true }})
                    {
                      HStack {
                        Image(systemName: "play")
                        Text(Strings.playHelperVideo.capitalized)
                      }
                        .foregroundColor(Style.colorMain)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                    }
                    ProblemView(problemNavigator: self)
                }
                  .frame(width: self.showMenu ? geometry.size.width/4*3: geometry.size.width, height: geometry.size.height)
                  .toast(message: Strings.correctGoodJob, isShowing: $showToast, duration: Toast.short)
              }
              if self.showMenu {
                MenuView(showMenu: $showMenu, chapterIndex: $chapterIndex, sectionIndex: $sectionIndex, problemIndex: $problemIndex)
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

