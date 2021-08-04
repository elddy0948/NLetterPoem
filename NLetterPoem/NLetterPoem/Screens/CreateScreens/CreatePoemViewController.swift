import UIKit
import Firebase

protocol CreatePoemViewControllerDelegate: AnyObject {
    func createPoemViewController(_ viewController: CreatePoemViewController, didTapDone poem: NLPPoem)
}

class CreatePoemViewController: UIViewController {
    
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
    
    weak var delegate: CreatePoemViewControllerDelegate?

    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    //MARK: - Privates
    private func configure() {
        view.backgroundColor = .systemBackground
        guard let topic = topic else { return }
        createPoemView = CreatePoemView(topic: topic, poem: editPoem)
        
        createPoemView.delegate = self
        self.view = createPoemView
    }
}

//MARK: - CreatePoemViewDelegate
extension CreatePoemViewController: CreatePoemViewDelegate {
    func createPoemView(_ createPoemView: CreatePoemView, didCancel button: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func createPoemView(_ createPoemView: CreatePoemView, didTapDone button: UIBarButtonItem, poem: String) {
        let dispatchQueue = DispatchQueue(label: "com.howift.createPoem")
        let dispatchGroup = DispatchGroup()
        var createPoemError: String?
        
        guard let user = NLPUser.shared,
              let topic = topic else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        let nlpPoem: NLPPoem?
        
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
        
        user.poems.append(nlpPoem.id)
        
        dispatchQueue.async(group: dispatchGroup, execute: {
            PoemDatabaseManager.shared.createPoem(poem: nlpPoem) { error in
                if let error = error {
                    createPoemError = error.localizedDescription
                }
            }
        })
        
        if action == .create {
            dispatchQueue.async(group: dispatchGroup, execute: {
                UserDatabaseManager.shared.updateUser(with: user) { error in
                    if let error = error {
                        createPoemError = error.localizedDescription
                    }
                }
            })
        }

        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            guard let self = self else { return }
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
