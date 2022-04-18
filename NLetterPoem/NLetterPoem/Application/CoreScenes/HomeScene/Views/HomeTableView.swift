import UIKit

protocol HomeTableViewDelegate: AnyObject {
  func handleRefreshHomeTableView(_ tableView: HomeTableView)
}

class HomeTableView: UITableView {
  
  private let homeRefreshControl = UIRefreshControl()
  weak var homeTableViewDelegate: HomeTableViewDelegate?
  
  //MARK: - init
  override init(frame: CGRect, style: UITableView.Style) {
    super.init(frame: .zero, style: style)
    configure()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  //MARK: - Privates
  private func configure() {    
    tableFooterView = UIView()
    backgroundColor = .systemBackground
    refreshControl = homeRefreshControl
    separatorStyle = .none
    clipsToBounds = false
    
    refreshControl?.addTarget(self, action: #selector(handleRefreshHome(_:)), for: UIControl.Event.valueChanged)
  }
  
  @objc func handleRefreshHome(_ sender: UIRefreshControl) {
    homeTableViewDelegate?.handleRefreshHomeTableView(self)
  }
}
