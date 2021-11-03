import UIKit

extension UserProfileViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView,
                      didSelectItemAt indexPath: IndexPath) {
    if let poem = poemsViewModel?.selectedPoem(at: indexPath.item) {
      let detailPoemViewController = PoemDetailViewController()
      detailPoemViewController.poem = poem
      detailPoemViewController.enableAuthorButton = false
      navigationController?.pushViewController(detailPoemViewController, animated: true)
    }
  }
}

