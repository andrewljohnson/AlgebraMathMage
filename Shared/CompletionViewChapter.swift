//
//  CompletionViewChapter.swift
//  AlgebraMathMage
//
//  Created by Andrew Johnson on 8/18/22.
//

import SwiftUI

struct CompletionViewChapter: View {

  @Binding var showChapterCompletion:Bool;

  var body: some View {
    VStack {
      Spacer()
      Text(Strings.chapterCompleteCongratulations)
        .frame(maxWidth: .infinity)
        .font(.largeTitle)
      Button(action:
        withAnimation {{
        showChapterCompletion = false
        }})
      {
        Text(Strings.continueToNextChapter)
          .fontWeight(.bold)
          .font(.largeTitle)
          .background(.white)
          .foregroundColor(Style.colorContinue)
          .frame(width:Style.buttonSize * 6, height:Style.buttonSize)
          .overlay(
            RoundedRectangle(cornerRadius: Style.padding)
              .stroke(Style.colorContinue, lineWidth: Style.buttonStrokeWidth)
          )
      }
      .padding()
      Spacer()
    }
  }
}
