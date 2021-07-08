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
    func didTappedCancelButton(_ createPoemView: CreatePoemView) {
        dismiss(animated: true, completion: nil)
    }
    
    func didTappedDoneButton(_ createPoemView: CreatePoemView, with poem: String) {
        let dispatchQueue = DispatchQueue(label: "com.howift.createPoem")
        let dispatchGroup = DispatchGroup()
        
        guard let user = NLPUser.shared,
              let topic = topic else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        let nlpPoem = NLPPoem(id: user.email, topic: topic, author: user.email, content: poem, ranking: Int.max)
        user.poems.append(nlpPoem)
        
        dispatchQueue.async {
            dispatchGroup.enter()
            DatabaseManager.shared.createPoem(date: Date(), poem: nlpPoem) { [weak self] error in
                defer { dispatchGroup.leave() }
                guard let self = self else { return }
                if let error = error {
                    self.showAlert(title: "⚠️", message: error.localizedDescription)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
        
        dispatchQueue.async {
            dispatchGroup.enter()
            DatabaseManager.shared.updateUser(with: user) { [weak self] error in
                defer { dispatchGroup.leave() }
                guard let self = self else { return }
                if let error = error {
                    self.showAlert(title: "⚠️", message: error.localizedDescription)
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
