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
  @Binding var index:CurriculumIndex
  @Binding var showSectionFailure:Bool
  @Binding var showSectionCompletion:Bool
  @Binding var showChapterCompletion:Bool
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
    if let chapter = API.chapterForID(chapterID: index.chapterID), let section = chapter.sections.first(where: {$0.id == index.sectionID}) {
      let problems = API.problemsForIDs(problemIDs: section.problemIDs)
      if let problem = problems.first(where: {$0.id == index.problemID}) {
        let correctAnswer = problem.answer
          API.saveUserAnswer(index: index, answerGiven: answer)
          if let lastProblem = problems.last, problem.id != lastProblem.id && answer == correctAnswer {
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
    }
    // should never get here
    return false
  }

  func gotoNextProblem() {
    answerString = ""
    if let curriculum = API.loadCurriculum(), let chapter = API.chapterForID(chapterID: index.chapterID), let section = chapter.sections.first(where: {$0.id == index.sectionID}), let problemIndex = section.problemIDs.firstIndex(of: index.problemID) {
      let sections = chapter.sections
      
      
      var gotoNextChapter = false
      if (problemIndex == section.problemIDs.count - 1) {
        showSectionCompletion = true
        for (sIndex, s) in chapter.sections.enumerated() {
          if s.id == section.id {
            if sIndex < chapter.sections.count - 1 {
              index = CurriculumIndex(chapterID: index.chapterID, sectionID: chapter.sections[sIndex + 1].id, problemID: chapter.sections[sIndex + 1].problemIDs[0])
            } else {
              gotoNextChapter = true
              showChapterCompletion = true
            }
          }
        }
        
        if gotoNextChapter {
          for (cIndex, c) in curriculum.chapters.enumerated() {
            if c.id == chapter.id {
              if cIndex < curriculum.chapters.count - 1 {
                index = CurriculumIndex(chapterID: curriculum.chapters[cIndex + 1].id, sectionID: curriculum.chapters[cIndex + 1].sections[0].id, problemID: curriculum.chapters[cIndex + 1].sections[0].problemIDs[0])
              } else {
                let chapter = curriculum.chapters[0]
                index = CurriculumIndex(chapterID: chapter.id, sectionID: chapter.sections[0].id, problemID: chapter.sections[0].problemIDs[0])
              }
            }
          }
        }
      } else {
        index = CurriculumIndex(chapterID: index.chapterID, sectionID: index.sectionID, problemID: section.problemIDs[problemIndex + 1])
      }

        
      if let section = API.sectionForID(chapterID: index.chapterID, sectionID: index.sectionID), section.inOrder, let sectionIndex = sections.firstIndex(of: section), sectionIndex > 0 {
        let previousSection = sections[sectionIndex - 1]
        if !API.sectionPairIsMastered(chapterID: chapter.id, sectionIDInOrder: previousSection.id, sectionIDRandom: section.id) {
          index = CurriculumIndex(chapterID: chapter.id, sectionID: previousSection.id, problemID: previousSection.problemIDs[0])
            showSectionFailure = true
            return
          }
        }
    }
    API.saveCurrentQuestion(index:index)
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
              ProblemNavigatorHeader(index:$index, showMenu: $showMenu, showVideo: $showVideo)
              ProblemView(problemNavigator: self, answerString: $answerString)
            }
            .frame(width: self.showMenu ? geometry.size.width/4*3: geometry.size.width, height: geometry.size.height)
            .toast(message: Strings.correctGoodJob, isShowing: $showToast, duration: Toast.short)
            .toast(message: Strings.tryAgain, isShowing: $showToastFailed, duration: Toast.short)
            .toast(message: Strings.comeBackToThisOne, isShowing: $showToastFailedTwice, duration: Toast.short)
          }
          if self.showMenu {
            MenuView(showMenu: $showMenu, index:$index)
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

