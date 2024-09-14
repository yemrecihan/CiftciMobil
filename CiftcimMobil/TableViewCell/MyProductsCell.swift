

import UIKit

class MyProductsCell: UITableViewCell {
    
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productQuantity: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productDescription: UILabel!
    
    @IBOutlet weak var deleteProduct: UIButton!
    var deleteAction: (() -> Void)?
    
    // Yeni eklenen arka plan görünümü
    private let backgroundContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = false
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.lightGray.cgColor
 
        return view
    }()
    
    // Üst Boşluk için Görünmez Bir Görünüm (Padding)
    private let paddingView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func setupCell() {
        // Arka plan görünümünü ekleyin ve sınırlamalarını ayarlayın
        contentView.addSubview(backgroundContainerView)
        backgroundContainerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundContainerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            backgroundContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            backgroundContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            backgroundContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])

        // Padding view'i backgroundContainerView'e ekleyin
        backgroundContainerView.addSubview(paddingView)
        paddingView.topAnchor.constraint(equalTo: backgroundContainerView.topAnchor).isActive = true
        paddingView.leadingAnchor.constraint(equalTo: backgroundContainerView.leadingAnchor).isActive = true
        paddingView.trailingAnchor.constraint(equalTo: backgroundContainerView.trailingAnchor).isActive = true
        paddingView.heightAnchor.constraint(equalToConstant: 10).isActive = true // 10 birimlik üst boşluk

        // Diğer bileşenleri backgroundContainerView'e ekleyin
        backgroundContainerView.addSubview(productImage)
        backgroundContainerView.addSubview(productName)
        backgroundContainerView.addSubview(productQuantity)
        backgroundContainerView.addSubview(productPrice)
        backgroundContainerView.addSubview(productDescription)
        backgroundContainerView.addSubview(deleteProduct)
  
        
        // Bileşenler için Auto Layout ayarlamaları
        productImage.translatesAutoresizingMaskIntoConstraints = false
        productName.translatesAutoresizingMaskIntoConstraints = false
        productQuantity.translatesAutoresizingMaskIntoConstraints = false
        productPrice.translatesAutoresizingMaskIntoConstraints = false
        productDescription.translatesAutoresizingMaskIntoConstraints = false
        deleteProduct.translatesAutoresizingMaskIntoConstraints = false
      

        NSLayoutConstraint.activate([
            // Ürün Resmi (productImage) için sınırlamalar
            productImage.topAnchor.constraint(equalTo: paddingView.bottomAnchor, constant: 10),
            productImage.centerXAnchor.constraint(equalTo: backgroundContainerView.centerXAnchor), // Resmi yatayda ortala
            productImage.widthAnchor.constraint(equalTo: backgroundContainerView.widthAnchor, multiplier: 0.60), // Genişliği %90 yap
            productImage.heightAnchor.constraint(equalToConstant: 150),
            
            // "Ürünü Sil" butonu için sınırlamalar
            deleteProduct.centerYAnchor.constraint(equalTo: productImage.centerYAnchor),
            deleteProduct.leadingAnchor.constraint(equalTo: productImage.trailingAnchor, constant: 10),
            deleteProduct.trailingAnchor.constraint(equalTo: backgroundContainerView.trailingAnchor, constant: -10),
            deleteProduct.widthAnchor.constraint(equalToConstant: 80),
            deleteProduct.heightAnchor.constraint(equalToConstant: 30),

            
            // Ürün Adı (productName) için sınırlamalar
            productName.topAnchor.constraint(equalTo: productImage.bottomAnchor, constant: 10),
            productName.leadingAnchor.constraint(equalTo: backgroundContainerView.leadingAnchor, constant: 70),
            productName.trailingAnchor.constraint(equalTo: backgroundContainerView.trailingAnchor, constant: -10),

            // Ürün Miktarı (productQuantity) için sınırlamalar
            productQuantity.topAnchor.constraint(equalTo: productName.bottomAnchor, constant: 5),
            productQuantity.leadingAnchor.constraint(equalTo: backgroundContainerView.leadingAnchor, constant: 70),
            productQuantity.trailingAnchor.constraint(equalTo: backgroundContainerView.trailingAnchor, constant: -10),

            // Ürün Fiyatı (productPrice) için sınırlamalar
            productPrice.topAnchor.constraint(equalTo: productQuantity.bottomAnchor, constant: 5),
            productPrice.leadingAnchor.constraint(equalTo: backgroundContainerView.leadingAnchor, constant: 70),
            productPrice.trailingAnchor.constraint(equalTo: backgroundContainerView.trailingAnchor, constant: -10),

            // Ürün Açıklaması (productDescription) için sınırlamalar
            productDescription.topAnchor.constraint(equalTo: productPrice.bottomAnchor, constant: 5),
            productDescription.leadingAnchor.constraint(equalTo: backgroundContainerView.leadingAnchor, constant: 70),
            productDescription.trailingAnchor.constraint(equalTo: backgroundContainerView.trailingAnchor, constant: -10),

            
        ])

        // Ürün Resmi için Stil
        productImage.layer.cornerRadius = 8
        productImage.layer.masksToBounds = true
        productImage.layer.borderWidth = 0.5
        productImage.layer.borderColor = UIColor.lightGray.cgColor
        productImage.contentMode = .scaleAspectFill

        // Background için gölge efekti
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 4.0
        self.layer.shadowOpacity = 0.2
        self.layer.masksToBounds = false
    }

    @IBAction func deleteButtonTapped(_ sender: UIButton) {
        deleteAction?()
    }
    
}
