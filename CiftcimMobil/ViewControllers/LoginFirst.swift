

import UIKit

class LoginFirst: UIViewController {

    
    @IBOutlet weak var bankIconImageView: UIImageView!
    @IBOutlet weak var signUpButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtonStyles()
      
     
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        setupButtonStyles()
     
       }
    

    @IBAction func loginButton(_ sender: Any) {
        performSegue(withIdentifier: "toLoginSecondVC", sender: nil)
    }
    
    @IBAction func signUpButton(_ sender: Any) {
        performSegue(withIdentifier: "toSignUpPageVC", sender: nil)
    }
    private func setupButtonStyles() {
            signUpButton.backgroundColor = UIColor.green
            let cornerRadius: CGFloat = 10
            signUpButton.layer.cornerRadius = cornerRadius
            signUpButton.layer.masksToBounds = true
        }
    
    
   
}

