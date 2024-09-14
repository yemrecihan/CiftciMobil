
import Foundation
import Firebase

class MarketplaceViewModel {
    var products: [Product] = []
        var didUpdateProducts: (() -> Void)?
        
        func fetchOtherUsersProducts() {
            let db = Firestore.firestore()
            let currentUserId = Auth.auth().currentUser?.phoneNumber ?? ""
            
            db.collection("products").whereField("sellerId", isNotEqualTo: currentUserId).getDocuments { [weak self] (snapshot, error) in
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
                    let priceUnit = data["priceUnit"] as? String ?? ""
                    let quantity = data["productQuantity"] as? Int ?? 0
                    let quantityUnit = data["quantityUnit"] as? String ?? ""
                    let description = data["productDescription"] as? String ?? ""
                    let imageURLs = data["productImages"] as? [String] ?? []
                    let sellerPhone = data["sellerId"] as? String ?? ""
                    
                    return Product(name: name, price: price, priceUnit: priceUnit,quantity: quantity,quantityUnit: quantityUnit, description: description, imageURLs: imageURLs, sellerPhone: sellerPhone)
                }
                
                self?.didUpdateProducts?()
            }
        }
}
