import UIKit

extension HomeViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todayPoems?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.reuseIdentifier, for: indexPath) as? HomeTableViewCell,
              let poem = todayPoems?[indexPath.row] else { return UITableViewCell() }
        let shortDescription = poem.content.makeShortDescription()
        cell.setCellData(shortDes: "\"\(shortDescription)", writer: "- \(poem.author) -", likeCount: poem.likeCount)
        return cell
    }
}
