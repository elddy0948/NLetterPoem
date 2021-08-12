import UIKit

//MARK: - UITableViewDelegate
extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        if cell.textLabel?.text == "로그아웃" {
            didTapSignout()
        } else if cell.textLabel?.text == "회원탈퇴" {
            withdrawalAction()
        }
    }
}
