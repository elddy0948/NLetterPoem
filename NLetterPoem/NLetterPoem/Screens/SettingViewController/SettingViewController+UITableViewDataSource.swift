import UIKit

//MARK: - UITableViewDataSource
extension SettingViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingSection.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingSection.allCases[section].list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.selectionStyle = .none
        
        let text = SettingSection.allCases[indexPath.section].list[indexPath.row]
        cell.textLabel?.text = text
        text == "로그아웃" || text == "회원탈퇴" ? (cell.textLabel?.textColor = .systemRed) : (cell.textLabel?.textColor = .label)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return SettingSection.allCases[section].rawValue
    }
}
