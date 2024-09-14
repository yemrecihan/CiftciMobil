//
//  CampaignsListCell.swift
//  CiftcimMobil
//
//  Created by Yunus emre cihan on 27.08.2024.
//

import UIKit

class CampaignsListCell: UITableViewCell {

    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    


    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
            /*textViewDescription.font = UIFont.systemFont(ofSize: 14, weight: .regular)
            textViewDescription.textColor = UIColor.darkGray
            textViewDescription.backgroundColor = UIColor.clear*/
            
           
        }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

      
    }

}
