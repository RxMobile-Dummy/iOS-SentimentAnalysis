//
//  CommentItem.swift
//  SentimentAnalysis
//
//  Created by Devangi Prajapati on 26/08/22.
//

import Foundation

struct CommentItem : Identifiable, Codable {

  let id: Int
  var text: String?
  var sentimentScore : String = ""

  private enum CodingKeys: String, CodingKey {
    case id, text
  }
}
