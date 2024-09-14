

import UIKit

class PasswordPage: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var verificationCodeTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    let viewModel = PasswordViewModel()
    var phoneNumber: String?
    // Kullanıcının Signup sayfasından mı yoksa LoginSecond sayfasından mı geldiğini belirtir
    var isFromSignUp: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Debugging için telefon numarasını kontrol et
              if let phoneNumber = phoneNumber {
                  print("Aktarılan telefon numarası: \(phoneNumber)")
              } else {
                  print("Telefon numarası bulunamadı!")
              }
        verificationCodeTextField.delegate = self 
        setupUI()
      
    }
    private func setupUI() {
        loginButton.backgroundColor = .lightGray
        loginButton.layer.cornerRadius = 10
        loginButton.tintColor = .clear
        loginButton.isEnabled = false
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let currentText = textField.text,
           let stringRange = Range(range, in: currentText) {
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            if updatedText.count == 6 {
                // 10 karaktere ulaşıldığında buton yeşil olur ve aktifleşir
                loginButton.backgroundColor = UIColor.systemGreen
                loginButton.isEnabled = true
            } else {
                // 10 karakterin altında ise buton gri olur ve pasifleşir
                loginButton.backgroundColor = .lightGray
                loginButton.isEnabled = false
            }
        }
        return true
    }
    

    @IBAction func loginButton(_ sender: Any) {
        guard let verificationCode = verificationCodeTextField.text,!verificationCode.isEmpty else {
            showAlert(message: "Doğrulama kodu boş olamaz.")
            return
        }
        guard let phoneNumber = phoneNumber else {
            showAlert(message: "Telefon numarası bulunamadı!")
            return
        }
        viewModel.verifyCode(verificationCode: verificationCode, phoneNumber: phoneNumber,isFromSignUp: isFromSignUp) { [weak self] result in
                  switch result {
                  case .success():
                      print("Kullanıcı doğrulandı.")
                      //Kullanıcı doğrulandıktan sonra telefon numarası kayıt ediliyor ---->>>
                      UserDefaults.standard.set(phoneNumber,forKey: "userPhoneNumber")
                      self?.navigateToMainPage()
                  case .failure(let error):
                      self?.showAlert(message: "Giriş Hatası: \(error.localizedDescription)")
                  }
              }

    }
    private func showAlert(message:String) {
        let alert = UIAlertController(title: "Hata", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
        present(alert,animated: true,completion: nil)
    }
    private func navigateToMainPage(){
        if let tabBarController = storyboard?.instantiateViewController(withIdentifier: "tabBarController") as? UITabBarController {
            tabBarController.modalPresentationStyle = .fullScreen
            self.present(tabBarController,animated: true,completion: nil)
        }
    }
    

}
