import Foundation

extension String {
  func makeShortDescription() -> String {
    let firstLine = self.components(separatedBy: "\n").first
    return firstLine ?? ""
  }
  
  func makePoemArray() -> [String] {
    let poemArray = self.components(separatedBy: "\n")
    return poemArray
  }
  
  func isValidPassword() -> Bool {
    let passwordRegex = "^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{8,}$"
    return NSPredicate(format: "SELF MATCHES %@", passwordRegex).evaluate(with: self)
  }
  
  
  func isValidEmail() -> Bool {
    let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
    let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
    return emailPredicate.evaluate(with: self)
  }
}
