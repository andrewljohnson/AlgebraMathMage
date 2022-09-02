//
//  MenuView.swift
//  AlgebraMathMage
//
//  Created by Andrew Johnson on 8/18/22.
//

import SwiftUI

struct MenuView: View {

  @Binding var showMenu:Bool
  @Binding var chapterIndex:Int
  @Binding var sectionIndex:Int
  @Binding var problemIndex:Int
  @State private var showMenuChapterList = false
  @State private var showMenuChapter = -1
  @State private var showMenuSection = -1

  var body: some View {
    VStack {
        if (showMenuChapterList) {
          MenuRowsChapters(showMenuChapter: $showMenuChapter,
                           showMenuChapterList: $showMenuChapterList)
        } else if (showMenuSection > -1) {
          MenuRowsProblems(showMenuChapter: $showMenuChapter,
                           showMenuSection: $showMenuSection,
                           chapterIndex: $chapterIndex,
                           sectionIndex: $sectionIndex,
                           problemIndex: $problemIndex,
                           showMenu:$showMenu)
        } else if (showMenuChapter > -1) {
          MenuRowsSections(showMenuChapter: $showMenuChapter,
                           showMenuSection: $showMenuSection,
                           sectionIndex: $sectionIndex,
                           showMenuChapterList: $showMenuChapterList)
        } else {
          MenuRowsTopLevel(showMenu: $showMenu,
                           showMenuChapterList: $showMenuChapterList,
                           chapterIndex: $chapterIndex,
                           sectionIndex: $sectionIndex,
                           problemIndex: $problemIndex)
        }
        Spacer()
    }
    .foregroundColor(.white)
    .padding()
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}

