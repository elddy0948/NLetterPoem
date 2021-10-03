import UIKit

final class HomeViewController: UIViewController {
  
  private var todayBarButtonItem: UIBarButtonItem!
  private var hotBarButtonItem: UIBarButtonItem!
  private var containerView: UIView?
  
  private let containerViewController = ContainerViewController()
  private let viewControllers = [TodayViewController(), HotViewController()]
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    configureNavigationBar()
    configureContainerView()
    
    todayBarButtonAction(todayBarButtonItem)
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
    //이미 보여주고 있으면 Return
    if containerViewController.children.first == viewControllers[0] { return }
    containerViewController.add(viewControllers[0])
    animateTransition(fromViewController: viewControllers[1],
                      toViewController: viewControllers[0]) { isTransitionDone in
      if isTransitionDone { self.viewControllers[1].remove() }
    }
    UIView.animate(withDuration: 0.3) { [weak self] in
      guard let self = self else { return }
      self.todayBarButtonItem.customView?.alpha = 1.0
      self.hotBarButtonItem.customView?.alpha = 0.5
    }
  }
  
  @objc func hotBarButtonAction(_ sender: UIBarButtonItem) {
    if containerViewController.children.first == viewControllers[1] { return }
    containerViewController.add(viewControllers[1])
    animateTransition(fromViewController: viewControllers[0],
                      toViewController: viewControllers[1]) { isTransitionDone in
      if isTransitionDone { self.viewControllers[0].remove() }
    }
    
    UIView.animate(withDuration: 0.3) { [weak self] in
      guard let self = self else { return }
      self.hotBarButtonItem.customView?.alpha = 1.0
      self.todayBarButtonItem.customView?.alpha = 0.5
    }
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
  
  private func animateTransition(fromViewController: UIViewController,
                                 toViewController: UIViewController,
                                 completion: @escaping ((Bool) -> Void)) {
    guard let fromView = fromViewController.view,
          let fromIndex = getIndex(forViewController: fromViewController),
          let toView = toViewController.view,
          let toIndex = getIndex(forViewController: toViewController) else {
      return
    }
    
    let frame = fromView.frame
    var fromFrameEnd = frame
    var toFrameStart = frame
    fromFrameEnd.origin.x = toIndex > fromIndex ? frame.origin.x - frame.width : frame.origin.x + frame.width
    toFrameStart.origin.x = toIndex > fromIndex ? frame.origin.x + frame.width : frame.origin.x - frame.width
    
    UIView.animate(withDuration: 0.5) {
      fromView.frame = fromFrameEnd
      toView.frame = frame
    } completion: { success in
      completion(success)
    }
  }
  
  private func getIndex(forViewController vc: UIViewController) -> Int? {
    for (index, thisVC) in viewControllers.enumerated() {
      if thisVC == vc {
        return index
      }
    }
    return nil
  }
}
