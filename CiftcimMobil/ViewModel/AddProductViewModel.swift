import Foundation
import UIKit

class AddProductViewModel {
    
    func addProduct(product: Product, image:UIImage ,completion: @escaping (Result<Void, Error>) -> Void) {
        // Resmi Firebase Storage'a yükleme
        FirebaseProduct.uploadImage(image: image) { result in
            switch result {
            case .success(let url):
                // Resim URL'sini ürün modeline ekleyin
                var productWithImage = product
                productWithImage.imageURLs.append(url)
                
                // Ürünü Firestore'a kaydetme
                FirebaseProduct.addProductToFirestore(product: productWithImage) { result in
                    switch result {
                    case .success():
                        completion(.success(()))
                    case .failure(let error):
                        completion(.failure(error))
                    }
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

