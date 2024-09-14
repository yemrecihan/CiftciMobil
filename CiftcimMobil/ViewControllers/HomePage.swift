

import UIKit

class HomePage: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var viewModel = HomePageViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        
        tableView.dataSource = self
        tableView.delegate = self
        
        self.title = "ÇİFTÇİ MOBİL"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font:UIFont.boldSystemFont(ofSize: 20)]

     
    }
    

   

}
extension HomePage: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeCell", for: indexPath) as! HomeCell
        let model = viewModel.getItem(at: indexPath.row)
        cell.nameLabel.text = model.cellName
        cell.areaImageView.image = UIImage(named: model.cellImage ?? "ee")
        return cell
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath.row {
        case 0:
            performSegue(withIdentifier: "toAddFieldPageVC", sender: self)
        case 1:
            performSegue(withIdentifier: "toLoanPageVC", sender: self)
        case 2:
            performSegue(withIdentifier: "toCampaignsPageVC", sender: self)
        default :
            break
        }
        
        
    }
   
    
    
    
    
    
    
}
