
import UIKit

protocol ContractedOrganizationCellDelegate: AnyObject {
    func cellButtonTapped(with phoneNumber: String)
}


class ContractedOrganizationCell: UITableViewCell {
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var textViewDescription: UITextView!
    
    @IBOutlet weak var region: UILabel!
    
    @IBOutlet weak var interestedPerson: UILabel!
    
    @IBOutlet weak var personPhone: UILabel!
    
    weak var delegate: ContractedOrganizationCellDelegate?
    var phoneNumber: String?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
      setupCellDesign()
    }
    private func setupCellDesign() {
            // Hücre köşe yuvarlama
            self.contentView.layer.cornerRadius = 10
            self.contentView.layer.masksToBounds = true
            self.contentView.backgroundColor = UIColor.systemGray6
            
            // Gölge Ekleme
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 0.2
            self.layer.shadowOffset = CGSize(width: 0, height: 2)
            self.layer.shadowRadius = 5
            self.layer.masksToBounds = false
            
            // Başlık Label Tasarımı
            title.font = UIFont.systemFont(ofSize: 18, weight: .bold)
            title.textColor = UIColor.black
            
            // Açıklama Metni Tasarımı
            textViewDescription.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            textViewDescription.textColor = UIColor.darkGray
            textViewDescription.backgroundColor = UIColor.clear
            
            // Bölge, İlgili Kişi ve Telefon Numarası Tasarımı
            region.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            region.textColor = UIColor.gray
            
            interestedPerson.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            interestedPerson.textColor = UIColor.gray
            
            personPhone.font = UIFont.systemFont(ofSize: 14, weight: .medium)
            personPhone.textColor = UIColor.blue
        }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
    @IBAction func communicationButton(_ sender: Any) {
        if let phoneNumber=phoneNumber{
            delegate?.cellButtonTapped(with: phoneNumber)
        }
        
    }
    
    
}
