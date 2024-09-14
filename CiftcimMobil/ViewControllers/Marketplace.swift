

import UIKit

class Marketplace: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel = MarketplaceViewModel()
    var products: [Product] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 150

        viewModel.didUpdateProducts = { [weak self] in
            self?.products = self?.viewModel.products ?? []
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }

        viewModel.fetchOtherUsersProducts()
        tableView.separatorStyle = .none
        
        self.title = "ÇİFTÇİ PAZARI"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 20)]
        
    }
}
extension Marketplace: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FarmersMarketCell", for: indexPath) as? MarketplaceCell else {
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

        
        let phoneNumber = product.sellerPhone ?? "Bilinmeyen"
        cell.communicationButtonNumber.setTitle("İletişime geç: \(phoneNumber)", for: .normal)
        
        cell.communicationButtonNumber.addTarget(self, action: #selector(callSeller(_:)), for: .touchUpInside)
        cell.communicationButtonNumber.tag = indexPath.row
        
        if let firstImageURL = product.imageURLs.first {
            loadImage(urlString: firstImageURL!) { image in
                DispatchQueue.main.async {
                    cell.productImage.image = image
                }
            }
        } else {
            cell.productImage.image = nil
        }
        // Hücre için içerik kenar boşlukları (padding) ekleyin
        cell.contentView.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        return cell
    }
    @objc func callSeller(_ sender: UIButton) {
            let product = products[sender.tag]
            if let phoneNumber = product.sellerPhone {
                // Telefon numarasını formatla
                let formattedNumber = phoneNumber.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "-", with: "")
                if let url = URL(string: "tel://\(formattedNumber)"), UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    // Hata durumunu göster
                    showAlert(message: "Arama yapılamıyor.")
                }
            }
        }
    // Hücreler arasında boşluk oluşturmak için heightForRowAt metodu
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 370 // Hücrenin yüksekliğini ayarlayın (örneğin, 150)
    }


    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Hata", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

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
}
