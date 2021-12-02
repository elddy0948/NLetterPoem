//
//  PoemListViewModel.swift
//  NLetterPoem
//
//  Created by 김호준 on 2021/12/01.
//

import Foundation
import RxSwift

final class PoemListViewModel {
  var service: FirestorePoemService
  var poemListSubject: BehaviorSubject<[PoemViewModel]>
  private let bag = DisposeBag()
  
  init(_ service: FirestorePoemService) {
    self.service = service
    poemListSubject = BehaviorSubject<[PoemViewModel]>(
      value: []
    )
  }
  
  func fetchPoems(
    _ date: Date) {
    let stringDate = date.toYearMonthDay()
    
    service
      .fetchPoems(query: (
        "createdAt", stringDate
      ))
      .map({ results in
        results.map({ poem in
          return PoemViewModel(poem)
        })
      })
      .subscribe(onNext: { [weak self] poemViewModels in
        guard let self = self else { return }
        self.poemListSubject.onNext(poemViewModels)
      }, onError: { error in
        print(error.localizedDescription)
      }, onCompleted: {
        print("Completed")
      }, onDisposed: {
        print("Disposed")
      })
      .disposed(by: bag)
  }
}
