//
//  MenuRowsChapters.swift
//  AlgebraMathMage
//
//  Created by Andrew Johnson on 9/1/22.
//

import SwiftUI

struct MenuRowsChapters: View {
  
  @Binding var showMenuChapter:Chapter?
  @Binding var showMenuChapterList:Bool

  var body: some View {
    if let curriculum = API.loadCurriculum() {
      let chapters = curriculum.chapters
      ForEach(chapters, id: \.self) {
        chapter in
        Button(action:
          {
            withAnimation {
              showMenuChapter = chapter
              showMenuChapterList = false
            }
          }
        )
          {
            Text(chapter.chapterTitle)
          }
          .frame(maxWidth: .infinity, alignment: .leading)
          .padding()
      }
    }
  }
}
