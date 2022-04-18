import UIKit

class CantCreatePoemViewController: CreatorViewController {
  
  private var cantCreatePoemView: CantCreatePoemView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    configureLeftBarButtonItem()
    configureCantCreatePoemView()
    layout()
  }
  
  private func configureLeftBarButtonItem() {
    let leftBarButtonItem = UIBarButtonItem(title: "닫기", style: .plain, target: self, action: #selector(cancelAction(_:)))
    navigationItem.leftBarButtonItem = leftBarButtonItem
  }
  
  private func configureCantCreatePoemView() {
    cantCreatePoemView = CantCreatePoemView()
    view.addSubview(cantCreatePoemView)
  }
  
  private func layout() {
    NSLayoutConstraint.activate([
      cantCreatePoemView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      cantCreatePoemView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      cantCreatePoemView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      cantCreatePoemView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
  
  @objc func cancelAction(_ sender: UIBarButtonItem) {
    self.dismiss(animated: true, completion: nil)
  }
}
