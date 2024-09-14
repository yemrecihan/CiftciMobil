

import UIKit

class CampaignsCell: UITableViewCell {

    @IBOutlet weak var campImage: UIImageView!
    
    @IBOutlet weak var campName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
     setUpCellDesign()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

       
    }
    private func setUpCellDesign(){
        
        //hücre köşe yuvarlama
        self.contentView.layer.cornerRadius = 20
        self.contentView.layer.masksToBounds = true
        self.contentView.backgroundColor = UIColor.systemGray6
        
        //Gölge Ekleme
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.2
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 5
        self.layer.masksToBounds = false
 
  
        //İkonlarımızı yuvarlak yapma
        campImage.layer.cornerRadius = campImage.frame.height/2
        campImage.clipsToBounds = true
        campImage.backgroundColor = UIColor.systemGreen
        
        //Label tasarımımız
        campName.font = UIFont.systemFont(ofSize: 16,weight: .medium)
        campName.textColor = UIColor.black
        
    }
    override func layoutSubviews() {
           super.layoutSubviews()
           
           // Hücre arasındaki boşlukları ayarlamak için frame'i ayarlıyoruz
           contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
           
           // Köşe yuvarlama ve gölge ekleme
           contentView.layer.cornerRadius = 15
           layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: contentView.layer.cornerRadius).cgPath
       }

}
