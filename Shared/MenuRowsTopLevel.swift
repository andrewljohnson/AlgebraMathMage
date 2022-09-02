//
//  MenuRowsTopLevel.swift
//  AlgebraMathMage
//
//  Created by Andrew Johnson on 9/1/22.
//

import SwiftUI

struct MenuRowsTopLevel: View {
  
  @Binding var showMenu:Bool
  @Binding var showMenuChapterList:Bool
  @Binding var chapterIndex:Int
  @Binding var sectionIndex:Int
  @Binding var problemIndex:Int

  var body: some View {
    Button(action:
      withAnimation {
        {
          showMenuChapterList = true
        }
      }
    )
    {
      HStack {
          Image(systemName: "list.number")
        Text(Strings.problems.capitalized)
        }
      .frame(maxWidth: .infinity, alignment: .leading)
      .padding()
    }
    // todo: remove when we implement a remote server
    #if DEBUG
    Button(action:
      withAnimation {
        {
          API.clearKeychain()
          sectionIndex = 0
          problemIndex = 0
          chapterIndex = 0
          showMenu = false
        }
      }
    )
      {
        HStack {
            Image(systemName: "minus.circle.fill")
          Text(Strings.clearData.capitalized)
          }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
      }
    #endif
  }
}
