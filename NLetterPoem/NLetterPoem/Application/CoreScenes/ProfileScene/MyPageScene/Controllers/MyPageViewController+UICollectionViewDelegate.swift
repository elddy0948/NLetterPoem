import UIKit

extension MyPageViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    let poem = poemListViewModel.selectedPoem(
      at: indexPath.item
    )
    let vc = PoemDetailViewController(poem)
    
    vc.enableAuthorButton = false
    navigationController?.pushViewController(
      vc, animated: true
    )
  }
}
