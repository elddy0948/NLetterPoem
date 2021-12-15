//
//  TopicViewModel.swift
//  NLetterPoem
//
//  Created by 김호준 on 2021/12/02.
//

import Foundation
import RxSwift

struct TopicViewModel {
  private let topic: NLPTopic
  private let service = FirestoreTopicService.shared
  
  init(topic: NLPTopic = NLPTopic(topic: "")) {
    self.topic = topic
  }
  
  func fetchTopic(
    _ date: Date
  ) -> Observable<TopicViewModel> {
    service.fetchTopic(date)
      .map({ topic in
        return TopicViewModel(topic: topic)
      })
  }
}

extension TopicViewModel {
  var topicDescription: String {
    return topic.topic
  }
}
