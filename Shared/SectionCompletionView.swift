//
//  SectionComplete.swift
//  AlgebraMathMage
//
//  Created by Andrew Johnson on 8/18/22.
//

import SwiftUI

struct SectionCompletionView: View {

  let owner:MainView
  
  init(owner:MainView) {
    self.owner = owner
  }

  var SectionCompletionView: some View {
    VStack {
      Spacer()
      Text("Your completed a section! Great job!")
        .foregroundColor(Style.mainColor)
        .frame(maxWidth: .infinity)
        .font(.largeTitle)
      Button(action:
        withAnimation {{
        owner.showSectionCompletion = false
        }})
      {
        Text("Continue to Next Section")
          .fontWeight(.bold)
          .font(.largeTitle)
          .background(.white)
          .foregroundColor(Style.mainColor)
          .frame(width:Style.buttonSize * 5, height:Style.buttonSize)
          .overlay(
            RoundedRectangle(cornerRadius: Style.padding)
              .stroke(Style.mainColor, lineWidth: Style.buttonStrokeWidth)
          )
      }
      .padding()
      Spacer()
    }
  }

  var body: some View {
    SectionCompletionView
  }
}
