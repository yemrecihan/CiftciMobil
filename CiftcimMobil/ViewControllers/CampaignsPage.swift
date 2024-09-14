
import UIKit

class CampaignsPage: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var viewModel = CampaignsPageViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self

      
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
           if segue.identifier == "showCampaignsList" {
               if let destinationVC = segue.destination as? CampaignsListPage,
                  let indexPath = tableView.indexPathForSelectedRow {
                   let selectedClass = viewModel.getItem(at: indexPath.row).campaignName
                   destinationVC.viewModel = CampaignsPageViewModel(campaignClass: selectedClass)
               }
           }else if segue.identifier == "showOrganizations" {
               
           }
       }
    

}

extension CampaignsPage : UITableViewDelegate,UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems() 
    }
    
   
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
          if indexPath.row < viewModel.numberOfItems() {
              let cell = tableView.dequeueReusableCell(withIdentifier: "CampaignsCell", for: indexPath) as! CampaignsCell
              let campaignClass = viewModel.getItem(at: indexPath.row)
              cell.campName.text = campaignClass.campaignName
              cell.campImage.image = UIImage(named: campaignClass.imageName ?? "image1")
              // Hücrenin seçildiğinde görünüm değişikliğini kontrol etmek için
              cell.selectionStyle = .none
              return cell
          } else {
              let cell = tableView.dequeueReusableCell(withIdentifier: "CampaignsCell", for: indexPath) as! CampaignsCell
              cell.textLabel?.text = "Anlaşmalı Kuruluşlar"
              cell.imageView?.image = UIImage(systemName: "image1")
              cell.campName.numberOfLines = 1
              return cell
          }
      }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedClass = viewModel.getItem(at: indexPath.row).campaignName
            
            if selectedClass == "Anlaşmalı Kuruluşlar" {
                performSegue(withIdentifier: "showOrganizations", sender: self)
            } else {
                performSegue(withIdentifier: "showCampaignsList", sender: self)
            }
        // Seçim efektini kaldırmak için hücreyi hemen deselect ediyoruz
                tableView.deselectRow(at: indexPath, animated: true)
        }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //Hücre arası boşluk
       
        cell.contentView.frame = cell.contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 16, bottom: 8 , right: 16))
        cell.contentView.layer.cornerRadius = 15
        cell.contentView.layer.masksToBounds = true
    }
    
    

    }
