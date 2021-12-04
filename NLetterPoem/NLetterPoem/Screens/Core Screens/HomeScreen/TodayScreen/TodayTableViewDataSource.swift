import UIKit


final class TodayTableViewDataSource: NSObject, UITableViewDataSource {
  var poemViewModels = [PoemViewModel]()
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if poemViewModels.isEmpty {
      return 1
    }
    return poemViewModels.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if poemViewModels.isEmpty {
      let cell = tableView.dequeueReusableCell(withIdentifier: HomeEmptyCell.reuseIdentifier,
                                               for: indexPath)
      return cell
    }
    
    guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.reuseIdentifier,
                                                   for: indexPath) as? HomeTableViewCell else {
      return UITableViewCell()
    }
    
    let poem = poemViewModels[indexPath.row]
    let shortDescription = poem.content.makeShortDescription()
    cell.backgroundColor = .systemBackground
    cell.setCellData(shortDes: shortDescription,
                     writer: poem.author,
                     topic: poem.topic)
    
    return cell
  }
  
  func fetchPoem(
    from indexPath: IndexPath) -> PoemViewModel {
    return poemViewModels[indexPath.row]
  }
}
