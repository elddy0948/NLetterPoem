import UIKit
import Firebase
import RxSwift

protocol CreatePoemViewControllerDelegate: AnyObject {
  func createPoemViewController(
    _ viewController: CreatePoemViewController,
    didTapDone poem: NLPPoem
  )
}

class CreatePoemViewController: CreatorViewController {
  
  enum ActionType {
    case edit
    case create
  }
  
  //MARK: - Views
  private(set) var createPoemView: CreatePoemView!
  
  //MARK: - Properties
  var topic: NLPTopic
  var type: ActionType
  var poem: NLPPoem?
  var globalScheduler = ConcurrentDispatchQueueScheduler(
    qos: .utility
  )
  private let bag = DisposeBag()
  
  private var handler: AuthStateDidChangeListenerHandle?
  weak var delegate: CreatePoemViewControllerDelegate?
  
  //MARK: - Initializer
  init(_ topic: NLPTopic,
       type: ActionType = .create,
       poem: NLPPoem?
  ) {
    self.topic = topic
    self.type = type
    self.poem = poem
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    self.topic = NLPTopic(topic: "")
    self.type = .create
    super.init(coder: coder)
  }
  
  //MARK: - View Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    configure()
  }
  
  //MARK: - Privates
  private func configure() {
    view.backgroundColor = .systemBackground
    createPoemView = CreatePoemView(
      topic: topic.topic,
      poem: poem
    )
    
    createPoemView.delegate = self
    
    view.addSubview(createPoemView)
    
    NSLayoutConstraint.activate([
      createPoemView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      createPoemView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      createPoemView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      createPoemView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])
  }
  
  private func createPoem(_ nlpPoem: NLPPoem?) {
    guard let nlpPoem = nlpPoem else {
      return
    }

    showLoadingView()
    
    FirestorePoemApi.shared
      .create(nlpPoem)
      .subscribe(on: globalScheduler)
      .observe(on: MainScheduler.instance)
      .subscribe(
        onCompleted: { [weak self] in
          self?.dismissLoadingView()
          guard let self = self else { return }
          self.showAlert(
            title: "🎉",
            message: "멋진 시네요👏",
            action: { _ in
              self.dismiss(animated: true, completion: nil)
            }
          )
        },
        onError: { [weak self] error in
          self?.dismissLoadingView()
          guard let self = self else { return }
          self.showAlert(
            title: "⚠️",
            message: "다시 시도해주세요!",
            action: { _ in
              self.dismiss(animated: true, completion: nil)
            }
          )
        },
        onDisposed: {}
      )
      .disposed(by: bag)
  }
  
  private func updatePoem(_ nlpPoem: NLPPoem?) {
    guard let nlpPoem = nlpPoem else {
      return
    }
    
    showLoadingView()
    
    FirestorePoemApi.shared
      .update(nlpPoem)
      .subscribe(on: globalScheduler)
      .observe(on: MainScheduler.instance)
      .subscribe(
        onCompleted: { [weak self] in
          self?.dismissLoadingView()
          guard let self = self else { return }
          self.showAlert(
            title: "✅",
            message: "업데이트 완료!",
            action: { _ in
              self.delegate?.createPoemViewController(
                self,
                didTapDone: nlpPoem
              )
              self.dismiss(animated: true, completion: nil)
            }
          )
        },
        onError: { [weak self] error in
          self?.dismissLoadingView()
          guard let self = self else { return }
          self.showAlert(
            title: "⚠️",
            message: "다시 시도해주세요!",
            action: { _ in
              self.dismiss(animated: true, completion: nil)
            }
          )
        },
        onDisposed: {}
      )
      .disposed(by: bag)
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
    let poemForRequest: NLPPoem?
    
    guard let user = user else {
      dismiss(animated: true, completion: nil)
      return
    }
    
    switch type {
    case .create:
      poemForRequest = NLPPoem(
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
