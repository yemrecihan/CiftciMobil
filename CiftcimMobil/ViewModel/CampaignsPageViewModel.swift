import Foundation
import SQLite

class CampaignsPageViewModel {
    var items: [CampaignsModel] = []
    let campaignClass: String?
    
    init(campaignClass: String? = nil) {
        self.campaignClass = campaignClass
        fetchCampaigns()
    }
    
    func fetchCampaigns() {
        if let campaignClass = campaignClass {
            // Veritabanından sadece belirli bir kampanya sınıfına ait kampanyaları çek
            do {
                if let db = DatabaseManager.shared.db {
                    // String türünü Expression ile karşılaştırmak için == operatörünü kullanarak Expression<String> yaratıyoruz
                    let query = DatabaseManager.shared.campaignsTable.filter(DatabaseManager.shared.campaignClass == campaignClass)
                    for campaign in try db.prepare(query) {
                        let campaignName = campaign[DatabaseManager.shared.campaignTitle]
                        let campaignDescription = campaign[DatabaseManager.shared.campaignDescription]
                        items.append(CampaignsModel(campaignName: campaignName, imageName: "defaultImage",campaignDescription: campaignDescription))
                    }
                }
            } catch {
                print("Error fetching campaigns: \(error)")
            }
        } else {
            // Kampanya sınıflarını listele
            items = [
                CampaignsModel(campaignName: "Kredi-Kart-Sigorta", imageName: "image1",campaignDescription: nil),
                CampaignsModel(campaignName: "Gübre", imageName: "image1",campaignDescription: nil),
                CampaignsModel(campaignName: "Akaryakıt", imageName: "image1",campaignDescription: nil),
                CampaignsModel(campaignName: "Yem", imageName: "image1",campaignDescription: nil),
                CampaignsModel(campaignName: "Anlaşmalı Kuruluşlar", imageName: "image1", campaignDescription: nil)
            ]
        }
    }
    
    func getItem(at index: Int) -> CampaignsModel {
        return items[index]
    }
    
    func numberOfItems() -> Int {
        return items.count
    }
}

