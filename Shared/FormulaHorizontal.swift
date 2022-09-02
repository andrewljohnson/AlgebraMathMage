//
//  FormulaHorizontal.swift
//  AlgebraMathMage
//
//  Created by Andrew Johnson on 8/31/22.
//

import SwiftUI

struct FormulaHorizontal: View {

  let problem:Problem
  @Binding var answerString:String
  @Binding var correctAnswerSubmitted:Bool

  var body: some View {
    HStack {
      Text(problem.formula ?? "")
        .padding()
        .font(.largeTitle)
        .transition(.scale)
        .foregroundColor(correctAnswerSubmitted ? Style.colorContinue : Color.black)
        .id(problem.formula)
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
