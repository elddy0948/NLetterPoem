import UIKit

class HomeTableView: UITableView {
    
    //MARK: - init
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Privates
    private func configure() {
        tableFooterView = UIView()
        backgroundColor = .systemBackground
    }
}
