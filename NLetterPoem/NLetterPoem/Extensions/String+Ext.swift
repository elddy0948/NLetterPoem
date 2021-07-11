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
}
