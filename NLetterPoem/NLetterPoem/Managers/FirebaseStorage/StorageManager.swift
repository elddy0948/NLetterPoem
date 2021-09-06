import UIKit
import Firebase

final class StorageManager {
    static let shared = StorageManager()
    private let storage = Storage.storage(url: Privacy.storageURL)
    private let cache = NSCache<NSString, UIImage>()
    
    private init() { }
    
    func uploadImage(with data: Data, email: String, completed: @escaping ((URL?) -> Void)) {
        let reference = storage.reference()
        let testReference = reference.child("\(email)/profileImage.jpeg")
        
        testReference.putData(data, metadata: nil) { metaData, error in
            if let error = error {
                completed(nil)
                debugPrint(error)
            }
            testReference.downloadURL { url, error in
                guard let downloadURL = url else {
                    completed(nil)
                    return
                }
                completed(downloadURL)
            }
        }
    }
    
    func downloadImage(from url: String, completed: @escaping ((UIImage?) -> Void)) {
        let cacheKey = NSString(string: url)
        
        if let image = cache.object(forKey: cacheKey) {
            completed(image)
            return
        }
        
        storage.reference(forURL: url).getData(maxSize: 3 * 1024 * 1024) { [weak self] data, error in
            guard let self = self else { return }
            
            if let error = error {
                completed(nil)
                debugPrint(error)
                return
            }
            
            if let data = data,
               let image = UIImage(data: data) {
                self.cache.setObject(image, forKey: cacheKey)
                completed(image)
                return
            }
        }
    }
}
