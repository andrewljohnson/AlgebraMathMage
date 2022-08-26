//
//  SectionComplete.swift
//  AlgebraMathMage
//
//  Created by Andrew Johnson on 8/18/22.
//

import SwiftUI

struct SectionCompletionView: View {

  @Binding var showSectionCompletion:Bool;

  var body: some View {
    VStack {
      Spacer()
      Text(Strings.sectionCompleteCongratulations)
        .foregroundColor(Style.colorMain)
        .frame(maxWidth: .infinity)
        .font(.largeTitle)
      Button(action:
        withAnimation {{
        showSectionCompletion = false
        }})
      {
        Text(Strings.continueToNextSection)
          .fontWeight(.bold)
          .font(.largeTitle)
          .background(.white)
          .foregroundColor(Style.colorMain)
          .frame(width:Style.buttonSize * 5, height:Style.buttonSize)
          .overlay(
            RoundedRectangle(cornerRadius: Style.padding)
              .stroke(Style.colorMain, lineWidth: Style.buttonStrokeWidth)
          )
      }
      .padding()
      Spacer()
    }
  }
}
