import UIKit

extension UserProfileViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return poemListViewModel.count
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MyPageCollectionViewCell.reuseIdentifier,
            for: indexPath) as? MyPageCollectionViewCell else {
      return UICollectionViewCell()
    }
    let poemViewModel = poemListViewModel.poemViewModel(
      at: indexPath.item
    )
    
    cell.setPoemData(with: poemViewModel)
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      viewForSupplementaryElementOfKind kind: String,
                      at indexPath: IndexPath) -> UICollectionReusableView {
    switch kind {
    case UICollectionView.elementKindSectionHeader:
      let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                       withReuseIdentifier: UserProfileHeaderView.reuseIdentifier,
                                                                       for: indexPath)
      guard let typeHeaderView = headerView as? UserProfileHeaderView else { return headerView }
      let userViewModel = userViewModel
      typeHeaderView.configureUser(with: userViewModel)
      return typeHeaderView
    default:
      assert(false)
    }
    return UICollectionReusableView()
  }
}
