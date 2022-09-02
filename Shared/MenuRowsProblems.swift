//
//  MenuRowsProblems.swift
//  AlgebraMathMage
//
//  Created by Andrew Johnson on 9/1/22.
//

import SwiftUI

struct MenuRowsProblems: View {
  
  @Binding var showMenuChapter:Int
  @Binding var showMenuSection:Int
  @Binding var chapterIndex:Int
  @Binding var sectionIndex:Int
  @Binding var problemIndex:Int
  @Binding var showMenu:Bool

  var body: some View {
    if let curriculum = API.loadCurriculum() {
      let chapter = curriculum.chapters[showMenuChapter]
      let section = chapter.sections[showMenuSection]
      Text("\(Strings.section.capitalized) \(showMenuSection)")
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.title)
      ForEach(Array(API.problemsForIDs(problemIDs: section.problemIDs).enumerated()), id: \.element) {
        problemNumber, problem in
        Button(action:
          {
            withAnimation {
              problemIndex = problemNumber
              sectionIndex = showMenuSection
              chapterIndex = showMenuChapter
              showMenu = false
            }
          }
        )
          {
            Text(sectionIndex == showMenuSection && problemNumber == problemIndex ? "\(problemNumber) -  \(problem.prompt ?? "") (\(Strings.currentProblem.capitalized)" : "\(problemNumber) - \(problem.prompt ?? "")")
              .frame(alignment: .leading)
              .multilineTextAlignment(.leading)
          }
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding()
          .foregroundColor(sectionIndex == showMenuSection && problemNumber == problemIndex ? .green : .white)
      }
    }
  }
}
