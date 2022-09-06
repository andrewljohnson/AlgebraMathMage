//
//  MenuView.swift
//  AlgebraMathMage
//
//  Created by Andrew Johnson on 8/18/22.
//

import SwiftUI

struct MenuView: View {

  @Binding var showMenu:Bool
  @Binding var index:CurriculumIndex
  @State private var showMenuChapterList = false
  @State private var showMenuChapter:Chapter? = nil
  @State private var showMenuSection:Section? = nil

  var body: some View {
    VStack {
        if showMenuChapterList {
          MenuRowsChapters(showMenuChapter: $showMenuChapter,
                           showMenuChapterList: $showMenuChapterList)
        } else if let chapter = showMenuChapter, let section = showMenuSection {
          MenuRowsProblems(index:$index,
                           showMenu:$showMenu,
                           showMenuChapter: chapter,
                           showMenuSection: section)
        } else if let chapter = showMenuChapter {
          MenuRowsSections(showMenuSection: $showMenuSection,
                           showMenuChapterList: $showMenuChapterList,
                           showMenuChapter: chapter)
        } else {
          MenuRowsTopLevel(index: $index,
                           showMenu: $showMenu,
                           showMenuChapterList: $showMenuChapterList)
        }
        Spacer()
    }
    .foregroundColor(.white)
    .padding()
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}

