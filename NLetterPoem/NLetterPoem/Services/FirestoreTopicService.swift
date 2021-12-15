//
//  FirestoreTopicService.swift
//  NLetterPoem
//
//  Created by 김호준 on 2021/12/01.
//

import Foundation
import RxSwift
import Firebase


final class FirestoreTopicService {
  static let shared = FirestoreTopicService()
  
  private let firestore = Firestore.firestore()
  
  private init() { }
  
  func fetchTopic(_ date: Date) -> Observable<NLPTopic> {
    return firestore.collection("topics")
      .document("test")
      .rx
      .getDocument()
      .take(1)
      .map({ snapshot -> NLPTopic in
        do {
          let topic = try snapshot.data(
            as: NLPTopic.self
          ) ?? NLPTopic(topic: "")
          print("\(topic.topic) in service")
          return topic
        } catch {
          return NLPTopic(topic: "")
        }
      })
  }
}
