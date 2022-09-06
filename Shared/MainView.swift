//
//  ContentView.swift
//  Shared
//
//  Created by Andrew Johnson on 8/14/22.
//

import KeychainSwift
import SwiftUI

struct MainView: View {
  @State var problemIndex = API.getLastQuestion()
  @State var showSectionCompletion = false
  @State var showSectionFailure = false
  @State var showChapterCompletion = false

  let animationDuration = 0.3
  
  var body: some View {
      ZStack(alignment: .leading) {
        if (self.showSectionFailure) {
          FailureViewSection(showSectionFailure: $showSectionFailure)
          .transition(.scale)
        } else if (self.showSectionCompletion) {
          CompletionViewSection(showSectionCompletion: $showSectionCompletion)
          .transition(.scale)
        } else if (self.showChapterCompletion) {
          CompletionViewChapter(showChapterCompletion: $showChapterCompletion)
            .transition(.scale)
        } else {
          ProblemNavigator(index:$problemIndex,
                           showSectionFailure:$showSectionFailure,
                           showSectionCompletion:$showSectionCompletion,
                           showChapterCompletion:$showChapterCompletion)
            .transition(AnyTransition.scale.animation(.easeInOut(duration: animationDuration)))
      }
    }
      .onAppear(perform: API.printKeychain)
  }
}

struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        MainView()
          .previewInterfaceOrientation(.landscapeLeft)
  }
}
