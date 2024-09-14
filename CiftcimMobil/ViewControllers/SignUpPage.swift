

import UIKit

class SignUpPage: UIViewController {
    let viewModel = SignUpViewModel()
    
    @IBOutlet weak var telNoTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var rızaButton: UIButton!
    @IBOutlet weak var aydınlatma2Button: UIButton!
    @IBOutlet weak var aydınlatmaButton: UIButton!
    
    var isAydınlatmaAccepted = false
    var isAydınlatma2Accepted = false
    var isRızaAccepted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateSignUpButtonState()
        styleButtons()
        
        configureTapGesture()
    }
    // Dokunma tanıyıcıyı yapılandırmafonksiyon
     private func configureTapGesture() {
         let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
         view.addGestureRecognizer(tapGesture)
     }
    // Klavyeyi kapatmak için fonksiyon
       @objc func dismissKeyboard() {
           view.endEditing(true)
       }
    private func styleButtons() {
        // Başlangıçta tüm butonlar gri renkte olsun
        aydınlatmaButton.setTitle(" ", for: .normal)
        aydınlatmaButton.backgroundColor = .lightGray
        aydınlatmaButton.tintColor = .clear
        aydınlatmaButton.layer.cornerRadius = 10
        aydınlatmaButton.clipsToBounds = true
        
        aydınlatma2Button.setTitle(" ", for: .normal)
        aydınlatma2Button.backgroundColor = .lightGray
        aydınlatma2Button.tintColor = .clear
        aydınlatma2Button.layer.cornerRadius = 10
        aydınlatma2Button.clipsToBounds = true
        
        rızaButton.setTitle(" ", for: .normal)
        rızaButton.backgroundColor = .lightGray
        rızaButton.tintColor = .clear
        rızaButton.layer.cornerRadius = 10
        rızaButton.clipsToBounds = true

        // Kayıt ol butonu gri renkte
        signUpButton.backgroundColor = .lightGray
        signUpButton.isEnabled = false
        signUpButton.tintColor = .clear
        signUpButton.layer.cornerRadius = 10
        signUpButton.clipsToBounds = true
        }
    
    
    @IBAction func aydınlatmaButton(_ sender: UIButton) {
        isAydınlatmaAccepted.toggle()
        updateButtonState(button: sender, isAccepted: isAydınlatmaAccepted)
        updateSignUpButtonState()
    }
    
    @IBAction func aydınlatma2Button(_ sender: UIButton) {
        isAydınlatma2Accepted.toggle()
        updateButtonState(button: sender, isAccepted: isAydınlatma2Accepted)
        updateSignUpButtonState()
    }
    
    @IBAction func rızaButton(_ sender: UIButton) {
        isRızaAccepted.toggle()
        updateButtonState(button: sender, isAccepted: isRızaAccepted)
        updateSignUpButtonState()
    }
    private func updateButtonState(button: UIButton, isAccepted: Bool) {
          if isAccepted {
              button.setTitle("✓", for: .normal)
              button.backgroundColor = UIColor.systemGreen
          } else {
              button.setTitle(" ", for: .normal)
              button.backgroundColor = UIColor.lightGray
          }
      }
    private func updateSignUpButtonState() {
        // Tüm kutucuklar işaretlenirse kayıt ol butonu etkinleştirilsin ve yeşil olsun
        if isAydınlatmaAccepted && isAydınlatma2Accepted && isRızaAccepted {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = UIColor.systemGreen
            signUpButton.tintColor = UIColor.systemGreen
        } else {
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = UIColor.lightGray
            signUpButton.tintColor = .clear
        }
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        guard let phoneNumber = telNoTextField.text, !phoneNumber.isEmpty else {
            showAlert(message: "Telefon numarası boş olamaz!")
            return
           
            
        }
        // Telefon numarasını +90 ile başlayan formata çevir
        let formattedPhoneNumber: String
        if phoneNumber.hasPrefix("+") {
            formattedPhoneNumber = phoneNumber
        } else {
            formattedPhoneNumber = "+90" + phoneNumber
        }
        print("Girilen telefon numarası: \(formattedPhoneNumber)")
        
        viewModel.sendVerificationCode(phoneNumber: formattedPhoneNumber) { [weak self] result in
               switch result {
               case .success():
                   print("Doğrulama kodu gönderildi.")
                   DispatchQueue.main.async {
                       self?.performSegue(withIdentifier: "signUptoPasswordPageVC", sender: formattedPhoneNumber)
                   }
               case .failure(let error):
                   self?.showAlert(message: "Hata: \(error.localizedDescription)")
               }
           }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "signUptoPasswordPageVC",
                  let destinationVC = segue.destination as? PasswordPage,
                  let phoneNumber = sender as? String {
                   destinationVC.phoneNumber = phoneNumber
                   destinationVC.isFromSignUp = true // SignUp sayfasından geldiğini belirt
               }
       }
      
        
        @IBAction func loginButton(_ sender: Any) {
            performSegue(withIdentifier: "toLoginFirstVC", sender: nil)
        }
        private func showAlert(message: String) {
            let alert = UIAlertController(title: "Hata", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Tamam", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }

