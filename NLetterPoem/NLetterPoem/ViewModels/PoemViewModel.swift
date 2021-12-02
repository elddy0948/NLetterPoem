import Foundation

struct PoemViewModel {
  private let poem: NLPPoem
  
  init(_ poem: NLPPoem) {
    self.poem = poem
  }
  
  var author: String {
    return poem.author
  }
  
  var content: String {
    return poem.content
  }
  
  var topic: String {
    return poem.topic
  }
  
  var authorEmail: String {
    return poem.authorEmail
  }
  
  var id: String {
    return poem.id
  }
  
  var selectedPoem: NLPPoem {
    return poem
  }
}
