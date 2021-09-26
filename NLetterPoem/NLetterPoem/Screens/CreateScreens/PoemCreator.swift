import UIKit

protocol PoemCreator: AnyObject {
  var user: NLPUser? { get set }
}

class CreatorViewController: DataLoadingViewController, PoemCreator {
  var user: NLPUser?
}
