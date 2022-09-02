//
//  FormulaVertical.swift
//  AlgebraMathMage
//
//  Created by Andrew Johnson on 8/31/22.
//

import SwiftUI

struct FormulaVertical: View {

  let problem:Problem
  @Binding var answerString:String
  @Binding var correctAnswerSubmitted:Bool
  @Binding var showAnswer:Bool

  var body: some View {
    VStack {
      // todo: force unwrap bad?
      ForEach(Array(zip(problem.formulaNumbers!.indices, problem.formulaNumbers!)), id: \.0) {
        lineNumber, line in
        if (lineNumber == problem.formulaNumbers!.count - 1) {
          HStack {
            Text(problem.formulaOperation == "multiplication" ? "x" : "")
              .foregroundColor(showAnswer ? Color.gray.opacity(0.5) : correctAnswerSubmitted ? Style.colorContinue : Color.black)
              .font(.largeTitle)
              .frame(alignment: .leading)
              .id("formulaOperation")
            Spacer()
            Text("\(line)")
              .font(.largeTitle)
              .foregroundColor(showAnswer ? Color.gray.opacity(0.5) : correctAnswerSubmitted ? Style.colorContinue : Color.black)
              .id(problem.formula)
          }
          .frame(width:75, height:40, alignment: .trailing)
            HStack {
              Rectangle().frame(width: 75, height: 2)
                .foregroundColor(showAnswer ? Color.gray.opacity(0.5) : Color.black)
            }
        } else {
          Text("\(line)")
            .font(.largeTitle)
            .frame(width:75, alignment: .trailing)
            .foregroundColor(showAnswer ? Color.gray.opacity(0.5) : correctAnswerSubmitted ? Style.colorContinue : Color.black)
            .frame(height:30)
            .id(problem.formula)
        }
      }
      if (showAnswer) {
        Text("\(problem.answer ?? 0)")
          .font(.largeTitle)
          .foregroundColor(Color.gray.opacity(0.5))
          .frame(width:75, height:50, alignment: .trailing)
          .id("number_answer_previous")
      } else {
        Text(answerString)
          .fontWeight(.bold)
          .foregroundColor(correctAnswerSubmitted ? Style.colorContinue : Color.black)
          .font(.largeTitle)
          .frame(width:75, height:50, alignment: .trailing)
          .background(Color.gray.opacity(0.2))
          .id("number_answer")
      }
    }
  }
}
