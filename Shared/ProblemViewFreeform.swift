//
//  ProblemViewFreeform.swift
//  AlgebraMathMage
//
//  Created by Andrew Johnson on 8/31/22.
//

import SwiftUI

struct ProblemViewFreeform: View {
  
  // tightly coupled with parent so it can call checkAnswer
  // otherwise I'd just bind some variables
  // todo: ?
  let problemNavigator:ProblemNavigator
  @Binding var answerString:String
  @Binding var correctAnswerSubmitted:Bool
  
  var body: some View {
    if let curriculum = API.loadCurriculum() {
      let chapters = curriculum.chapters
      let chapter = chapters[problemNavigator.chapterIndex]
      let section = chapter.sections[problemNavigator.sectionIndex]
      let problems = API.problemsForIDs(problemIDs: section.problemIDs)
      let problem = problems[problemNavigator.problemIndex]
      let textFormula =  problem.formula
      let formulaOrientation =  problem.formulaOrientation
      let formulaNumbers =  problem.formulaNumbers
      let previousProblem = problemNavigator.problemIndex == 0 ? problem : problems[problemNavigator.problemIndex - 1]
      VStack {
          if (textFormula != nil) {
            FormulaHorizontal(problemNavigator: problemNavigator, answerString: $answerString, correctAnswerSubmitted: $correctAnswerSubmitted)
          } else if (formulaOrientation == "vertical" && formulaNumbers != nil) {
            if (problemNavigator.showLast) {
              HStack {
                FormulaVertical(problem:previousProblem, answerString: $answerString, correctAnswerSubmitted: $correctAnswerSubmitted, showAnswer:.constant(true))
                  .padding([.trailing], 60)
                    .transition(.move(edge: .leading))
                FormulaVertical(problem:problem, answerString: $answerString, correctAnswerSubmitted: $correctAnswerSubmitted, showAnswer:.constant(false))
                  .transition(.move(edge: .leading))
              }
            } else {
              FormulaVertical(problem:problem, answerString: $answerString, correctAnswerSubmitted: $correctAnswerSubmitted, showAnswer:.constant(false))
                .transition(.move(edge: .leading))
            }
          }
      }
      Spacer()
      KeyboardIntegers(answerString: $answerString, correctAnswerSubmitted:$correctAnswerSubmitted, problemNavigator: problemNavigator)
        .transition(.opacity)
    }
  }
}
