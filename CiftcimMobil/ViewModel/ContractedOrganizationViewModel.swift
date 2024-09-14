
import Foundation
import Foundation
import SQLite

class ContractedOrganizationViewModel {
    var organizations: [OrganizationModel] = []
    
    init() {
        fetchOrganizations()
    }
    
    func fetchOrganizations() {
        var fetchedOrganizations: [OrganizationModel] = []
        
        do {
            if let db = DatabaseManager.shared.db {
                let query = DatabaseManager.shared.organizationsTable
                for organization in try db.prepare(query) {
                    let name = organization[DatabaseManager.shared.organizationTitle]
                    let description = organization[DatabaseManager.shared.organizationDescription]
                    let region = organization[DatabaseManager.shared.organizationRegion]
                    let contactPerson = organization[DatabaseManager.shared.organizationContactPerson]
                    let phoneNumber = organization[DatabaseManager.shared.organizationContactPhone]
                    
                    let organizationModel = OrganizationModel(
                        name: name,
                        description: description,
                        region: region,
                        contactPerson: contactPerson,
                        phoneNumber: phoneNumber
                    )
                    
                    fetchedOrganizations.append(organizationModel)
                }
            }
        } catch {
            print("Error fetching organizations from database: \(error)")
        }
        
        self.organizations = fetchedOrganizations
    }
    
    func numberOfOrganizations() -> Int {
        return organizations.count
    }
    
    func getOrganization(at index: Int) -> OrganizationModel {
        return organizations[index]
    }
}
