import UIKit
import Firebase

class SettingViewController: UIViewController {
    
    //MARK: - Views
    private(set) var settingTableView: SettingView!
    
    //MARK: - Properties
    private let settingList: [String] = ["고객센터", "로그아웃"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    //MARK: - Privates
    private func configure() {
        settingTableView = SettingView(frame: .zero, style: .plain)
        view = settingTableView
        
        settingTableView.delegate = self
        settingTableView.dataSource = self
        settingTableView.tableFooterView = UIView()
        settingTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    private func didTapSignout() {
        do {
            try Auth.auth().signOut()
            NLPUser.shared = nil
            showLauchViewController()
        } catch {
            debugPrint(error)
            showAlert(title: "⚠️", message: "로그아웃에 실패했습니다! 다시 시도해주세요!", action: nil)
        }
    }
    
    private func showLauchViewController() {
        let viewController = LaunchViewController()
        guard let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first else {
            return
        }
        window.rootViewController = viewController
    }
}

//MARK: - UITableViewDelegate
extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        if cell.textLabel?.text == "로그아웃" {
            didTapSignout()
        }
    }
}

//MARK: - UITableViewDataSource
extension SettingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.selectionStyle = .none
        settingList[indexPath.row] == "로그아웃" ? (cell.textLabel?.textColor = .systemRed) : (cell.textLabel?.textColor = .label)
        cell.textLabel?.text = settingList[indexPath.row]
        return cell
    }
}
