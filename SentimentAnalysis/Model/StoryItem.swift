//
//  Model.swift
//  SentimentAnalysis
//
//  Created by Devangi Prajapati on 26/08/22.
//

import Foundation

struct StoryItem : Identifiable, Codable {
  let by: String
  let id: Int
  let kids: [Int]?
  let title: String?
  
  private enum CodingKeys: String, CodingKey {
    case by, id, kids, title
  }
}
