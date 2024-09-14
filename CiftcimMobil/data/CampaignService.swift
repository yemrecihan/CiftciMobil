
import Foundation

class CampaignService {
    
    static let shared = CampaignService()
    
    private init() {}
    
    func addDefaultCampaigns() {
        if !DatabaseManager.shared.isCampaignExists(title: "Mısır Kredisi ile Çiftçiye Destek Şekerbank'ta Gelenek") {
            DatabaseManager.shared.addCampaign(
                campaignclass: "Kredi-Kart-Sigorta",
                title: "Mısır Kredisi ile Çiftçiye Destek Şekerbank'ta Gelenek",
                description: "Hasat döneminden sonra değerine satabilmelerine imkan sağlamak ve bu kısa dönemde müşterilerin finansman ihtiyaçlarını karşılamaya yönelik Mısır Üreticileri Kredi Kampanya düzenlenmiştir."
            )
            print("Kampanya başarıyla eklendi.")
        } else {
            print("Kampanya zaten mevcut.")
        }
    }
    func addDefaultOrganizations() {
            if !DatabaseManager.shared.isOrganizationExists(name: "Emre Teknoloji A.Ş") {
                DatabaseManager.shared.addOrganization(
                    to: 1,  // Örneğin, ilk kampanyaya bağlı olarak eklenebilir.
                    title: "Emre Teknoloji A.Ş",
                    description: "Tarımsal ekipman satın alan üreticilerin finansman ihtiyaçlarını karşılamak amacıyla sıfır faizli Fatura Karşılığı Katkı Payı Kredi Kampanya imkanı",
                    region: "Ankara-Yenimahalle",
                    contactPerson: "Yunus Emre Cihan",
                    contactPhone: "05416280420"
                )
                print("Anlaşmalı kuruluş başarıyla eklendi.")
            } else {
                print("Anlaşmalı kuruluş zaten mevcut.")
            }
        }
    // Anlaşmalı kuruluşu silme fonksiyon
    func deleteOrganization(name: String) -> Bool {
        return DatabaseManager.shared.deleteOrganization(name: name)
    }

    
}
