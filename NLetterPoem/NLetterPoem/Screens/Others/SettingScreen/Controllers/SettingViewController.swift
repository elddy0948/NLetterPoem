import UIKit
import Firebase

class SettingViewController: UIViewController {
  
  //MARK: - Views
  private(set) var settingTableView: SettingTableView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    configureSettingTableView()
    navigationItem.largeTitleDisplayMode = .never
    navigationItem.title = "설정"
  }
  
  //MARK: - Privates
  private func configureSettingTableView() {
    settingTableView = SettingTableView(frame: .zero, style: .plain)
    view.addSubview(settingTableView)
    
    settingTableView.delegate = self
    settingTableView.dataSource = self
    settingTableView.tableFooterView = UIView()
    settingTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    
    NSLayoutConstraint.activate([
      settingTableView.topAnchor.constraint(equalTo: view.topAnchor),
      settingTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      settingTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      settingTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
  }
  
  private func showLauchViewController() {
    let viewController = UINavigationController(rootViewController: LaunchViewController())
    guard let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first else {
      return
    }
    window.rootViewController = viewController
  }
  
  //MARK: - Section Type
  enum SettingSection: String, CaseIterable {
    case general = "일반"
    case user = "회원 관련"
    case signout = " "
    
    var list: [String] {
      switch self {
      case .general:
        return ["건의하기"]
      case .signout:
        return ["로그아웃"]
      case .user:
        return ["회원탈퇴"]
      }
    }
  }
}

//MARK: - Actions
extension SettingViewController {
  func didTapSignout() {
    do {
      try Auth.auth().signOut()
      showLauchViewController()
    } catch {
      debugPrint(error)
      showAlert(title: "⚠️", message: "로그아웃에 실패했습니다! 다시 시도해주세요!", action: nil)
    }
  }
  
  func withdrawalAction() {
    let dispatchGroup = DispatchGroup()
    var errorMessage: String?
    var successCount = 0
    
    guard let currentUser = Auth.auth().currentUser,
          let email = currentUser.email else { return }
    
    dispatchGroup.enter()
    DispatchQueue.global(qos: .utility).async {
      AuthManager.shared.authDelete(userEmail: email) { result in
        defer { dispatchGroup.leave() }
        switch result {
        case .success(_):
          successCount += 1
        case .failure(let error):
          errorMessage = error.localizedDescription
        }
      }
    }
    
    dispatchGroup.enter()
    DispatchQueue.global(qos: .utility).async {
      UserDatabaseManager.shared.delete(email) { error in
        defer { dispatchGroup.leave() }
        if error != nil {
          errorMessage = error?.localizedDescription
          return
        }
      }
    }
    
    dispatchGroup.notify(queue: DispatchQueue.main) { [weak self] in
      guard let self = self else {
        self?.showAlert(title: "⚠️", message: "삭제에 실패했습니다!", action: nil)
        return
      }
      
      if let errorMessage = errorMessage {
        self.showAlert(title: "⚠️", message: errorMessage, action: nil)
        return
      }
      
      self.showAlert(title: "성공!", message: "삭제에 성공했습니다!", action: { _ in
        self.showLauchViewController()
      })
    }
  }
}
