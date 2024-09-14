import Foundation
import Firebase
import FirebaseStorage

class FirebaseProduct {
    
    static func addProductToFirestore(product: Product, completion: @escaping (Result<Void, Error>) -> Void) {
        let db = Firestore.firestore()
        let productRef = db.collection("products").document()
        let productData: [String: Any] = [
            "productId": productRef.documentID,
            "sellerId": Auth.auth().currentUser?.phoneNumber ?? "",
            "productName": product.name,
            "productPrice": product.price,
            "priceUnit": product.priceUnit,
            "productQuantity": product.quantity,
            "quantityUnit": product.quantityUnit,
            "productDescription": product.description,
            "productImages": product.imageURLs, // Resimlerin Firebase Storage URL'leri
            "productStatus": "satışta",
            "createdAt": Timestamp(date: Date())
        ]
        
        productRef.setData(productData) { error in
            if let error = error {
                print("Ürün eklenirken hata oluştu: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                print("Ürün başarıyla eklendi.")
                completion(.success(()))
            }
        }
    }
    static func uploadImage(image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Resim verisi oluşturulamadı."])))
            return
        }
        
        let storageRef = Storage.storage().reference().child("productImages/\(UUID().uuidString).jpg")
        
        storageRef.putData(imageData, metadata: nil) { (metadata, error) in
            if let error = error {
                print("Resim yüklenirken hata oluştu: \(error.localizedDescription)")
                completion(.failure(error))
                return
            }
            
            storageRef.downloadURL { (url, error) in
                if let error = error {
                    print("Resim URL'si alınırken hata oluştu: \(error.localizedDescription)")
                    completion(.failure(error))
                    return
                }
                
                guard let downloadURL = url else {
                    completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "URL alınamadı."])))
                    return
                }
                print("Resim başarıyla yüklendi: \(downloadURL.absoluteString)")
                completion(.success(downloadURL.absoluteString))
            }
        }
    }
}

