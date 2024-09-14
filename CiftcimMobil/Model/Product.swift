

import Foundation
import UIKit

struct Product {
    var productId: String?
    var name: String?
    var price: Double?
    var priceUnit: String?
    var quantity: Int?
    var quantityUnit: String? // Örneğin "Kg", "Ton", vb.
    var description: String?
    var imageURLs: [String?] // Resimlerin Firebase Storage URrleri
    var image : UIImage?
    var sellerPhone : String?
}
