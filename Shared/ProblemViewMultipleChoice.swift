//
//  ProblemViewMultipleChoice.swift
//  AlgebraMathMage
//
//  Created by Andrew Johnson on 8/23/22.
//

import SwiftUI

struct ProblemViewMultipleChoice: View {
  
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
      let textPrompt = problem.prompt
      let textFormula =  problem.formula
      let buttonTitles:[String] = problem.buttonTitles ?? []
      VStack {
        Spacer()
        Text(textPrompt ?? "")
          .padding()
          .font(.largeTitle)
          .transition(.scale)
          .id(textPrompt)
        Text(textFormula ?? "")
          .padding()
          .font(.title)
          .padding([.bottom], Style.paddingBelowPrompt)
          .transition(.scale)
          .id(textFormula)
        KeyboardMultipleChoice(buttonTitles:buttonTitles, problemNavigator:problemNavigator)
        Spacer()
      }
    }
  }
}
