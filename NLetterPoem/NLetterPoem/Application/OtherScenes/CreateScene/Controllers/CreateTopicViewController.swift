import UIKit
import Firebase

final class CreateTopicViewController: CreatorViewController {
  
  //MARK: - Views
  private(set) var createTopicView: CreateTopicView!
  
  //MARK: - Life cycles
  override func viewDidLoad() {
    super.viewDidLoad()
    configureNavigationItem()
    configureCreateTopicView()
  }
  
  private func configureNavigationItem() {
    if navigationItem.leftBarButtonItem == nil {
      navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonAction(_:)))
      navigationItem.leftBarButtonItem?.tintColor = .label
    }
  }
  private func configureCreateTopicView() {
    createTopicView = CreateTopicView()
    self.view = createTopicView
    
    createTopicView.delegate = self
  }
  
  @objc func cancelButtonAction(_ sender: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }
}

//MARK: - CreateTopicViewDelegate
extension CreateTopicViewController: CreateTopicViewDelegate {
  func createTopicView(_ createTopicView: CreateTopicView, didTapNext topic: String?) {
    guard let topic = topic,
          topic != "" else {
      self.showAlert(
        title: "⚠️",
        message: "주제를 입력해주세요!\n특수문자는 사용이 불가능합니다!",
        action: nil
      )
      return
    }
    
    let createPoemViewController = CreatePoemViewController(
      NLPTopic(topic: topic),
      poem: nil
    )
    
    createPoemViewController.user = user
    
    navigationController?.pushViewController(
      createPoemViewController,
      animated: true
    )
  }
}
