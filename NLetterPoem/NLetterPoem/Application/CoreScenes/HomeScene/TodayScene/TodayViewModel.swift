import Foundation
import RxSwift

final class TodayViewModel: ViewModelType {
  struct Input {
    let trigger: Observable<Void>
  }
  
  struct Output {
    let poems: Observable<[Poem]>
  }
  
  private let usecase: PoemUseCase
  private var query: NLetterQuery?
  
  init(usecase: PoemUseCase) {
    self.usecase = usecase
    self.query = nil
  }
  
  func transform(input: Input) -> Output {
    let poems = input.trigger.flatMapLatest({ _ in
      return self.usecase
        .readPoems(
          query: self.query, by: "created", limit: 10
        ).map({ (query, poems) -> [Poem] in
          self.query = query
          return poems
        })
    })
    return Output(poems: poems)
  }
  
  func resetQuery() {
    query = nil
  }
}
