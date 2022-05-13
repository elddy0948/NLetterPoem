import UIKit

protocol PoemCreator: AnyObject {
  var user: NLetterPoemUser? { get set }
}

class CreatorViewController: DataLoadingViewController, PoemCreator {
  var user: NLetterPoemUser?
}
