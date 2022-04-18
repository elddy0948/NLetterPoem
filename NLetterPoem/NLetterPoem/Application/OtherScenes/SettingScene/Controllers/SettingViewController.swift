import UIKit
import Firebase

class SettingViewController: UIViewController {
  
  //MARK: - Views
  private lazy var settingTableView = SettingTableView(frame: .zero, style: .plain)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationItem.largeTitleDisplayMode = .never
    navigationItem.title = "설정"
    setupSettingTableView()
    layout()
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
      showAlert(title: "⚠️", message: "로그아웃에 실패했습니다! 다시 시도해주세요!", action: nil)
    }
  }
  
  func withdrawalAction() {
    guard let currentUser = Auth.auth().currentUser,
          let email = currentUser.email else { return }
    
    DispatchQueue.global(qos: .utility).async { [weak self] in
      guard let self = self else { return }
      self.authDelete(with: email)
    }
  }
  
  private func authDelete(with email: String) {
    AuthManager.shared.authDelete(userEmail: email, completed: { result in
      var flag = false
      defer {
        if flag { self.showLauchViewController() }
      }
      switch result {
      case .success(let message):
        flag = true
        self.showAlert(title: "✅", message: message, action: nil)
      case .failure(let error):
        self.showAlert(title: "⚠️", message: error.localizedDescription, action: nil)
      }
    })
  }

  private func showLauchViewController() {
    guard let scene = UIApplication.shared.connectedScenes.first,
          let sceneDelegate = (scene.delegate as? SceneDelegate),
          let coordinator = sceneDelegate.coordinator else {
            return
          }
    
    coordinator.present(animated: false, onDismissed: nil)
  }
}

//MARK: - UI Setup / Layout
extension SettingViewController {
  private func setupSettingTableView() {
    view.addSubview(settingTableView)
    settingTableView.delegate = self
    settingTableView.dataSource = self
    settingTableView.tableFooterView = UIView()
    settingTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
  }
  
  private func layout() {
    NSLayoutConstraint.activate([
      settingTableView.topAnchor.constraint(equalTo: view.topAnchor),
      settingTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      settingTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      settingTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
  }
}
