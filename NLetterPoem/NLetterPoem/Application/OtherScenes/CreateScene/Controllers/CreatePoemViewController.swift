import UIKit
import Firebase
import RxSwift

protocol CreatePoemViewControllerDelegate: AnyObject {
  func createPoemViewController(
    _ viewController: CreatePoemViewController,
    didTapDone poem: Poem
  )
}

final class CreatePoemViewController: CreatorViewController {
  
  enum ActionType {
    case edit
    case create
  }
  
  //MARK: - Views
  private lazy var createPoemView: CreatePoemView = {
    let view = CreatePoemView(poem: self.poem)
    return view
  }()
  
  //MARK: - Properties
  weak var delegate: CreatePoemViewControllerDelegate?
  
  private var topic: NLetterTopic
  private var type: ActionType
  private var poem: Poem?
  private let bag = DisposeBag()
  private var globalScheduler = ConcurrentDispatchQueueScheduler(
    qos: .utility
  )
  
  //MARK: - Initializer
  init(_ topic: NLetterTopic,
       type: ActionType = .create,
       poem: Poem?
  ) {
    self.topic = topic
    self.type = type
    self.poem = poem
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    self.topic = NLetterTopic(topic: "")
    self.type = .create
    super.init(coder: coder)
  }
  
  //MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    
    setupCreatePoemView()
    layout()
  }
  
  private func setupCreatePoemView() {
    createPoemView.delegate = self
    createPoemView.backgroundColor = .systemBackground
  }
  
  private func layout() {
    view.addSubview(createPoemView)
    
    createPoemView.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      createPoemView.topAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.topAnchor
      ),
      createPoemView.leadingAnchor.constraint(
        equalTo: view.leadingAnchor
      ),
      createPoemView.trailingAnchor.constraint(
        equalTo: view.trailingAnchor
      ),
      createPoemView.bottomAnchor.constraint(
        equalTo: view.safeAreaLayoutGuide.bottomAnchor
      ),
    ])
  }
  
  private func createPoem(_ nlpPoem: Poem?) {
    guard let nlpPoem = nlpPoem else {
      return
    }
  }
  
  private func updatePoem(_ nlpPoem: Poem?) {
    guard let nlpPoem = nlpPoem else {
      return
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
  
  func createPoemView(
    _ createPoemView: CreatePoemView,
    didTapDone button: UIBarButtonItem,
    poemContent: String
  ) {
    var poemForRequest: Poem?
    
    guard let user = user else {
      dismiss(animated: true, completion: nil)
      return
    }
    
    switch type {
    case .create:
      poemForRequest = Poem(
        topic: topic.topic,
        author: user.nickname,
        authorEmail: user.email,
        content: poemContent,
        ranking: Int.max
      )
      createPoem(poemForRequest)
    case .edit:
      poemForRequest = self.poem
      poemForRequest?.content = poemContent
      updatePoem(poemForRequest)
    }
  }
}
