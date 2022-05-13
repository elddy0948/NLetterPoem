import UIKit

extension UserProfileViewController: UICollectionViewDataSource {
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      numberOfItemsInSection section: Int) -> Int {
    return 0
  }
  
  func collectionView(_ collectionView: UICollectionView,
                      cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: MyPageCollectionViewCell.reuseIdentifier,
            for: indexPath) as? MyPageCollectionViewCell else {
      return UICollectionViewCell()
    }
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
//      let userViewModel = userViewModel
//      typeHeaderView.configureUser(with: userViewModel)
      return typeHeaderView
    default:
      assert(false)
    }
    return UICollectionReusableView()
  }
}
