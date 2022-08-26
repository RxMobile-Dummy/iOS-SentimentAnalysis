//
//  HNStoriesFeed.swift
//  SentimentAnalysis
//
//  Created by Devangi Prajapati on 26/08/22.
//

import Foundation
import Combine

class HNStoriesFeed : ObservableObject {

  @Published var storyItems = [StoryItem]()

  var urlBase =  kBASEURL

  var cancellable : Set<AnyCancellable> = Set()

  private var topStoryIds = [Int]() {
    didSet {
      fetchStoryById(ids: topStoryIds.prefix(20))
    }
  }

  init() {
    fetchTopStories()
  }

  func fetchStoryById<S>(ids : S) where S: Sequence , S.Element == Int {

    Publishers.MergeMany(ids.map{FetchItem(id: $0)})
      .collect()
      .receive(on: DispatchQueue.main)
      .sink(receiveCompletion: {
        if case let .failure(error) = $0 {
          print(error)
        }
      }, receiveValue: {
        self.storyItems = self.storyItems + $0
      })
      .store(in: &cancellable)
  }

  func fetchTopStories(){

    URLSession.shared.dataTaskPublisher(for: URL(string: "\(urlBase)")!)
      .map{$0.data}
      .decode(type: [Int].self, decoder: JSONDecoder())
      .sink(receiveCompletion: { completion in
        switch completion {
        case .failure(let error):
          print("Something went wrong: \(error)")
        case .finished:
          print("Received Completion")
        }
      }, receiveValue: { value in
        self.topStoryIds = value
      })
      .store(in: &cancellable)
  }

}
