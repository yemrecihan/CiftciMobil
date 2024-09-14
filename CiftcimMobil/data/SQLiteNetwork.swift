
import Foundation
import SQLite

class DatabaseManager {
    static let shared = DatabaseManager()
    internal var db: Connection?
    
    // Campaigns Table
    internal let campaignsTable = Table("campaigns")
    internal let campaignId = Expression<Int64>("id")
    internal let campaignClass = Expression<String>("class")
    internal let campaignTitle = Expression<String>("title")
    internal let campaignDescription = Expression<String>("description")
    
    // Organizations Table
    internal let organizationsTable = Table("organizations")
    internal let organizationId = Expression<Int64>("id")
    internal let organizationCampaignId = Expression<Int64>("campaignId")
    internal let organizationTitle = Expression<String>("title")
    internal let organizationDescription = Expression<String>("description")
    internal let organizationRegion = Expression<String>("region")
    internal let organizationContactPerson = Expression<String>("contactPerson")
    internal let organizationContactPhone = Expression<String>("contactPhone")
    
    private init() {
        do {
            let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
            db = try Connection("\(path)/db.sqlite3")
            createTables()
        } catch {
            print("Error connecting to the database: \(error)")
        }
    }
    
    private func createTables() {
        do {
            // Create Campaigns Table
            try db?.run(campaignsTable.create(ifNotExists: true) { table in
                table.column(campaignId, primaryKey: true)
                table.column(campaignClass)
                table.column(campaignTitle)
                table.column(campaignDescription)
            })
            
            // Create Organizations Table
            try db?.run(organizationsTable.create(ifNotExists: true) { table in
                table.column(organizationId, primaryKey: true)
                table.column(organizationCampaignId)
                table.column(organizationTitle)
                table.column(organizationDescription)
                table.column(organizationRegion)
                table.column(organizationContactPerson)
                table.column(organizationContactPhone)
                table.foreignKey(organizationCampaignId, references: campaignsTable, campaignId)
            })
        } catch {
            print("Error creating tables: \(error)")
        }
    }
    
    // Insert, fetch, and other database operations can be added here...
    func addCampaign(campaignclass: String, title: String, description: String) {
        let insert = campaignsTable.insert(
            campaignClass <- campaignclass,
            campaignTitle <- title,
            campaignDescription <- description
        )
        try? db?.run(insert)
    }
    func addOrganization(to campaignId: Int64, title: String, description: String, region: String, contactPerson: String, contactPhone: String) {
        let insert = organizationsTable.insert(
            organizationCampaignId <- campaignId,
            organizationTitle <- title,
            organizationDescription <- description,
            organizationRegion <- region,
            organizationContactPerson <- contactPerson,
            organizationContactPhone <- contactPhone
        )
        try? db?.run(insert)
    }
    // Check if a campaign exists by title
        func isCampaignExists(title: String) -> Bool {
            do {
                let query = campaignsTable.filter(campaignTitle == title)
                let count = try db?.scalar(query.count) ?? 0
                return count > 0
            } catch {
                print("Error checking if campaign exists: \(error)")
                return false
            }
        }
    // Check if an organization exists by title
       func isOrganizationExists(name: String) -> Bool {
           do {
               let query = organizationsTable.filter(organizationTitle == name)
               let count = try db?.scalar(query.count) ?? 0
               return count > 0
           } catch {
               print("Error checking if organization exists: \(error)")
               return false
           }
       }
    // Anlaşmalı kuruluşu veritabanından silmek için ( let success = CampaignService.shared.deleteOrganization(name: "....") kullanarak appdelegate 'te silme işlemini gerçekleştirebiliriz. )
    func deleteOrganization(name: String) -> Bool {
        do {
            let organization = organizationsTable.filter(organizationTitle == name)
            try db?.run(organization.delete())
            print("Organization \(name) başarıyla silindi.")
            return true
        } catch {
            print("Error deleting organization: \(error)")
            return false
        }
    }
        

}
