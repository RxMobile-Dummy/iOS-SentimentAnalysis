//
//  HackerNewsView.swift
//  SentimentAnalysis
//
//  Created by Devangi Prajapati on 26/08/22.
//

import SwiftUI
import Combine

struct HackerNewsView: View {

  @ObservedObject var hnFeed = HNStoriesFeed()

  var body: some View {
    NavigationView {
      List(hnFeed.storyItems) { articleItem in
        NavigationLink(destination: LazyView(CommentView(commentIds: articleItem.kids ?? []))){
          StoryListItemView(article: articleItem)
        }
      }
      .navigationBarTitle("Hacker News Stories")
    }
  }
}

struct HackerNewsView_Previews: PreviewProvider {
    static var previews: some View {
        HackerNewsView()
    }
}
