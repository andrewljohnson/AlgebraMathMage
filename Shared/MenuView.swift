//
//  MenuView.swift
//  AlgebraMathMage
//
//  Created by Andrew Johnson on 8/18/22.
//

import SwiftUI

struct MenuView: View {

  let owner:MainView
  @State private var showMenuSection = -1
  @State private var showMenuSectionList = false

  init(owner:MainView) {
    self.owner = owner
  }

  var MenuView: some View {
    return AnyView(
      VStack {
        if (showMenuSection > -1) {
          if let sections = API.loadCurriculum() {
            let section = sections[showMenuSection]
            Text("Section \(showMenuSection)")
              .frame(maxWidth: .infinity, alignment: .leading)
              .font(.title)
            ForEach(Array(section.problems.enumerated()), id: \.element) {
              problemNumber, problem in
              Button(action:
                {
                  withAnimation {
                    owner.problemIndex = problemNumber
                    owner.sectionIndex = showMenuSection
                    owner.showMenu = false
                    showMenuSection = -1
                  }
                }
              )
                {
                  Text(owner.sectionIndex == showMenuSection && problemNumber == owner.problemIndex ? "\(problemNumber) -  \(problem.prompt) (current problem)" : "\(problemNumber) - \(problem.prompt)")
                    .frame(alignment: .leading)
                    .multilineTextAlignment(.leading)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .foregroundColor(owner.sectionIndex == showMenuSection && problemNumber == owner.problemIndex ? .green : .white)
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
                owner.sectionIndex = 0
                owner.problemIndex = 0
                owner.showMenu = false
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
    MenuView
  }
}

