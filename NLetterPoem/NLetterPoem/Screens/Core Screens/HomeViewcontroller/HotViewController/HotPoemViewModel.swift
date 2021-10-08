import Foundation
import RxSwift

struct HotPoemViewModel {
  private let poem: NLPPoem
  
  var topic: String {
    poem.topic
  }
  
  var shortDescription: String {
    poem.content.makeShortDescription()
  }
  
  var author: String {
    poem.author
  }
  
  init(poem: NLPPoem) {
    self.poem = poem
  }
}
