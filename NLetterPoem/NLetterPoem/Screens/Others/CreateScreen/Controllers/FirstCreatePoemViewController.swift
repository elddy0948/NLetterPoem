import UIKit
import Firebase

class FirstCreateViewController: CreatorViewController {
  private var firstCreateView: FirstCreateView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    configureNavigationBarItem()
    configureFirstCreateView()
    layout()
  }
  
  private func configureNavigationBarItem() {
    let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelAction(_:)))
    navigationItem.leftBarButtonItem = cancelButton
  }
  
  private func configureFirstCreateView() {
    firstCreateView = FirstCreateView()
    view.addSubview(firstCreateView)
    
    firstCreateView.delegate = self
  }
  
  private func layout() {
    NSLayoutConstraint.activate([
      firstCreateView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      firstCreateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      firstCreateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      firstCreateView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
    ])
  }
  
  @objc func cancelAction(_ sender: UIBarButtonItem) {
    self.dismiss(animated: true, completion: nil)
  }
}

//MARK: - FirstCreateViewDelegate
extension FirstCreateViewController: FirstCreateViewDelegate {
  func firstCreateView(_ firstCreateView: FirstCreateView, didTapCheckBox checkBoxButton: NLPCheckBoxButton, nextButton: UIButton) {
    checkBoxButton.isSelected.toggle()
    checkBoxButton.isSelected ? (nextButton.isEnabled = true) : (nextButton.isEnabled = false)
  }
  
  func firstCreateView(_ firstCreateView: FirstCreateView, didTapNextButton nextButton: UIButton) {
    let viewController = CreateTopicViewController()
    viewController.user = user
    self.navigationController?.pushViewController(viewController, animated: true)
  }
}
