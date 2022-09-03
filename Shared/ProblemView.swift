//
//  ProblemView.swift
//  AlgebraMathMage
//
//  Created by Andrew Johnson on 8/23/22.
//

import SwiftUI

struct ProblemView: View {
  
  // tightly coupled with parent so it can call checkAnswer
  // otherwise I'd just bind some variables
  // todo: ?
  let problemNavigator:ProblemNavigator
  @Binding var answerString:String
  @State var correctAnswerSubmitted = false
  
  var body: some View {
    if let curriculum = API.loadCurriculum() {
      let chapters = curriculum.chapters
      let sections = chapters[problemNavigator.chapterIndex].sections
      let section = sections[problemNavigator.sectionIndex]
      let problems = API.problemsForIDs(problemIDs: section.problemIDs)
      let problem = problems[problemNavigator.problemIndex]
      let textHint = problem.hint
      VStack {
        if (problem.type == APIKeys.multipleChoice) {
          ProblemViewMultipleChoice(problemNavigator: problemNavigator, answerString: $answerString, correctAnswerSubmitted: $correctAnswerSubmitted)
        } else {
          ProblemViewFreeform(problemNavigator: problemNavigator, answerString: $answerString, correctAnswerSubmitted: $correctAnswerSubmitted)
        }
        if (problemNavigator.showHint) {
          HStack { Text("\(Strings.hint.capitalized): "); Text(textHint) }
        } else {
          Text("")
            .frame(minHeight: 20)
        }
        Spacer()
      }
    }
  }
}
