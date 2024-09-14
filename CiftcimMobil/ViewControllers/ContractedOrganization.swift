
import UIKit

class ContractedOrganization: UIViewController,ContractedOrganizationCellDelegate {
    

    @IBOutlet weak var tableView: UITableView!
  var viewModel = ContractedOrganizationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Veri ekleme işlemini kontrol etmek ve veritabanından verileri çekmek
        CampaignService.shared.addDefaultOrganizations()
                
                
                
        // Verilerin geldiğini kontrol etmek için konsola yazdıralım
        for organization in viewModel.organizations {
                    print("Organization Name: \(organization.name)")
                    print("Description: \(organization.description)")
                }
                
                // Tabloyu güncelle
                tableView.reloadData()

       

    }
    func cellButtonTapped(with phoneNumber: String) {
        // Kullanıcıyı aramak için UIAlertController oluşturun
        let alertController = UIAlertController(title: "Sorumlu Kişiyi Ara", message: "\(phoneNumber) numaralı kişiyi aramak istiyor musunuz?", preferredStyle: .actionSheet)
        
        let callAction = UIAlertAction(title: "Ara", style: .default) { _ in
            self.callPhoneNumber(phoneNumber)
        }
        alertController.addAction(callAction)
        
        let cancelAction = UIAlertAction(title: "İptal", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    // Telefon numarasını arama fonksiyonu
        private func callPhoneNumber(_ phoneNumber: String) {
            let formattedNumber = "tel://\(phoneNumber)"
            if let url = URL(string: formattedNumber) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                } else {
                    print("Bu cihazda arama yapılamıyor.")
                }
            }
        }
}
extension ContractedOrganization: UITableViewDelegate, UITableViewDataSource {
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return viewModel.numberOfOrganizations()
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "OrganizationCell", for: indexPath) as! ContractedOrganizationCell
            let organization = viewModel.getOrganization(at: indexPath.row)
            
            cell.title.text = organization.name
            cell.textViewDescription.text = organization.description
            cell.region.text = organization.region
            cell.interestedPerson.text = organization.contactPerson
            cell.personPhone.text = organization.phoneNumber
           
            // Delegate'i hücreye atamamız gerekli --->>>>
            cell.delegate = self
            cell.phoneNumber = organization.phoneNumber
            
            return cell
        }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
           cell.contentView.frame = cell.contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
       }
}

 


