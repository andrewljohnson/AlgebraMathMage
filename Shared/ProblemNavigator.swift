//
//  ProblemNavigator.swift
//  AlgebraMathMage
//
//  Created by Andrew Johnson on 8/19/22.
//

import SwiftUI
import YouTubePlayerKit

struct ProblemNavigator: View {
  
  @State var answerString = ""
  @Binding var problemIndex:Int;
  @Binding var sectionIndex:Int;
  @Binding var chapterIndex:Int;
  @Binding var showSectionFailure:Bool;
  @Binding var showSectionCompletion:Bool;
  @Binding var showChapterCompletion:Bool;
  @State var showLast = false
  @State var showHint = false
  @State var showMenu = false
  @State private var showToastFailed = false
  @State private var showToastFailedTwice = false
  @State private var showToast = false
  @State private var showVideo = false

  @State private var problemFailureCount = 0

  
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
      if problemIndex < problems.count && answer == correctAnswer {
        showToast = true
      }
      if answer != correctAnswer {
        problemFailureCount += 1
        if problemFailureCount == 1 {
          showToastFailed = true
        } else if problemFailureCount == 2 {
          showToastFailedTwice = true
        }
      }
      
      if answer == correctAnswer || problemFailureCount == 2 {
        if (gotoNext || problemFailureCount == 2) {
          gotoNextProblem()
        }
        showHint = false
        problemFailureCount = 0
      } else {
        showHint = true
      }
      return answer == correctAnswer
    }
    // should never get here
    return false
  }

  func gotoNextProblem() {
    answerString = ""
    if let curriculum = API.loadCurriculum() {
      let chapters = curriculum.chapters
      let sections = chapters[chapterIndex].sections
      let problemIDs = chapters[chapterIndex].sections[sectionIndex].problemIDs
      problemIndex += 1
      if (problemIndex >= problemIDs.count) {
        showLast = false
        problemIndex = 0
        if sectionIndex >= 1 && sectionIndex % 2 != 0 {
          if !API.sectionPairIsMastered(chapterID: chapterIndex, sectionIDInOrder: sections[sectionIndex-1].id, sectionIDRandom: sections[sectionIndex].id) {
            sectionIndex -= 1
            showSectionFailure = true
            return
          }
        }
        sectionIndex += 1
        showSectionCompletion = true
        if (sectionIndex >= sections.count) {
          chapterIndex += 1
          showChapterCompletion = true
        }

        if (chapterIndex >= chapters.count) {
          chapterIndex = 0
          sectionIndex = 0
        } else if (sectionIndex >= sections.count) {
          sectionIndex = 0
        }
      } else {
        // show last problem answer only on in order sections
        showLast = sectionIndex % 2 == 0
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
        GeometryReader { geometry in
          ZStack {
            VStack {
              ProblemNavigatorHeader(problemIndex: $problemIndex, sectionIndex: $sectionIndex, chapterIndex: $chapterIndex, showMenu: $showMenu, showVideo: $showVideo)
              ProblemView(problemNavigator: self, answerString: $answerString)
            }
            .frame(width: self.showMenu ? geometry.size.width/4*3: geometry.size.width, height: geometry.size.height)
            .toast(message: Strings.correctGoodJob, isShowing: $showToast, duration: Toast.short)
            .toast(message: Strings.tryAgain, isShowing: $showToastFailed, duration: Toast.short)
            .toast(message: Strings.comeBackToThisOne, isShowing: $showToastFailedTwice, duration: Toast.short)
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

