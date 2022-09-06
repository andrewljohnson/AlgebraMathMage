//
//  MenuRowsProblems.swift
//  AlgebraMathMage
//
//  Created by Andrew Johnson on 9/1/22.
//

import SwiftUI

struct MenuRowsProblems: View {
  
  @Binding var index:CurriculumIndex
  @Binding var showMenu:Bool
  let showMenuChapter:Chapter
  let showMenuSection:Section

  var body: some View {
    Text("\(showMenuSection.sectionTitle)")
      .frame(maxWidth: .infinity, alignment: .leading)
      .font(.title)
    ForEach(API.problemsForIDs(problemIDs: showMenuSection.problemIDs), id: \.self) {
      problem in
      Button(action:
        {
          withAnimation {
            index = CurriculumIndex(chapterID: showMenuChapter.id, sectionID: showMenuSection.id, problemID: problem.id)
            showMenu = false
          }
        }
      )
        {
          Text(index.sectionID == showMenuSection.id && problem.id == index.problemID ? "\(API.titleForProblem(problem:problem)) (\(Strings.currentProblem.capitalized)" : "\(API.titleForProblem(problem:problem))")
            .frame(alignment: .leading)
            .multilineTextAlignment(.leading)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .foregroundColor(index.sectionID == showMenuSection.id && problem.id == index.problemID ? .green : .white)
    }
  }
}
