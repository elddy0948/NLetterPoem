import UIKit
import Firebase

protocol CreatePoemViewControllerDelegate: AnyObject {
  func createPoemViewController(_ viewController: CreatePoemViewController, didTapDone poem: NLPPoem)
}

class CreatePoemViewController: CreatorViewController {
  
  enum ActionType {
    case edit
    case create
  }
  
  //MARK: - Views
  private(set) var createPoemView: CreatePoemView!
  
  //MARK: - Properties
  var topic: String?
  var action: ActionType = .create
  var editPoem: NLPPoem?
  
  private var handler: AuthStateDidChangeListenerHandle?
  weak var delegate: CreatePoemViewControllerDelegate?
  
  //MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    configure()
  }
  
  //MARK: - Privates
  private func configure() {
    view.backgroundColor = .systemBackground
    guard let topic = topic else { return }
    
    createPoemView = CreatePoemView(topic: topic, poem: editPoem)
    createPoemView.delegate = self
    
    view.addSubview(createPoemView)
    
    NSLayoutConstraint.activate([
      createPoemView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      createPoemView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      createPoemView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      createPoemView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])
  }
  
  private func createPoem(_ nlpPoem: NLPPoem) {
    showLoadingView()
    DispatchQueue.global(qos: .utility).async { [weak self] in
      guard let self = self  else { return }
      PoemDatabaseManager.shared.create(nlpPoem) { result in
        self.dismissLoadingView()
        switch result {
        case .success(_):
          self.showAlert(title: "🎉", message: "멋진 시네요!") { _ in
            self.dismiss(animated: true, completion: nil)
          }
        case .failure(let error):
          self.showAlert(title: "⚠️", message: error.message) { _ in
            self.dismiss(animated: true, completion: nil)
          }
        }
      }
    }
  }
  
  private func updatePoem(_ nlpPoem: NLPPoem) {
    showLoadingView()
    DispatchQueue.global(qos: .utility).async { [weak self] in
      guard let self = self else { return }
      self.dismissLoadingView()
      PoemDatabaseManager.shared.update(nlpPoem) { result in
        switch result {
        case .success(let poem):
          self.showAlert(title: "✅", message: "업데이트 완료!") { _ in
            self.delegate?.createPoemViewController(self, didTapDone: poem)
            self.dismiss(animated: true, completion: nil)
          }
        case .failure(let error):
          self.showAlert(title: "⚠️", message: error.message) { _ in
            self.dismiss(animated: true, completion: nil)
          }
        }
      }
    }
  }
}

//MARK: - CreatePoemViewDelegate
extension CreatePoemViewController: CreatePoemViewDelegate {
  func createPoemView(_ createPoemView: CreatePoemView, emptyFieldExist message: String) {
    showAlert(title: "⚠️", message: message, action: nil)
  }
  
  func createPoemView(_ createPoemView: CreatePoemView, specialCharacterExist message: String) {
    showAlert(title: "⚠️", message: message, action: nil)
  }
  
  func createPoemView(_ createPoemView: CreatePoemView, didCancel button: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }
  
  func createPoemView(_ createPoemView: CreatePoemView, didTapDone button: UIBarButtonItem, poem: String) {
    let nlpPoem: NLPPoem?
    
    guard let user = user,
          let topic = topic else {
      dismiss(animated: true, completion: nil)
      return
    }
    
    if action == .edit {
      nlpPoem = editPoem
      nlpPoem?.content = poem
    } else {
      nlpPoem = NLPPoem(topic: topic,
                        author: user.nickname,
                        authorEmail: user.email,
                        content: poem,
                        ranking: Int.max)
    }
    
    guard let nlpPoem = nlpPoem else { return }
    
    switch action {
    case .create:
      createPoem(nlpPoem)
    case .edit:
      updatePoem(nlpPoem)
    }
  }
}
