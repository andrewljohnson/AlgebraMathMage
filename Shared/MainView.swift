//
//  ContentView.swift
//  Shared
//
//  Created by Andrew Johnson on 8/14/22.
//

import SwiftUI

struct MainView: View {
  
  @State var showMenu = false
  @State var showMenuSectionList = false
  @State var showMenuSection = -1

  @State var sectionIndex = 0
  @State var problemIndex = 0
  
  func checkAnswer (problems:[Any], answerChoice:Int, correctAnswer:Int) {
    if let sections = API.loadCurriculum() {
      let section = sections[sectionIndex]
      let problem = section.problems[problemIndex]
      API.saveUserAnswer(problemID: problem.id, sectionID: section.id, answerIndex: answerChoice)
      API.printKeychain()
      if (answerChoice == correctAnswer) {
        problemIndex += 1
      }
      if (problemIndex >= problems.count) {
        problemIndex = 0
        sectionIndex += 1
        if (sectionIndex >= sections.count) {
          sectionIndex = 0
        }
      }
    }

  }
  
  var ProblemView: some View {
    if let sections = API.loadCurriculum() {
      let section = sections[sectionIndex]
      let problems = section.problems
      let problem = problems[problemIndex]
      let correctAanswer = problem.answer
      let textPrompt = problem.prompt
      let textFormula =  problem.formula
      let buttonTitles:[String] = problem.buttonTitles
      return AnyView(VStack {
        HStack {
          Image(systemName: "star")
                  .imageScale(.large)
          Text("\(Strings.sectionTitleString) \(sectionIndex + 1) / \(sections.count)")
            .padding([.trailing], Style.padding)
          Text("\(Strings.problemTitleString) \(problemIndex + 1) / \(problems.count)")
          Spacer()
          Button(
            action:
              {
                withAnimation { self.showMenu = !self.showMenu }
              }
          )
          {
            Image(systemName: "person")
                    .foregroundColor(.white)
                    .imageScale(.large)
          }
        }
          .padding()
          .background(Style.mainColor)
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
                    { withAnimation {checkAnswer(problems: problems, answerChoice: answerChoice, correctAnswer: correctAanswer)}})
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
        Spacer()
      }
      )
    }
    return AnyView(EmptyView())
  }

  var MenuView: some View {
    return AnyView(
      VStack {
        if (showMenuSection > -1) {
          if let sections = API.loadCurriculum() {
            let section = sections[showMenuSection]
            ForEach(Array(section.problems.enumerated()), id: \.element) {
              problemNumber, problem in
              Button(action:
                {
                  withAnimation {
                    problemIndex = problemNumber
                    sectionIndex = showMenuSection
                    showMenu = false
                    showMenuSection = -1
                  }
                }
              )
                {
                  Text(sectionIndex == showMenuSection && problemNumber == problemIndex ? "\(problemNumber) (current problem)" : "\(problemNumber)")
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .foregroundColor(sectionIndex == showMenuSection && problemNumber == problemIndex ? .green : .white)
            }
            
          }
        } else if (showMenuSectionList) {
          if let sections = API.loadCurriculum() {
            ForEach(Array(sections.enumerated()), id: \.element) {
              sectionNumber, section in
              Button(action:
                {
                  withAnimation {
                    showMenuSection = sectionNumber
                    showMenuSectionList = false
                  }
                }
              )
                {
                  Text(section.sectionTitle)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
          }
        } else {
          Button(action:
            withAnimation {
              {
                showMenuSectionList = true
              }
            }
          )
            {
              HStack {
                  Image(systemName: "list.number")
                  Text("Problems")
                }
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding()
            }
          // todo: remove when we implement a remote server
          #if DEBUG
          Button(action:
            withAnimation {
              {
                API.clearKeychain()
                showMenu = false
              }
            }
          )
            {
              HStack {
                  Image(systemName: "minus.circle.fill")
                  Text("Clear Data")
                }
              .frame(maxWidth: .infinity, alignment: .leading)
              .padding()
            }
          #endif
        }
        Spacer()
      }
        .foregroundColor(.white)
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
    )
  }
  
  var body: some View {
    GeometryReader { geometry in
      ZStack(alignment: .leading) {
        ProblemView
          .frame(width: self.showMenu ? geometry.size.width/4*3: geometry.size.width, height: geometry.size.height)
        if self.showMenu {
            MenuView
              .background(.black)
              .frame(width: geometry.size.width/4, height: geometry.size.height)
              .offset(x: geometry.size.width/4*3)
              .transition(.move(edge: .trailing))

        }
      }
    }
  }
}

struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        MainView(showMenu:true)
          .previewInterfaceOrientation(.landscapeLeft)
  }
}
