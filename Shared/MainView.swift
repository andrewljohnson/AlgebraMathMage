//
//  ContentView.swift
//  Shared
//
//  Created by Andrew Johnson on 8/14/22.
//

import KeychainSwift
import SwiftUI

struct MainView: View {
  
  @State var problemIndex = API.getLastQuestion()[APIKeys.sectionIndex] ?? 0
  @State var sectionIndex = API.getLastQuestion()[APIKeys.problemIndex] ?? 0
  @State var showSectionCompletion = false
  
  let animationDuration = 0.3
  
  var body: some View {
        ZStack(alignment: .leading) {
          if (self.showSectionCompletion) {
            SectionCompletionView(showSectionCompletion: $showSectionCompletion)
              .transition(.scale)
          } else {
            ProblemNavigator(problemIndex:$problemIndex,
                             sectionIndex:$sectionIndex,
                             showSectionCompletion:$showSectionCompletion)
              .transition(AnyTransition.scale.animation(.easeInOut(duration: animationDuration)))
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
