//
//  KeyboardMultipleChoice.swift
//  AlgebraMathMage
//
//  Created by Andrew Johnson on 8/26/22.
//

import SwiftUI

struct KeyboardMultipleChoice: View {
  
  let buttonTitles:[String]
  let problemNavigator:ProblemNavigatorView
  
  var body: some View {
    ForEach(Array(buttonTitles.enumerated()), id: \.element) {
      answerIndex, title in
      Button(action:
              { withAnimation { problemNavigator.checkAnswer(answerIndex: answerIndex) }}
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
