
import Foundation
import CoreData

struct CityModel: Codable {
    let name: String?
    let counties: [CountyModel] // districts özelliğini ekleyin
}

struct DistrictModel: Codable {
    let name: String?
    let neighborhoods: [NeighborhoodModel] // neighborhoods özelliğini ekleyin
}

struct NeighborhoodModel: Codable {
    let name: String?
    let code: String?
}
struct CountyModel: Codable {
    let name: String?
    let districts: [DistrictModel]
}

