//
//  FormulaHorizontal.swift
//  AlgebraMathMage
//
//  Created by Andrew Johnson on 8/31/22.
//

import SwiftUI

struct FormulaHorizontal: View {

  let problemNavigator:ProblemNavigator
  @Binding var answerString:String
  @Binding var correctAnswerSubmitted:Bool

  var body: some View {
    if let curriculum = API.loadCurriculum() {
      let chapter = curriculum.chapters[problemNavigator.chapterIndex]
      let section = chapter.sections[problemNavigator.sectionIndex]
      let problemID = section.problemIDs[problemNavigator.problemIndex]
      let problem = API.problemForID(problemID:problemID)
      let textFormula =  problem!.formula
      HStack {
        Text(textFormula ?? "")
          .padding()
          .font(.largeTitle)
          .transition(.scale)
          .foregroundColor(correctAnswerSubmitted ? Style.colorContinue : Color.black)
          .id(textFormula)
        Text(answerString)
          .fontWeight(.bold)
          .foregroundColor(correctAnswerSubmitted ? Style.colorContinue : Color.black)
          .padding()
          .font(.largeTitle)
          .transition(.scale)
          .overlay(
            Rectangle()
              .stroke(correctAnswerSubmitted ? Style.colorContinue : Style.colorMain, lineWidth: Style.inputStrokeWidth)
          )
          .id("number_answer")
      }
      .padding([.bottom], Style.paddingBelowPrompt)
    }
  }
}
