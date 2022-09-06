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
    if let curriculum = API.loadCurriculum(), let chapter = API.chapterForID(chapterID: problemNavigator.index.chapterID), let section = API.sectionForID(chapterID: chapter.id, sectionID: problemNavigator.index.sectionID), let problem = curriculum.problems.first(where: {$0.id == problemNavigator.index.problemID}), let problemIndex = section.problemIDs.firstIndex(of: problem.id) {
      let problems = API.problemsForIDs(problemIDs: section.problemIDs)
      let textFormula =  problem.formula
      let formulaOrientation =  problem.formulaOrientation
      let formulaNumbers =  problem.formulaNumbers
      
      let previousProblem = problemIndex == 0 ? problem : problems[problemIndex - 1]
      VStack {
          if (textFormula != nil) {
            FormulaHorizontal(problem: problem, answerString: $answerString, correctAnswerSubmitted: $correctAnswerSubmitted)
          } else if (formulaOrientation == "vertical" && formulaNumbers != nil) {
            if API.sectionForID(chapterID: problemNavigator.index.chapterID, sectionID:problemNavigator.index.sectionID)?.inOrder != false && problemIndex != 0  {
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
