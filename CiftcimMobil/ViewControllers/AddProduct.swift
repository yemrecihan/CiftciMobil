import UIKit

class AddProduct: UIViewController , UIImagePickerControllerDelegate , UINavigationControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource{
    
    @IBOutlet weak var productImage: UIImageView!
    
    @IBOutlet weak var productName: UITextField!
    
    @IBOutlet weak var productQuantity: UITextField!
    
    @IBOutlet weak var productPrice: UITextField!
    
    @IBOutlet weak var productDescription: UITextView!
    
    @IBOutlet weak var quantityUnitPicker: UIPickerView!
    
    @IBOutlet weak var priceUnitPickerView: UIPickerView!
    
    @IBOutlet weak var addProductButton: UIButton!
    
    var viewModel = AddProductViewModel()
    
    var onProductAdded: (() -> Void)? // ürün eklendiğinde çağıralcak closure
    
    var selectedImage: UIImage?
    
    let priceUnits = ["TL", "USD", "EUR"]
    let quantityUnits = ["kg", "ton", "litre"]

    var selectedPriceUnit: String = "TL"
    var selectedQuantityUnit: String = "kg"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // PickerView delegeleri ve veri kaynakları ayarlanıyor
        priceUnitPickerView.delegate = self
        priceUnitPickerView.dataSource = self
        quantityUnitPicker.delegate = self
        quantityUnitPicker.dataSource = self
        
        setupUI()

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(selectImage))
        productImage.isUserInteractionEnabled = true
        productImage.addGestureRecognizer(tapGestureRecognizer)
    }
    func setupUI() {
        
        // TextField'lar için Stil
        styleTextField(textField: productName)
        styleTextField(textField: productQuantity)
        styleTextField(textField: productPrice)
        
        // TextView için Stil
        productDescription.layer.borderColor = UIColor.lightGray.cgColor
        productDescription.layer.borderWidth = 1.0
        productDescription.layer.cornerRadius = 5.0
        productDescription.layer.masksToBounds = true
        productDescription.font = UIFont.systemFont(ofSize: 14)
        productDescription.textColor = .darkGray
        
        // Buton için Stil
        styleButton(button: addProductButton)
    }

    // Tekrarlayan Stil Ayarları için Yardımcı Fonksiyonlar
    func styleTextField(textField: UITextField) {
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 5.0
        textField.layer.masksToBounds = true
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textColor = .darkGray
        textField.backgroundColor = UIColor(white: 0.95, alpha: 1)
        textField.setLeftPaddingPoints(10)
    }

    func styleButton(button: UIButton) {
        button.backgroundColor = UIColor.systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8.0
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.3
        button.layer.shadowRadius = 4.0
    }

    
    @objc func selectImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            productImage.image = selectedImage
            self.selectedImage = selectedImage
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func AddProductButton(_ sender: Any) {
        print("AddProductButton tıklandı")
        
        guard let name = productName.text?.trimmingCharacters(in: .whitespacesAndNewlines), !name.isEmpty,
              let quantityText = productQuantity.text?.trimmingCharacters(in: .whitespacesAndNewlines), let quantity = Int(quantityText),
              let priceText = productPrice.text?.trimmingCharacters(in: .whitespacesAndNewlines), let price = Double(priceText),
              let description = productDescription.text?.trimmingCharacters(in: .whitespacesAndNewlines), !description.isEmpty else {
            showAlert(message: "Lütfen tüm alanları doldurunuz.")
            print("Tüm alanlar doldurulmadı")
            return
        }
        guard let image = selectedImage else {
            showAlert(message: "Lütfen bir resim seçin.")
            print("Resim seçilmedi")
            return
        }
        print("Tüm alanlar dolduruldu")
        let newProduct = Product(
                    name: name,
                    price: price,
                    priceUnit: selectedPriceUnit, // Seçili para birimi
                    quantity: quantity,
                    quantityUnit: selectedQuantityUnit, // Seçili miktar birimi
                    description: description,
                    imageURLs: []
                )
        viewModel.addProduct(product: newProduct, image: image) { [weak self] result in
                    switch result {
                    case .success():
                        DispatchQueue.main.async {
                            self?.showAlert(message: "Ürün başarıyla eklendi.")
                            self?.onProductAdded?()
                            self?.navigationController?.popViewController(animated: true)
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            self?.showAlert(message: "Ürün eklenirken hata oluştu: \(error.localizedDescription)")
                        }
                    }
                }
            }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Bilgi", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == priceUnitPickerView {
            return priceUnits.count
        } else {
            return quantityUnits.count
        }
    }
    
    // MARK: - UIPickerViewDelegate
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == priceUnitPickerView {
            return priceUnits[row]
        } else {
            return quantityUnits[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == priceUnitPickerView {
            selectedPriceUnit = priceUnits[row]
        } else {
            selectedQuantityUnit = quantityUnits[row]
        }
    }
}

extension UITextField {
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
