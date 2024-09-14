

import UIKit

class LoanRequestPage: UIViewController {
    @IBOutlet weak var tikButton: UIButton!
    @IBOutlet weak var goOnButton: UIButton!
    
    var istikButtonAccepted = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        styleButton()
        updateButtonState(button: tikButton, isAccepted: istikButtonAccepted) // Başlangıç durumu için butonun durumunu güncelle
    }
    
    private func styleButton() {
        tikButton.setTitle(" ", for: .normal)
        tikButton.backgroundColor = .lightGray
        tikButton.tintColor = .clear
        tikButton.layer.cornerRadius = 10
        tikButton.clipsToBounds = true
        
        goOnButton.setTitle("Devam et", for: .normal)
        goOnButton.backgroundColor = .lightGray
        goOnButton.tintColor = .clear
        goOnButton.layer.cornerRadius = 10
        goOnButton.clipsToBounds = true
        
        
        }

    @IBAction func tikButton(_ sender: UIButton) {
        istikButtonAccepted.toggle()
        updateButtonState(button: sender, isAccepted: istikButtonAccepted)
        goOnButton.isEnabled = istikButtonAccepted // Eğer tik işaretlendiyse, İlerle butonunu aktif yap
        goOnButton.backgroundColor = istikButtonAccepted ? UIColor.systemGreen : UIColor.lightGray // Butonun rengini güncelle
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
    
    @IBAction func goOnButton(_ sender: Any) {
    }
    
}
