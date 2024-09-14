

import UIKit

class CampaignsListPage: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var viewModel: CampaignsPageViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("View did load called")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.reloadData()
    }
}

extension CampaignsListPage: UITableViewDelegate, UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
        print("Number of items: \(viewModel.numberOfItems())")

    }
   
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CampaignsListCell", for: indexPath) as! CampaignsListCell
        print("Cell created for row: \(indexPath.row)")
        let model = viewModel.getItem(at: indexPath.row)
        print("Hücre İçeriği: \(model.campaignName ?? "Boş İsim")")
        cell.title.text = model.campaignName
        cell.descriptionLabel.text = model.campaignDescription
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
           cell.contentView.frame = cell.contentView.frame.inset(by: UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16))
       }
}
