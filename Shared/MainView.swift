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
  @State var showMenu = false
  @State var showSectionCompletion = false

  var body: some View {
    GeometryReader { geometry in
        ZStack(alignment: .leading) {
          if (self.showSectionCompletion) {
            SectionCompletionView(owner:self)
              .transition(.scale)
          } else {
            ProblemView(problemIndex:$problemIndex, sectionIndex:$sectionIndex, showSectionCompletion:$showSectionCompletion, showMenu:$showMenu)
            .frame(width: self.showMenu ? geometry.size.width/4*3: geometry.size.width, height: geometry.size.height)
            .zIndex(1)
          if self.showMenu {
              MenuView(owner: self)
                .background(.black)
                .frame(width: geometry.size.width/4, height: geometry.size.height)
                .offset(x: geometry.size.width/4*3)
                .transition(.move(edge: .trailing))
                .zIndex(2)
          }
        }
      }}
  }
}

struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        MainView()
          .previewInterfaceOrientation(.landscapeLeft)
  }
}
