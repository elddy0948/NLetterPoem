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
  
  func fetchPoems(_ email: String) {
    service
      .fetchPoems(query: (
        "authorEmail", email
      ))
      .map({ results in
        results
          .sorted(by: {
            $0.created > $1.created
          })
          .map({ poem in
            return PoemViewModel(poem)
          })
      })
      .subscribe(onNext: { [weak self] poemViewModels in
        guard let self = self else { return }
        self.poemListSubject.onNext(poemViewModels)
      })
      .disposed(by: bag)
  }
  
  func fetchPoems(
    order: (by: String, descending: Bool),
    limit: Int
  ) {
    service
      .fetchPoems(order: order, limit: limit)
      .map({ results in
        results.map({ poem in
          return PoemViewModel(poem)
        })
      })
      .subscribe(onNext: { [weak self] poemViewModels in
        guard let self = self else { return }
        self.poemListSubject.onNext(poemViewModels)
      })
      .disposed(by: bag)
  }
}

extension PoemListViewModel {
  var poemListViewModels: [PoemViewModel] {
    do {
      return try poemListSubject.value()
    } catch {
      return []
    }
  }
  
  var count: Int {
    return poemListViewModels.count
  }
  
  func selectedPoem(at index: Int) -> PoemViewModel {
    return poemListViewModels[index]
  }
  
  func poemViewModel(at index: Int) -> PoemViewModel {
    return poemListViewModels[index]
  }
}
