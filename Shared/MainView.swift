//
//  ContentView.swift
//  Shared
//
//  Created by Andrew Johnson on 8/14/22.
//

import KeychainSwift
import SwiftUI

struct MainView: View {
  
  @State var problemIndex = API.getLastQuestion()[APIKeys.problemIndex] ?? 0
  @State var sectionIndex = API.getLastQuestion()[APIKeys.sectionIndex] ?? 0
  @State var chapterIndex = API.getLastQuestion()[APIKeys.chapterIndex] ?? 0
  @State var showSectionCompletion = false
  @State var showChapterCompletion = false

  let animationDuration = 0.3
  
  var body: some View {
        ZStack(alignment: .leading) {
          if (self.showSectionCompletion) {
            CompletionViewSection(showSectionCompletion: $showSectionCompletion)
            .transition(.scale)
          } else if (self.showChapterCompletion) {
            CompletionViewChapter(showChapterCompletion: $showChapterCompletion)
              .transition(.scale)
          } else {
            ProblemNavigator(problemIndex:$problemIndex,
                             sectionIndex:$sectionIndex,
                             chapterIndex: $chapterIndex,
                             showSectionCompletion:$showSectionCompletion,
                             showChapterCompletion:$showChapterCompletion)
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
