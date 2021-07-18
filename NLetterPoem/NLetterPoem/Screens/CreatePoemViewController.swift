import UIKit

class CreatePoemViewController: UIViewController {
    
    //MARK: - Views
    private(set) var createPoemView: CreatePoemView!
    
    //MARK: - Properties
    var topic: String?

    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    //MARK: - Privates
    private func configure() {
        guard let topic = topic else { return }
        createPoemView = CreatePoemView(topic: topic)
        view.addSubview(createPoemView)
        
        createPoemView.delegate = self
        createPoemView.frame = view.bounds
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
        
        guard let user = NLPUser.shared,
              let topic = topic else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        let nlpPoem = NLPPoem(topic: topic, author: user.nickname,
                              authorEmail: user.email, content: poem, ranking: Int.max)
        
        user.poems.append(nlpPoem.id)
        
        dispatchQueue.async {
            dispatchGroup.enter()
            PoemDatabaseManager.shared.createPoem(poem: nlpPoem) { [weak self] error in
                defer { dispatchGroup.leave() }
                guard let self = self else { return }
                if let _ = error {
                    self.showAlert(title: "⚠️", message: "생성에 실패했어요!\n다시 시도해주세요!", action: nil)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        
        dispatchQueue.async {
            dispatchGroup.enter()
            UserDatabaseManager.shared.updateUser(with: user) { [weak self] error in
                defer { dispatchGroup.leave() }
                guard let self = self else { return }
                if let error = error {
                    self.showAlert(title: "⚠️", message: error.localizedDescription, action: nil)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
        }
    }
}
