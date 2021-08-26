import UIKit

class CreateTopicViewController: UIViewController {
  
  //MARK: - Views
  private(set) var createTopicView: CreateTopicView!
  private(set) var cantCreatePoemView: CantCreatePoemView!
  
  //MARK: - Life cycles
  override func viewDidLoad() {
    super.viewDidLoad()
    configureNavigationItem()
    configureCreateTopicView()
  }
  
  private func configureNavigationItem() {
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonAction(_:)))
    navigationItem.leftBarButtonItem?.tintColor = .label
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
    //TODO: - 특수문자 불가능하게 해주기
    // - 글자수 제한
    guard let topic = topic,
          topic != "" else {
      self.showAlert(title: "⚠️", message: "주제를 입력해주세요!", action: nil)
      return
    }
    
    let createPoemViewController = CreatePoemViewController()
    createPoemViewController.topic = topic
    navigationController?.pushViewController(createPoemViewController, animated: true)
  }
}
