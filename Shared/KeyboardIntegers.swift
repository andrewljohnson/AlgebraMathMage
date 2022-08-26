//
//  KeyboardIntegers.swift
//  AlgebraMathMage
//
//  Created by Andrew Johnson on 8/26/22.
//

import SwiftUI

struct KeyboardIntegers: View {
  
  @Binding var answerString:String
  let problemNavigator:ProblemNavigatorView
  @State var correctAnswerSubmitted = false
  
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
            .foregroundColor(Style.colorMain)
            .frame(width:Style.buttonSize, height:Style.buttonSize)
            .overlay(
              Rectangle()
                .stroke(Style.colorMain, lineWidth: Style.buttonStrokeWidth)
            )
            .id(number)
        }
        .padding()
      }
    }
  }
  
  var body: some View {
    VStack {
      buttonRow(labels:[0, 1, 2, 3, 4])
      buttonRow(labels:[5, 6, 7, 8, 9])
      Spacer()
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
            .foregroundColor(answerString.count == 0 ? Style.colorDisabled : Style.colorDelete)
            .id("delete")
        }
        .disabled(answerString.count == 0)
        Spacer()
        if (correctAnswerSubmitted) {
          Button(action:
                  { withAnimation {
                    answerString = ""
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
                    correctAnswerSubmitted = problemNavigator.checkNumberAnswer(answer: Int(answerString) ?? Int(UInt8.min))
                    // if (correct) {
                    //
                    // }

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
