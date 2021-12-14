//
//  UserViewModel.swift
//  NLetterPoem
//
//  Created by 김호준 on 2021/12/02.
//

import Foundation
import RxSwift

final class UserViewModel {
  let userSubject: BehaviorSubject<NLPUser>
  private let service = FirestoreUserService.shared
  private let bag = DisposeBag()
  
  init(_ user: NLPUser = .empty) {
    userSubject = BehaviorSubject<NLPUser>(value: user)
  }
  
  func fetchUser(email: String) {
    service.read(email)
      .subscribe(onNext: { [weak self] user in
        guard let self = self else { return }
        if let user = user {
          self.userSubject.onNext(user)
        }
      }, onError: { error in
      }, onCompleted: {
      }, onDisposed: {
      })
      .disposed(by: bag)
  }
}

extension UserViewModel {
  var user: NLPUser {
    do {
      return try userSubject.value()
    } catch {
      return NLPUser(email: "", nickname: "", bio: "")
    }
  }
  
  var email: String {
    return user.email
  }
  
  var nickname: String {
    return user.nickname
  }
  
  var bio: String {
    return user.bio
  }
  
  var fires: Int {
    return user.fires
  }
  
  var poems: [String] {
    return user.poems
  }
  
  var likedPoems: [String] {
    return user.likedPoem
  }
  
  var blockedUser: [String] {
    return user.blockedUser
  }
}
