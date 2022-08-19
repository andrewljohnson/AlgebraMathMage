//
//  ContentView.swift
//  Shared
//
//  Created by Andrew Johnson on 8/14/22.
//

import KeychainSwift
import SwiftUI

struct MainView: View {
  
  @State var problemIndex = API.getLastQuestion()["problemIndex"] ?? 0
  @State var sectionIndex = API.getLastQuestion()["sectionIndex"] ?? 0
  @State var showSectionCompletion = false

  var body: some View {
        ZStack(alignment: .leading) {
          if (self.showSectionCompletion) {
            SectionCompletionView(owner:self)
              .transition(.scale)
          } else {
            ProblemView(problemIndex:$problemIndex, sectionIndex:$sectionIndex, showSectionCompletion:$showSectionCompletion)
              .transition(AnyTransition.scale.animation(.easeInOut(duration: 0.3)))
        }
      }
  }
}

struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        MainView()
          .previewInterfaceOrientation(.landscapeLeft)
  }
}
