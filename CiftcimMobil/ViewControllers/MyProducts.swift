

import UIKit
import FirebaseFirestore

class MyProducts: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var addProduct: UIBarButtonItem!
    var viewModel = MyProductsViewModel()
    var products: [Product] = [] // Ürünleri saklamak için bir dizi

    override func viewDidLoad() {
          super.viewDidLoad()
          
        tableView.delegate = self
        tableView.dataSource = self
        
        viewModel.didUpdateProducts = { [weak self] in
                self?.products = self?.viewModel.products ?? []
                self?.tableView.reloadData()
        }
          
        // Ürünleri yükle
        viewModel.fetchMyProducts()
        tableView.separatorStyle = .none // Hücreler arasındaki çizgileri kaldır
        tableView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0) // İçerik kenar boşluklarını ayarlayın
        
        self.title = "ÜRÜNLERİM"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 20)]
        addProduct.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .normal)
        
        
                                                                      
      }
    // Ürünü Firebase'den silme işlemi
    func deleteProduct(_ product: Product) {
        let db = Firestore.firestore()
        guard let productId = product.productId else { return } // Ürün ID'sini alın
        
        db.collection("products").document(productId).delete { error in
            if let error = error {
                print("Ürün silinirken hata oluştu: \(error.localizedDescription)")
            } else {
                print("Ürün başarıyla silindi.")
                self.viewModel.fetchMyProducts() // Ürünler listesini güncelle
            }
        }
    }
   

      // URL'den resim yüklemek için fonksiyon
      func loadImage(urlString: String, completion: @escaping (UIImage?) -> Void) {
          guard let url = URL(string: urlString) else {
              completion(nil)
              return
          }

          let task = URLSession.shared.dataTask(with: url) { data, response, error in
              if let error = error {
                  print("Resim yüklenirken hata oluştu: \(error.localizedDescription)")
                  completion(nil)
                  return
              }

              guard let data = data, let image = UIImage(data: data) else {
                  completion(nil)
                  return
              }

              completion(image)
          }
          
          task.resume()
      }
    
    @IBAction func addProductButtonTapped(_ sender: UIBarButtonItem) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let addProductVC = storyboard.instantiateViewController(withIdentifier: "AddProduct") as? AddProduct {
            // Ürün eklendiğinde yapılacak işlemi tanımlayın
            addProductVC.onProductAdded = { [weak self] in
                self?.viewModel.fetchMyProducts() // Ürünler listesini güncelle
            }
            self.navigationController?.pushViewController(addProductVC, animated: true)
        }
    }
}

  extension MyProducts: UITableViewDelegate, UITableViewDataSource {
      
      func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return products.count
      }
      
      func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          guard let cell = tableView.dequeueReusableCell(withIdentifier: "MyProductsCell", for: indexPath) as? MyProductsCell else {
              return UITableViewCell()
          }
          
          let product = products[indexPath.row]
          // Ürün Adı: Bold ve geri kalanı normal
             let productName = "Ürün Adı: "
             let productNameValue = product.name ?? "Bilinmeyen"
             let productNameAttributedString = NSMutableAttributedString(string: productName, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)])
             productNameAttributedString.append(NSAttributedString(string: productNameValue))
             cell.productName.attributedText = productNameAttributedString

             // Miktar: Bold ve geri kalanı normal
             let quantityText = "Miktar: "
             let quantityValue = product.quantity != nil ? "\(product.quantity!) \(product.quantityUnit ?? "")" : ""
             let quantityAttributedString = NSMutableAttributedString(string: quantityText, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)])
             quantityAttributedString.append(NSAttributedString(string: quantityValue))
             cell.productQuantity.attributedText = quantityAttributedString

             // Fiyat: Bold ve geri kalanı normal
             let priceText = "Fiyat: "
             let priceValue = product.price != nil ? "\(product.price!) \(product.priceUnit ?? "")" : ""
             let priceAttributedString = NSMutableAttributedString(string: priceText, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)])
             priceAttributedString.append(NSAttributedString(string: priceValue))
             cell.productPrice.attributedText = priceAttributedString

             // Açıklama: Bold ve geri kalanı normal
             let descriptionText = "Açıklama: "
             let descriptionValue = product.description ?? "Açıklama yok"
             let descriptionAttributedString = NSMutableAttributedString(string: descriptionText, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 16)])
             descriptionAttributedString.append(NSAttributedString(string: descriptionValue))
             cell.productDescription.attributedText = descriptionAttributedString
        
          
          if let firstImageURL = product.imageURLs.first {
              loadImage(urlString: firstImageURL!) { image in
                  DispatchQueue.main.async {
                      cell.productImage.image = image
                  }
              }
          } else {
              cell.productImage.image = nil
          }
          // Ürünü silme işlemi için closure tanımlayın
          cell.deleteAction = { [weak self] in
              self?.showDeleteConfirmation(for: product)
          }
          cell.setupCell()
          return cell
      }
      // Silme işlemi için uyarı gösterme
      func showDeleteConfirmation(for product: Product) {
          let alert = UIAlertController(title: "Ürünü Sil", message: "Ürünü silmek istediğinizden emin misiniz?", preferredStyle: .alert)
          alert.addAction(UIAlertAction(title: "Sil", style: .destructive, handler: { [weak self] _ in
              self?.deleteProduct(product)
          }))
          alert.addAction(UIAlertAction(title: "İptal", style: .cancel, handler: nil))
          present(alert, animated: true, completion: nil)
      }
      func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
              return 350 // Hücre yüksekliğini ayarlayın
          }


      func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
          return 20 // Hücreler arası boşluk
      }
      
      func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
          return 20 // Hücrelerin üstüne boşluk
      }
      
      func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
            let footerView = UIView()
            footerView.backgroundColor = .clear
            return footerView
        }

  }

