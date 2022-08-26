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
  let problemNavigator:ProblemNavigatorView
  @State var answerString = ""
  
  var body: some View {
    if let sections = API.loadCurriculum() {
      let section = sections[problemNavigator.sectionIndex]
      let problems = section.problems
      let problem = problems[problemNavigator.problemIndex]
      let textPrompt = problem.prompt
      let textFormula =  problem.formula
      let textHint = problem.hint
      let buttonTitles:[String] = problem.buttonTitles ?? []
      VStack {
        Spacer()
        Text(textPrompt)
          .padding()
          .font(.largeTitle)
          .transition(.scale)
          .id(textPrompt)
        if (problem.type == APIKeys.multipleChoice) {
          Text(textFormula)
            .padding()
            .font(.title)
            .padding([.bottom], Style.paddingBelowPrompt)
            .transition(.scale)
            .id(textFormula)
        } else {
          HStack {
            Text(textFormula)
              .padding()
              .font(.title)
              .transition(.scale)
              .id(textFormula)
            Text(answerString)
              .fontWeight(.bold)
              .padding()
              .font(.title)
              .transition(.scale)
              .overlay(
                Rectangle()
                  .stroke(Style.colorMain, lineWidth: Style.inputStrokeWidth)
              )
              .id("number_answer")
          }
          .padding([.bottom], Style.paddingBelowPrompt)

        }
        HStack {
          if (problem.type == APIKeys.multipleChoice) {
            KeyboardMultipleChoice(buttonTitles:buttonTitles, problemNavigator:problemNavigator)
          } else {
            KeyboardIntegers(answerString: $answerString, problemNavigator: problemNavigator)
          }
        }
        if (problemNavigator.showHint) {
          HStack { Text("\(Strings.hint.capitalized): "); Text(textHint) }
        } else {
          Text("")
            .frame(minHeight: 20)
        }
        Spacer()
      }
    }
  }
}
