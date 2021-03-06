import UIKit

class DataLoadingViewController: UIViewController {
  var containerView: UIView?
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  func showLoadingView() {
    containerView = UIView(frame: view.bounds)
    guard let containerView = containerView else { return }
    view.addSubview(containerView)
    
    containerView.backgroundColor = .systemBackground
    containerView.alpha = 1
    
    UIView.animate(withDuration: 0.25) {
      self.containerView?.alpha = 0.8
    }
    
    let activityIndicator = UIActivityIndicatorView(style: .large)
    containerView.addSubview(activityIndicator)
    
    activityIndicator.translatesAutoresizingMaskIntoConstraints = false
    
    NSLayoutConstraint.activate([
      activityIndicator.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
      activityIndicator.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
    ])
    
    activityIndicator.startAnimating()
  }
  
  func dismissLoadingView() {
    DispatchQueue.main.async { [weak self] in
      guard let self = self else { return }
      self.containerView?.removeFromSuperview()
      self.containerView = nil
    }
  }
}
