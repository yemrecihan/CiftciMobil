
import UIKit
import FirebaseAuth

class ProfilePage: UIViewController {

    
    @IBOutlet weak var line1Label: UILabel!
    
    @IBOutlet weak var line2Label: UILabel!
    @IBOutlet weak var logOutIcon: UIImageView!
    
    @IBOutlet weak var deleteIcon: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    
    let viewModel = ProfilViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let phoneNumber = viewModel.getUserPhoneNumber(){
            userNameLabel.text = "Kullanıcı adı : \(phoneNumber)"
        }else {
            userNameLabel.text = "Kullanıcı adı bulunamadı."
        }

    }
    
    @IBAction func logOutButton(_ sender: Any) {
        viewModel.logout()
        
        //LoginFirst sayfasına yönlendirme --->>
        if let loginFirstVC = storyboard?.instantiateViewController(withIdentifier: "LoginFirst"){
            loginFirstVC.modalPresentationStyle = .fullScreen
            present(loginFirstVC,animated: true , completion: nil)
        }
    }
    
    @IBAction func deleteAccountButton(_ sender: Any) {
    }
  

}
