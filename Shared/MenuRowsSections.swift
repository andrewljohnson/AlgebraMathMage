//
//  MenuRowsSections.swift
//  AlgebraMathMage
//
//  Created by Andrew Johnson on 9/1/22.
//

import SwiftUI

struct MenuRowsSections: View {
  
  @Binding var showMenuChapter:Int
  @Binding var showMenuSection:Int
  @Binding var sectionIndex:Int
  @Binding var showMenuChapterList:Bool

  var body: some View {
    if let curriculum = API.loadCurriculum() {
      let chapter = curriculum.chapters[showMenuChapter]
      ForEach(Array(chapter.sections.enumerated()), id: \.element) {
        sectionNumber, section in
        Button(action:
          {
            withAnimation {
              showMenuSection = sectionNumber
              showMenuChapterList = false
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
  }
}
