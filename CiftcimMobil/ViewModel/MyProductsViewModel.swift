
import Foundation
import Firebase

class MyProductsViewModel {
    
    var products: [Product] = [] // Firebase'den alınan ürünler
    var didUpdateProducts: (() -> Void)? // Ürünler güncellendiğinde çağrılacak closure
    var listener: ListenerRegistration? //Dinleyici kaydımız....(Firebase )
    
    func fetchMyProducts() {
        guard let sellerId = Auth.auth().currentUser?.phoneNumber else {
            print("Kullanıcı telefon numarası alınamadı.")
            return
        }
        
        let db = Firestore.firestore()
        
        listener?.remove()
        
        // Dinleyiciyi başlatıyoruz
        listener = db.collection("products").whereField("sellerId", isEqualTo: sellerId).addSnapshotListener { [weak self] (snapshot, error) in
            if let error = error {
                print("Ürünler alınırken hata oluştu: \(error.localizedDescription)")
                return
            }
            
            guard let documents = snapshot?.documents else {
                print("Ürün belgesi bulunamadı.")
                return
            }
            
            self?.products = documents.compactMap { doc -> Product? in
                let data = doc.data()
                let name = data["productName"] as? String ?? ""
                let price = data["productPrice"] as? Double ?? 0.0
                let quantity = data["productQuantity"] as? Int ?? 0
                let description = data["productDescription"] as? String ?? ""
                let imageURLs = data["productImages"] as? [String] ?? []
                let priceUnit = data["priceUnit"] as? String ?? "TL"
                let quantityUnit = data["quantityUnit"] as? String ?? "kg"
                let productId = data["productId"] as? String ?? ""
                
                return Product(productId: productId, name: name, price: price, priceUnit: priceUnit, quantity: quantity, quantityUnit: quantityUnit, description: description, imageURLs: imageURLs)
            }
            
            DispatchQueue.main.async {
                self?.didUpdateProducts?()
            }
        }
    }
    deinit {
        listener?.remove() //Dinleyiciyi kaldırıyoruz
    }
    static func deleteProductFromFirestore(product: Product, completion: @escaping (Result<Void, Error>) -> Void) {
        let db = Firestore.firestore()
        guard let productId = product.productId else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Ürün ID'si bulunamadı."])))
            return
        }
        
        db.collection("products").document(productId).delete { error in
            if let error = error {
                print("Ürün silinirken hata oluştu: \(error.localizedDescription)")
                completion(.failure(error))
            } else {
                print("Ürün başarıyla silindi.")
                completion(.success(()))
            }
        }
    }
}


