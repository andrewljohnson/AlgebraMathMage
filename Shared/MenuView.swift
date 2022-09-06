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
        } else if showMenuSection != nil {
          MenuRowsProblems(index:$index,
                           showMenu:$showMenu,
                           showMenuChapter: showMenuChapter!,  // todo? force unwrap
                           showMenuSection: showMenuSection!)  // todo? force unwrap
        } else if showMenuChapter != nil {
          MenuRowsSections(showMenuSection: $showMenuSection,
                           showMenuChapterList: $showMenuChapterList,
                           showMenuChapter: showMenuChapter!)  // todo? force unwrap
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

