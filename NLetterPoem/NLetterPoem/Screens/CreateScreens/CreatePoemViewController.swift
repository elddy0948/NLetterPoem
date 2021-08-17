import UIKit
import Firebase

protocol CreatePoemViewControllerDelegate: AnyObject {
  func createPoemViewController(_ viewController: CreatePoemViewController, didTapDone poem: NLPPoem)
}

class CreatePoemViewController: DataLoadingViewController {
  
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
  var user: NLPUser? {
    didSet {
      configure()
    }
  }
  
  private var handler: AuthStateDidChangeListenerHandle?
  weak var delegate: CreatePoemViewControllerDelegate?
  
  //MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    setHandlerAndFetchUserInfo()
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
  
  private func setHandlerAndFetchUserInfo() {
    handler = Auth.auth().addStateDidChangeListener({ [weak self] auth, user in
      guard let self = self else { return }
      guard let user = user,
            let email = user.email else {
        self.dismiss(animated: true, completion: nil)
        return
      }
      
      UserDatabaseManager.shared.fetchUserInfo(with: email) { user in
        guard let user = user else {
          return
        }
        self.user = user
      }
    })
  }
}

//MARK: - CreatePoemViewDelegate
extension CreatePoemViewController: CreatePoemViewDelegate {
  func createPoemView(_ createPoemView: CreatePoemView, didCancel button: UIBarButtonItem) {
    dismiss(animated: true, completion: nil)
  }
  
  func createPoemView(_ createPoemView: CreatePoemView, didTapDone button: UIBarButtonItem, poem: String) {
    showLoadingView()
    let dispatchQueue = DispatchQueue(label: "com.howift.createPoem")
    let dispatchGroup = DispatchGroup()
    var createPoemError: String?
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
    
    dispatchQueue.async(group: dispatchGroup, execute: {
      PoemDatabaseManager.shared.createPoem(poem: nlpPoem) { error in
        if let error = error {
          createPoemError = error.localizedDescription
        }
      }
    })
    
    if action == .create {
      dispatchQueue.async(group: dispatchGroup, execute: {
        UserDatabaseManager.shared.addPoemToUser(email: user.email, poemID: nlpPoem.id) { error in
          if let error = error {
            createPoemError = error.localizedDescription
          }
        }
      })
    }
    
    dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
      guard let self = self else { return }
      self.dismissLoadingView()
      if let error = createPoemError {
        self.showAlert(title: "⚠️", message: error, action: { _ in
          self.dismiss(animated: true, completion: nil)
        })
      } else {
        self.showAlert(title: "🎉", message: "멋진 시네요!", action: { _ in
          self.dismiss(animated: true, completion: {
            if self.action == .edit {
              self.delegate?.createPoemViewController(self, didTapDone: nlpPoem)
            }
          })
        })
      }
    }
  }
}
