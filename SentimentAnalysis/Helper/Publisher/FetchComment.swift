//
//  FetchComment.swift
//  SentimentAnalysis
//
//  Created by Devangi Prajapati on 26/08/22.
//

import Foundation
import Combine
import NaturalLanguage

struct FetchComment : Publisher {
  typealias Output = CommentItem
  typealias Failure = Error

  //1
      let id: Int
      let nlTagger: NLTagger

  func receive<S>(subscriber: S) where S: Subscriber, Failure == S.Failure, Output == S.Input {
        let request = URLRequest(url: URL(string: "https://hacker-news.firebaseio.com/v0/item/\(id).json")!)
        URLSession.DataTaskPublisher(request: request, session: URLSession.shared)
            .map { $0.data }
            .decode(type: CommentItem.self, decoder: JSONDecoder())
            .map{
              commentItem in

              //2
              let data = Data(commentItem.text?.utf8 ?? "".utf8)
              var commentString = commentItem.text

              if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
                commentString = attributedString.string
              }
              
              //3
              self.nlTagger.string = commentString

              var sentimentScore = ""
              if let string = self.nlTagger.string{
                //4
                let (sentiment,_) = self.nlTagger.tag(at: string.startIndex, unit: .paragraph, scheme: .sentimentScore)

                sentimentScore = sentiment?.rawValue ?? ""
              }

              //5
              let result = CommentItem(id: commentItem.id, text: commentString, sentimentScore: sentimentScore)
              return result
            }
            .print()
            .receive(subscriber: subscriber)
    }

}
