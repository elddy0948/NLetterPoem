import UIKit

extension UserProfileViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView,
                      didSelectItemAt indexPath: IndexPath) {
    let poemViewModel = poemListViewModel.selectedPoem(
      at: indexPath.item
    )
    let detailPoemViewController = PoemDetailViewController(
      poemViewModel
    )
    detailPoemViewController.enableAuthorButton = false
    navigationController?.pushViewController(
      detailPoemViewController,
      animated: true
    )
    
  }
}

