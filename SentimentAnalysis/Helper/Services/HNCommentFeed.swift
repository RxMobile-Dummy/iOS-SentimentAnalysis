//
//  HNCommentFeed.swift
//  SentimentAnalysis
//
//  Created by Devangi Prajapati on 26/08/22.
//

import Foundation
import Combine
import NaturalLanguage

class HNCommentFeed : ObservableObject {
  let nlTagger = NLTagger(tagSchemes : [.sentimentScore])
  let didChange = PassthroughSubject<Void , Never>()
  var cancellable : Set<AnyCancellable> = Set()
  
  @Published var sentimentAvg : String = ""
  
  var comments = [CommentItem]() {
    didSet {
      var sumSentiments : Float = 0.0
      
      for item in comments {
        let floatValue = (item.sentimentScore as NSString).floatValue
        sumSentiments += floatValue
      }
      
      let ave = (sumSentiments) / Float(comments.count)
      sentimentAvg = String(format: "%.2f", ave)
      didChange.send()
    }
  }
  
  private var commentIds = [Int]() {
    didSet {
      fetchComments(ids : commentIds.prefix(10))
    }
  }
  
  func fetchComments<S>(ids: S) where S: Sequence, S.Element == Int{
    
    Publishers.MergeMany(ids.map{FetchComment(id: $0, nlTagger: nlTagger)})
      .collect()
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: {
        if case let .failure(error) = $0 {
          print(error)
        }
      }, receiveValue: {
        
        self.comments = self.comments + $0
      })
      .store(in: &cancellable)
  }
  
  func getIds(ids: [Int]){
    self.commentIds = ids
  }
  
}
