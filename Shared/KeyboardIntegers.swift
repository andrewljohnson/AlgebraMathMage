//
//  KeyboardIntegers.swift
//  AlgebraMathMage
//
//  Created by Andrew Johnson on 8/26/22.
//

import SwiftUI

struct KeyboardIntegers: View {
  
  @Binding var answerString:String
  @Binding var correctAnswerSubmitted:Bool
  let problemNavigator:ProblemNavigator
  
  func buttonRow(labels:[Int]) -> some View {
    HStack {
      ForEach(labels, id: \.self) {
        number in
        Button(action:
                { withAnimation {
                    answerString = "\(answerString)\(number)"
                }}
        )
        {
          Text("\(number)")
            .fontWeight(.bold)
            .font(.largeTitle)
            .foregroundColor(correctAnswerSubmitted ? Style.colorDisabled : Style.colorMain)
            .frame(width:Style.buttonSize, height:Style.buttonSize)
            .overlay(
              Rectangle()
                .stroke(correctAnswerSubmitted ? Style.colorDisabled : Style.colorMain, lineWidth: Style.buttonStrokeWidth)
            )
            .id(number)
        }
        .disabled(correctAnswerSubmitted)
        .padding()
      }
    }
  }
  
  var body: some View {
    VStack {
      buttonRow(labels:[0, 1, 2, 3, 4])
      buttonRow(labels:[5, 6, 7, 8, 9])
      HStack {
        Spacer()
        Button(action:
                { withAnimation {
                  answerString = String(answerString.dropLast())
                }}
        )
        {
          Image(systemName: "delete.backward.fill")
            .resizable()
            .frame(width: Style.buttonSize, height: Style.buttonSize / 4*3)
            .foregroundColor(Style.colorDisabled)
            .id("delete")
        }
        .disabled(answerString.count == 0 || correctAnswerSubmitted)
        Spacer()
        if (correctAnswerSubmitted) {
          Button(action:
                  { withAnimation {
                    correctAnswerSubmitted = false
                    problemNavigator.gotoNextProblem()
                  }}
          )
          {
            Text(Strings.continueWord.capitalized)
              .fontWeight(.bold)
              .font(.largeTitle)
              .foregroundColor(answerString.count == 0 ? Style.colorDisabled : Style.colorContinue)
              .frame(width:Style.buttonSize * 2, height:Style.buttonSize)
              .overlay(
                RoundedRectangle(cornerRadius: Style.padding)
                  .stroke(answerString.count == 0 ? Style.colorDisabled : Style.colorContinue, lineWidth: Style.buttonStrokeWidth)
              )
              .id("submit")
          }
          .disabled(answerString.count == 0)

        } else {
          Button(action:
                  { withAnimation {
                    correctAnswerSubmitted = problemNavigator.checkAnswer(answer: Int(answerString) ?? Int(UInt8.min), gotoNext: false)
                  }}
          )
          {
            Text(Strings.submit.capitalized)
              .fontWeight(.bold)
              .font(.largeTitle)
              .foregroundColor(answerString.count == 0 ? Style.colorDisabled : Style.colorMain)
              .frame(width:Style.buttonSize * 2, height:Style.buttonSize)
              .overlay(
                RoundedRectangle(cornerRadius: Style.padding)
                  .stroke(answerString.count == 0 ? Style.colorDisabled : Style.colorMain, lineWidth: Style.buttonStrokeWidth)
              )
              .id("submit")
          }
          .disabled(answerString.count == 0)

        }
        Spacer()
      }
    }
    .transition(.scale)
  }
}
