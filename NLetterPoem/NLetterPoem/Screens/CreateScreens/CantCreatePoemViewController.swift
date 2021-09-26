import UIKit

class CantCreatePoemViewController: CreatorViewController {
  
  private var cantCreatePoemView: CantCreatePoemView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureCantCreatePoemView()
    layout()
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
}
