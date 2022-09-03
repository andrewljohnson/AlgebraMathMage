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
  
  @Binding var problemIndex:Int;
  @Binding var sectionIndex:Int;
  @Binding var chapterIndex:Int;
  @Binding var showMenu:Bool;
  @Binding var showVideo:Bool;

  var body: some View {
    if let curriculum = API.loadCurriculum() {
      let chapters = curriculum.chapters
      let chapter = chapters[chapterIndex]
      let sections = chapter.sections
      let section = sections[sectionIndex]
      let problemIDs = section.problemIDs
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
