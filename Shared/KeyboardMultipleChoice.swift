//
//  KeyboardMultipleChoice.swift
//  AlgebraMathMage
//
//  Created by Andrew Johnson on 8/26/22.
//

import SwiftUI

struct KeyboardMultipleChoice: View {
  
  let buttonTitles:[String]
  let problemNavigator:ProblemNavigator
  
  var body: some View {
    HStack {
      ForEach(Array(buttonTitles.enumerated()), id: \.element) {
        answerIndex, title in
        Button(action:
                { withAnimation { _ = problemNavigator.checkAnswer(answer: answerIndex, gotoNext: true) }}
        )
        {
          Text(title)
            .fontWeight(.bold)
            .font(.largeTitle)
            .foregroundColor(Style.colorMain)
            .frame(width:Style.buttonSize * 2, height:Style.buttonSize)
            .overlay(
              RoundedRectangle(cornerRadius: Style.padding)
                .stroke(Style.colorMain, lineWidth: Style.buttonStrokeWidth)
            )
            .id(title)
        }
          .padding()
      }
    }
  }
}
