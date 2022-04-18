import Foundation
import RxSwift
import RxCocoa
import Firebase

class HotViewModel: ViewModelType {
  //MARK: - Input
  struct Input {
    var fetchNextPoems: Observable<Void>
  }
  
  //MARK: - Output
  struct Output {
    var poems: Driver<[NLPPoem]>
  }
  
  private let currentSnapshot = PublishSubject<QueryDocumentSnapshot>()
  private let service = FirestorePoemApi.shared
  
  func transform(input: Input) -> Output {
    let poems = input.fetchNextPoems
      .withLatestFrom(self.service.fetchPoems(
        order: ("likeCount", true), limit: 25)
      )
      .map({ results -> [NLPPoem] in
        let poems = results
        print(poems)
        return poems
      })
      .asDriver(onErrorJustReturn: [])
    
    return Output(poems: poems)
  }
}
