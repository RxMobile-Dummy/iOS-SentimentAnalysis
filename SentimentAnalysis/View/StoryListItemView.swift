//
//  StoryListItemView.swift
//  SentimentAnalysis
//
//  Created by Devangi Prajapati on 26/08/22.
//

import SwiftUI

struct StoryListItemView: View {
  var article: StoryItem

  var body: some View {

    VStack(alignment: .leading) {
      Text("\(article.title ?? "")")
        .font(.headline)
      Text("Author: \(article.by)")
        .font(.subheadline)
    }
  }
}

