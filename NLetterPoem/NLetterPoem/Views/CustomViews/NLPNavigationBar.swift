import UIKit

protocol NLPNavigationBarDelegate: AnyObject {
  func nlpNavigationBar(_ nlpNavigationBar: NLPNavigationBar, didTapLeftBarButton leftBarButton: UIBarButtonItem)
  func nlpNavigationBar(_ nlpNavigationBar: NLPNavigationBar, didTapRightBarButton rightBarButton: UIBarButtonItem)
}

class NLPNavigationBar: UINavigationBar {
  
  //MARK: - Properties
  weak var nlpDelegate: NLPNavigationBarDelegate?
  
  //MARK: - init
  init(title: String, leftTitle: String?, rightTitle: String?) {
    super.init(frame: .zero)
    configure(title: title, leftTitle: leftTitle, rightTitle: rightTitle)
  }
  
  override init(frame: CGRect) {
    super.init(frame: .zero)
    configure(title: "", leftTitle: nil, rightTitle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configure(title: String, leftTitle: String?, rightTitle: String?) {
    barTintColor = .systemBackground
    let item = UINavigationItem(title: title)
    if let leftTitle = leftTitle {
      item.leftBarButtonItem = UIBarButtonItem(title: leftTitle, style: .plain,
                                               target: self, action: #selector(leftBarButtonAction(_:)))
    }
    
    if let rightTitle = rightTitle {
      item.rightBarButtonItem = UIBarButtonItem(title: rightTitle, style: .plain,
                                                target: self, action: #selector(rightBarButtonAction(_:)))
    }
    
    backgroundColor = .systemBackground
    pushItem(item, animated: true)
    translatesAutoresizingMaskIntoConstraints = false
    tintColor = .label
  }
  
  @objc func leftBarButtonAction(_ sender: UIBarButtonItem) {
    nlpDelegate?.nlpNavigationBar(self, didTapLeftBarButton: sender)
  }
  
  @objc func rightBarButtonAction(_ sender: UIBarButtonItem) {
    nlpDelegate?.nlpNavigationBar(self, didTapRightBarButton: sender)
  }
}

extension NLPNavigationBarDelegate {
  func nlpNavigationBar(_ nlpNavigationBar: NLPNavigationBar, didTapLeftBarButton leftBarButton: UIBarButtonItem) {
  }
  func nlpNavigationBar(_ nlpNavigationBar: NLPNavigationBar, didTapRightBarButton rightBarButton: UIBarButtonItem) {
  }
}
