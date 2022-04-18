import UIKit

class DeveloperInfoViewController: UIViewController {
  
  private var titleLabel: NLPYeonSungFontLabel!
  private var emailLabel: NLPYeonSungFontLabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .systemBackground
    
    configureTitleLabel()
    configureEmailLabel()
  }
  
  private func configureTitleLabel() {
    let padding: CGFloat = 4
    titleLabel = NLPYeonSungFontLabel(size: 32, numberOfLines: 1, textAlignment: .center)
    view.addSubview(titleLabel)
    
    titleLabel.text = "이메일"
    
    NSLayoutConstraint.activate([
      titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
      titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
      titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor)
    ])
  }
  
  private func configureEmailLabel() {
    let padding: CGFloat = 4
    emailLabel = NLPYeonSungFontLabel(size: 24, numberOfLines: 1, textAlignment: .center)
    view.addSubview(emailLabel)
    
    emailLabel.text = "elddy0948@hotmail.co.kr"
    
    NSLayoutConstraint.activate([
      emailLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: padding),
      emailLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
      emailLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
      emailLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
    ])
  }
}
