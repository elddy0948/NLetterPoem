import UIKit


final class TodayTableViewDataSource: NSObject, UITableViewDataSource {
  var poems = [NLPPoem]()
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if poems.isEmpty {
      return 1
    }
    return poems.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if poems.isEmpty {
      let cell = tableView.dequeueReusableCell(withIdentifier: HomeEmptyCell.reuseIdentifier,
                                               for: indexPath)
      return cell
    }
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.reuseIdentifier,
                                                   for: indexPath) as? HomeTableViewCell else {
      return UITableViewCell()
    }
    
    let poem = poems[indexPath.row]
    let shortDescription = poem.content.makeShortDescription()
    cell.backgroundColor = .systemBackground
    cell.setCellData(shortDes: shortDescription,
                     writer: poem.author,
                     topic: poem.topic)
    
    return cell
  }
  
  func fetchPoem(from indexPath: IndexPath) -> NLPPoem {
    return poems[indexPath.row]
  }
}
