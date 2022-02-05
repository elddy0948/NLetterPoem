import UIKit

class LaunchCoordinator: Coordinator {
  var children: [Coordinator] = []
  var router: Router
  
  init(router: Router) {
    self.router = router
  }
  
  func present(animated: Bool, onDismissed: (() -> Void)?) {
    let viewController = LaunchViewController()
    router.present(
      viewController,
      animated: false
    )
  }
  
  
  //TODO: - LaunchViewController Delegate 생성 후 SignIn or Home으로 가는 메서드 구현하기
}
