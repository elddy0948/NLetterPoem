import Foundation
import FirebaseFirestore
import RxSwift

final class FirestoreNetworkProvider {
  private let firestore: Firestore
  
  public init() {
    firestore = Firestore.firestore()
  }
}
