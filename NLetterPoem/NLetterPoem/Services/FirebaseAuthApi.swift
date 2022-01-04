//
//  FirebaseAuthService.swift
//  NLetterPoem
//
//  Created by 김호준 on 2021/12/14.
//

import Foundation
import FirebaseAuth
import RxSwift


class FirebaseAuthApi {
  static let shared = FirebaseAuthApi()
  
  private let auth = Auth.auth()
  private let bag = DisposeBag()
  
  private init() { }
  
  func setupStateChangeListener() -> Observable<User> {
    return auth.rx.configureStateChangeListener()
  }
}
