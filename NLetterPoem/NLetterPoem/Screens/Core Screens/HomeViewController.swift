import UIKit

final class HomeViewController: UIViewController {
  
  private var todayBarButtonItem: UIBarButtonItem!
  private var hotBarButtonItem: UIBarButtonItem!
  private var containerView: UIView?
  
  private let containerViewController = ContainerViewController()
  private let viewControllers = [TodayViewController()]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    configureNavigationBar()
    configureContainerView()
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nil, bundle: nil)
    todayBarButtonItem = createBarButtonItem(text: "오늘의 시", selector: #selector(todayBarButtonAction(_:)))
    hotBarButtonItem = createBarButtonItem(text: "Hot🔥", selector: #selector(hotBarButtonAction(_:)))
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    layout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureNavigationBar() {
    navigationItem.leftBarButtonItems = [todayBarButtonItem, hotBarButtonItem]
    let mockImage = UIImage()
    navigationController?.navigationBar.shadowImage = mockImage
    navigationController?.navigationBar.setBackgroundImage(mockImage, for: .default)
    navigationController?.navigationBar.isTranslucent = false
  }
  
  private func configureContainerView() {
    containerView = containerViewController.view
    containerView?.translatesAutoresizingMaskIntoConstraints = false
    containerView?.backgroundColor = .systemBackground
    guard let containerView = containerView else { return }
    view.addSubview(containerView)
  }
  
  @objc func todayBarButtonAction(_ sender: UIBarButtonItem) {
    
  }
  
  @objc func hotBarButtonAction(_ sender: UIBarButtonItem) {
    
  }
  
  private func createBarButtonItem(text: String, selector: Selector) -> UIBarButtonItem {
    let button = UIButton()
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: selector, for: .primaryActionTriggered)
    
    let attributes = [
      NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .largeTitle).withTraits(traits: [.traitBold]),
      NSAttributedString.Key.foregroundColor: UIColor.label
    ]
    let attributedText = NSMutableAttributedString(string: text, attributes: attributes)
    
    button.setAttributedTitle(attributedText, for: .normal)
    button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 16)
    
    let barButtonItem = UIBarButtonItem(customView: button)
    return barButtonItem
  }
  
  //MARK: - Layout
  private func layout() {
    guard let containerView = containerView else { return }
    NSLayoutConstraint.activate([
      containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
      containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      containerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
    ])
  }
}
