import UIKit

extension TodayViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if let todayPoems = todayPoems {
      if todayPoems.isEmpty {
        return 1
      }
      return todayPoems.count
    }
    return 1
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if let todayPoems = todayPoems {
      //Empty Home TableView Cell
      if todayPoems.isEmpty {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeEmptyCell.reuseIdentifier,
                                                 for: indexPath)
        return cell
      }
      
      guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.reuseIdentifier,
                                                     for: indexPath) as? HomeTableViewCell else {
        return UITableViewCell()
      }
      
      let poem = todayPoems[indexPath.row]
      let shortDescription = poem.content.makeShortDescription()
      cell.backgroundColor = .systemBackground
      cell.setCellData(shortDes: "\"\(shortDescription)\"",
                       writer: "- \(poem.author) -",
                       topic: poem.topic)
      
      return cell
    }
    let cell = tableView.dequeueReusableCell(withIdentifier: HomeEmptyCell.reuseIdentifier,
                                             for: indexPath)
    return cell
  }
}