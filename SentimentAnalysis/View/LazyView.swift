//
//  LazyView.swift
//  SentimentAnalysis
//
//  Created by Devangi Prajapati on 26/08/22.
//

import SwiftUI
import Combine

struct LazyView<Content: View>: View {
  let build: () -> Content
  init(_ build: @autoclosure @escaping () -> Content) {
      self.build = build
  }
  var body: Content {
      build()
  }
}
