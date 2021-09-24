import UIKit
import Firebase

final class CreateTopicViewController: DataLoadingViewController {
  
  //MARK: - Views
  private(set) var createTopicView: CreateTopicView!
  private(set) var cantCreatePoemView: CantCreatePoemView!
  
  var user: User?
  
  //MARK: - Life cycles
  override func viewDidLoad() {
    super.viewDidLoad()
    guard let user = user else { return }
    checkUserDidWritePoemToday(with: user.email)
    configureNavigationItem()
  }
  
  private func checkUserDidWritePoemToday(with email: String?) {
    showLoadingView()
    guard let email = email else { return }
    DispatchQueue.global(qos: .userInitiated).async {
      PoemDatabaseManager.shared.read(email) { [weak self] result in
        guard let self = self else { return }
        self.dismissLoadingView()
        switch result {
        case .success(_):
          self.configureCantCreatePoemView()
        case .failure(_):
          self.configureCreateTopicView()
        }
      }
    }
  }
  
  private func configureNavigationItem() {
    navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonAction(_:)))
    navigationItem.leftBarButtonItem?.tintColor = .label
  }
  
  private func configureCantCreatePoemView() {
    cantCreatePoemView = CantCreatePoemView()
    self.view = cantCreatePoemView
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
      self.showAlert(title: "⚠️", message: "주제를 입력해주세요!\n특수문자는 사용이 불가능합니다!", action: nil)
      return
    }
    
    let createPoemViewController = CreatePoemViewController()
    createPoemViewController.topic = topic
    navigationController?.pushViewController(createPoemViewController, animated: true)
  }
}
