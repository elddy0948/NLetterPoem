import UIKit
import Firebase

final class HomeViewController: DataLoadingViewController {

  var todayBarButton: NLPBarButton!
  var hotBarButton: NLPBarButton!
  private var todayBarButtonItem: UIBarButtonItem!
  private var hotBarButtonItem: UIBarButtonItem!
  private var addBarButtonItem: UIBarButtonItem!
  private var container: UIView?
  
  private let containerViewController = ContainerViewController()
  private let viewControllers = [TodayViewController(), HotViewController()]
  
  static var nlpUser: NLPUser?
  var handler: AuthStateDidChangeListenerHandle?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    configureNavigationBar()
    configureContainerView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    createStateChangeListener()
  }
  
  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nil, bundle: nil)
    todayBarButton = configureBarButton(text: "오늘의 시", selector: #selector(todayBarButtonAction(_:)))
    hotBarButton = configureBarButton(text: "Hot", selector: #selector(hotBarButtonAction(_:)))
    configureBarButtonItems()
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    layout()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    if let handler = handler {
      Auth.auth().removeStateDidChangeListener(handler)
    }
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureNavigationBar() {
    navigationItem.leftBarButtonItems = [todayBarButtonItem, hotBarButtonItem]
    navigationItem.rightBarButtonItem = addBarButtonItem
    let mockImage = UIImage()
    navigationController?.navigationBar.shadowImage = mockImage
    navigationController?.navigationBar.setBackgroundImage(mockImage, for: .default)
    navigationController?.navigationBar.isTranslucent = false
  }
  
  //MARK: - Bar Button
  private func configureBarButton(text: String, selector: Selector) -> NLPBarButton {
    let nlpBarButton = NLPBarButton(text: text)
    nlpBarButton.addTarget(self, action: selector, for: .primaryActionTriggered)
    return nlpBarButton
  }
  
  private func configureBarButtonItems() {
    todayBarButtonItem = UIBarButtonItem(customView: todayBarButton)
    hotBarButtonItem = UIBarButtonItem(customView: hotBarButton)
    addBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                         target: self,
                                         action: #selector(addBarButtonAction(_:)))
    addBarButtonItem.tintColor = .label
  }
  
  private func configureContainerView() {
    container = containerViewController.view
    container?.translatesAutoresizingMaskIntoConstraints = false
    container?.backgroundColor = .systemBackground
    guard let containerView = container else { return }
    view.addSubview(containerView)
  }
  
  //MARK: - Actions
  @objc func todayBarButtonAction(_ sender: NLPBarButton) {
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
  
  @objc func hotBarButtonAction(_ sender: NLPBarButton) {
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
  
  @objc func addBarButtonAction(_ sender: UIBarButtonItem) {
    //TODO: - Add 버튼 액션 추가
    guard let user = HomeViewController.nlpUser else { return }
    if user.poems.isEmpty {
      let viewController = FirstCreateViewController()
      viewController.user = user
      createNavigationController(rootVC: viewController)
    } else {
      checkUserDidWritePoemToday(with: user.email)
    }
  }
  
  func createNavigationController(rootVC viewController: CreatorViewController) {
    let navigationController = UINavigationController(rootViewController: viewController)
    navigationController.modalPresentationStyle = .fullScreen
    navigationController.navigationBar.tintColor = .label
    present(navigationController, animated: true, completion: nil)
  }
}

//MARK: - Layout and Animation Logic
extension HomeViewController {
  private func layout() {
    guard let containerView = container else { return }
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