import UIKit

extension MyPageViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if let poem = poemsViewModel?.selectedPoem(at: indexPath.item),
       let user = userViewModel?.user {
      let vc = PoemDetailViewController(poem, user)
      vc.enableAuthorButton = false
      navigationController?.pushViewController(vc, animated: true)
    }
  }
}
