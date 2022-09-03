//
//  FailureViewSection.swift
//  AlgebraMathMage
//
//  Created by Andrew Johnson on 9/3/22.
//

import SwiftUI

struct FailureViewSection: View {

  @Binding var showSectionFailure:Bool;

  var body: some View {
    VStack {
      Spacer()
      Text(Strings.sectionCompleteAdmonishment)
        .frame(maxWidth: .infinity)
        .font(.largeTitle)
      Button(action:
        withAnimation {{
        showSectionFailure = false
        }})
      {
        Text(Strings.redoSection.capitalized)
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

