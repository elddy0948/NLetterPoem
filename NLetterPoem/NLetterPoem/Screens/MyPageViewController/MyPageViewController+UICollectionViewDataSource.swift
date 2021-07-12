import UIKit

extension MyPageViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return user?.poems.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MyPageCollectionViewCell.reuseIdentifier, for: indexPath) as? MyPageCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if let poems = poems {
            let poem = poems[indexPath.item]
            cell.setPoemData(with: poem)
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MyPageHeaderView.reuseIdentifier, for: indexPath)
            guard let typeHeaderView = headerView as? MyPageHeaderView else { return headerView }
            typeHeaderView.configureUser(with: user)
            typeHeaderView.delegate = self
            return typeHeaderView
        default:
            assert(false)
        }
    }
}
