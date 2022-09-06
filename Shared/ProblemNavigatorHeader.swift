//
//  ProblemNavigatorHeader.swift
//  AlgebraMathMage
//
//  Created by Andrew Johnson on 9/2/22.
//

//
//  ProblemNavigator.swift
//  AlgebraMathMage
//
//  Created by Andrew Johnson on 8/19/22.
//

import SwiftUI

struct ProblemNavigatorHeader: View {
  
  @Binding var index:CurriculumIndex;
  @Binding var showMenu:Bool;
  @Binding var showVideo:Bool;

  var body: some View {
    if let curriculum = API.loadCurriculum(), let chapter = API.chapterForID(chapterID: index.chapterID), let section = API.sectionForID(chapterID: index.chapterID, sectionID: index.sectionID) {
      let chapters = curriculum.chapters
      let sections = chapter.sections
      let problemIDs = section.problemIDs
      if let chapterIndex = chapters.firstIndex(of: chapter), let sectionIndex = sections.firstIndex(of: section), let problemIndex = section.problemIDs.firstIndex(of: index.problemID) {
      
        GeometryReader { geometry in
            VStack {
              HStack {
                Image("dalle-icon")
                Text("\(Strings.chapter.capitalized) \(chapterIndex + 1) / \(chapters.count) - \(chapter.chapterTitle)")
                  .padding([.trailing], Style.padding)
                Text("\(Strings.section.capitalized) \(sectionIndex + 1) / \(sections.count) - \(section.sectionTitle)")
                  .padding([.trailing], Style.padding)
                Text("\(Strings.problem.capitalized) \(problemIndex + 1) / \(problemIDs.count)")
                Spacer()
                Button(action: { withAnimation { showMenu = !showMenu } })
                {
                  Image(systemName: "person")
                    .foregroundColor(.white)
                    .imageScale(.large)
                }
              }
                .padding()
                .background(Style.colorMain)
                .foregroundColor(.white)
              Button(action: withAnimation {{ showVideo = true }})
              {
                HStack {
                  Image(systemName: "play")
                  Text(Strings.playHelperVideo.capitalized)
                }
                  .foregroundColor(Style.colorMain)
                  .frame(maxWidth: .infinity, alignment: .leading)
                  .padding()
              }
            }
          }
        }
      }
    }
  }
