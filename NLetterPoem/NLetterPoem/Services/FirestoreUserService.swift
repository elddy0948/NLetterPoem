//
//  FirestoreUserService.swift
//  NLetterPoem
//
//  Created by 김호준 on 2021/12/01.
//

import Foundation
import FirebaseFirestore
import RxSwift

final class FirestoreUserService: FirestoreService {
  enum UserServiceError: Error {
    case invalidUser
    case invalidRequest
  }
  
  static let shared = FirestoreUserService()
  
  var database: Firestore = Firestore.firestore()
  var reference: CollectionReference
  
  private init() {
    reference = database.collection("users")
  }
  
  func create<T>(_ object: T) -> Observable<Void> where T : Encodable {
    guard let user = object as? NLPUser else {
      return Observable.error(UserServiceError.invalidUser)
    }
    
    return reference.document(user.email)
      .rx
      .setData(user)
  }
  
  func read(_ id: String) -> Observable<NLPUser?> {
    return reference.document(id)
      .rx
      .getDocument()
      .map({ document in
        if let user = try document.data(as: NLPUser.self) {
          return user
        }
        return nil
      })
  }
  
  func update<T>(_ object: T) -> Observable<Void> where T : Encodable {
    guard let user = object as? NLPUser else {
      return Observable.error(UserServiceError.invalidUser)
    }
    
    return reference.document(user.email)
      .rx
      .setData(user)
  }
  
  func delete(_ id: String) -> Observable<Void> {
    return reference.document(id)
      .rx
      .delete()
  }
}

