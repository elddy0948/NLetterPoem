import UIKit

extension UserProfileViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView,
                      didSelectItemAt indexPath: IndexPath) {
    if let poem = poemsViewModel?.selectedPoem(at: indexPath.item),
       let user = userViewModel?.user {
      let detailPoemViewController = PoemDetailViewController(poem, user)
      detailPoemViewController.enableAuthorButton = false
      navigationController?.pushViewController(detailPoemViewController, animated: true)
    }
  }
}

