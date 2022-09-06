//
//  MenuRowsSections.swift
//  AlgebraMathMage
//
//  Created by Andrew Johnson on 9/1/22.
//

import SwiftUI

struct MenuRowsSections: View {
  
  @Binding var showMenuSection:Section?
  @Binding var showMenuChapterList:Bool
  let showMenuChapter:Chapter

  var body: some View {
    ForEach(showMenuChapter.sections, id: \.self) {
      section in
      Button(action:
        {
          withAnimation {
            showMenuSection = section
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
