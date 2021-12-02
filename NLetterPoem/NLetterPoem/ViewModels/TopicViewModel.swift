//
//  TopicViewModel.swift
//  NLetterPoem
//
//  Created by 김호준 on 2021/12/02.
//

import Foundation
import RxSwift

final class TopicViewModel {
  var topicSubject = BehaviorSubject<NLPTopic>(
    value: NLPTopic(topic: "")
  )
  
  init() { }
  
  var topicDescription: String {
    do {
      return try topicSubject.value().topic
    } catch {
      return ""
    }
  }
}
