import UIKit

class HomeTableView: UITableView {
    
    //MARK: - init
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        configure()
        configureHeaderView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Privates
    private func configure() {
        tableFooterView = UIView()
    }
    
    private func configureHeaderView() {
        let screenWidth = UIScreen.main.bounds.width
        let padding: CGFloat = 8
        let containerView = UIView(frame: CGRect(x: 0, y: 0,
                                                 width: screenWidth, height: 150))
        let homeHeaderView = HomeHeaderView()
        containerView.addSubview(homeHeaderView)
        
        NSLayoutConstraint.activate([
            homeHeaderView.topAnchor.constraint(equalTo: containerView.topAnchor,
                                                constant: padding),
            homeHeaderView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,
                                                    constant: padding),
            homeHeaderView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,
                                                     constant: -padding),
            homeHeaderView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor,
                                                   constant: -padding),
        ])
        
        tableHeaderView = containerView
    }
}
