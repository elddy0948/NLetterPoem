import UIKit

extension MyPageViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if let poem = poems?[indexPath.item] {
      let vc = PoemDetailViewController()
      vc.poem = poem
      vc.enableAuthorButton = false
      navigationController?.pushViewController(vc, animated: true)
    }
  }
}
