//
//  MenuView.swift
//  AlgebraMathMage
//
//  Created by Andrew Johnson on 8/18/22.
//

import SwiftUI

struct MenuView: View {

  @Binding var showMenu:Bool
  @Binding var sectionIndex:Int
  @Binding var problemIndex:Int
  @State private var showMenuSection = -1
  @State private var showMenuSectionList = false

  var MenuView: some View {
      VStack {
        if (showMenuSection > -1) {
          if let sections = API.loadCurriculum() {
            let section = sections[showMenuSection]
            Text("\(Strings.section.capitalized) \(showMenuSection)")
              .frame(maxWidth: .infinity, alignment: .leading)
              .font(.title)
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
                  Text(sectionIndex == showMenuSection && problemNumber == problemIndex ? "\(problemNumber) -  \(problem.prompt) (\(Strings.currentProblem.capitalized)" : "\(problemNumber) - \(problem.prompt)")
                    .frame(alignment: .leading)
                    .multilineTextAlignment(.leading)
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
              Text(Strings.problems.capitalized)
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
                sectionIndex = 0
                problemIndex = 0
                showMenu = false
              }
            }
          )
            {
              HStack {
                  Image(systemName: "minus.circle.fill")
                Text(Strings.clearData.capitalized)
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
  }

  var body: some View {
    MenuView
  }
}

