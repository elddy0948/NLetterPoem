import UIKit

final class CantCreatePoemView: UIView {
  
  private(set) var noticeLabel = NLPYeonSungFontLabel(size: 24, numberOfLines: 3, textAlignment: .center)
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .systemBackground
    configureNoticeLabel()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func configureNoticeLabel() {
    addSubview(noticeLabel)
    
    noticeLabel.text = "하루에 하나의 시만 작성 가능합니다!\n멋진 아이디어\n내일 공유해주세요!🙏"
    
    NSLayoutConstraint.activate([
      noticeLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
      noticeLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
    ])
  }
}
