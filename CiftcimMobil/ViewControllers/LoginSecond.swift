
import UIKit

class LoginSecond: UIViewController,UITextFieldDelegate {

    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    let viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneNumberTextField.delegate = self
        styleLoginButton()
    }
    private func styleLoginButton() {
            loginButton.backgroundColor = .lightGray
            loginButton.layer.cornerRadius = 10
            loginButton.tintColor = .clear
            loginButton.isEnabled = false
        }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let currentText = textField.text,
           let stringRange = Range(range, in: currentText) {
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
            
            if updatedText.count == 10 {
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
        guard let phoneNumber = phoneNumberTextField.text, !phoneNumber.isEmpty else {
            showAlert(message:"Telefon numarası boş olamaz!")
            return
        }
        viewModel.sendVerificationCode(phoneNumber: phoneNumber) { [weak self ] result in
            switch result {
            case .success():
                print("Doğrulama kodu gönderildi!")
                DispatchQueue.main.async{
                    self?.performSegue(withIdentifier: "toPasswordPageVC", sender: phoneNumber)
                }
            case .failure(let error):
                
                print("Error details: \(error.localizedDescription), \(error)")
                
                if let error = error as NSError?,error.code == 0 {
                    self?.showAlert(title: "Kayıt Ol",message: error.localizedDescription)
                }else {
                    self?.showAlert(message: "Doğrulama kodu gönderme hatası:\(error.localizedDescription)")

                }
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toPasswordPageVC",
                let destinationVC = segue.destination as? PasswordPage,
                let phoneNumber = sender as? String {
                 destinationVC.phoneNumber = phoneNumber
                 destinationVC.isFromSignUp = false // LoginSecond sayfasından geldiğini belirtiyoruz!!!!!!!!
             }
       }
  
    private func showAlert(title:String="Hata",message: String){
        let alert = UIAlertController(title: title,message: message,preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Tamam", style: .default,handler: nil))
        present(alert,animated: true,completion: nil)
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        performSegue(withIdentifier: "toSignUpPage", sender: nil)
    }
    
}
