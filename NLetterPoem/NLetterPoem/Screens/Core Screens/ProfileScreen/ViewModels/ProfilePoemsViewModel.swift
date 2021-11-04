import Foundation

struct ProfilePoemsViewModel {
  let poems: [NLPPoem]
}

extension ProfilePoemsViewModel {
  init(_ poems: [NLPPoem]) {
    self.poems = poems
  }
}


extension ProfilePoemsViewModel {
  var numberOfPoems: Int {
    return poems.count
  }
  
  func poemAtCell(indexPath: Int) -> NLPPoem {
    return poems[indexPath]
  }
  
  func selectedPoem(at indexPath: Int) -> NLPPoem {
    return poems[indexPath]
  }
}
