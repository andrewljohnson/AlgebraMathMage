//
//  ProblemView.swift
//  AlgebraMathMage
//
//  Created by Andrew Johnson on 8/23/22.
//

import SwiftUI

struct ProblemView: View {
  
  // tightly coupled with parent so it can call checkAnswer
  // otherwise I'd just bind some variables
  // todo: ?
  let problemNavigatorView:ProblemNavigatorView
  
  var body: some View {
    if let sections = API.loadCurriculum() {
      let section = sections[problemNavigatorView.sectionIndex]
      let problems = section.problems
      let problem = problems[problemNavigatorView.problemIndex]
      let correctAnswer = problem.answer
      let textPrompt = problem.prompt
      let textFormula =  problem.formula
      let textHint = problem.hint
      let buttonTitles:[String] = problem.buttonTitles
      VStack {
        Spacer()
        Text(textPrompt)
          .padding()
          .font(.largeTitle)
          .transition(.scale)
          .id(textPrompt)
        Text(textFormula)
          .padding()
          .font(.title)
          .padding([.bottom], Style.paddingBelowPrompt)
          .transition(.scale)
          .id(textFormula)
        HStack {
          ForEach(Array(buttonTitles.enumerated()), id: \.element) {
            answerChoice, title in
            Button(action:
                    { withAnimation { problemNavigatorView.checkAnswer(problems: problems, answerChoice: answerChoice, correctAnswer: correctAnswer) }}
            )
            {
              Text(title)
                .fontWeight(.bold)
                .font(.largeTitle)
                .foregroundColor(Style.mainColor)
                .frame(width:Style.buttonSize * 2, height:Style.buttonSize)
                .overlay(
                  RoundedRectangle(cornerRadius: Style.padding)
                      .stroke(Color.purple, lineWidth: Style.buttonStrokeWidth)
                )
                .id(title)

            }
              .transition(.scale)
              .padding()
            }
         }
          if (problemNavigatorView.showHint) {
           Text(textHint)
         } else {
           Text("")
             .frame(minHeight: 20)
         }
         Spacer()
      }
    }
  }

}

