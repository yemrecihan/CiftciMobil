import Foundation
import CoreData

class CityNetwork {
    
    func fetchCities(completion: @escaping([CityModel]?) -> Void) {
        print("Veri çekme işlemi başladı")
        guard let url = URL(string:"https://raw.githubusercontent.com/hsndmr/turkiye-city-county-district-neighborhood/main/data.json") else {
            print("Geçersiz URL")
            completion(nil)
            return
        }
        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            print("Veri çekme işlemi tamamlandı")
            guard let data = data, error == nil else {
                print("Veri çekme hatası: \(error?.localizedDescription ?? "Bilinmeyen hata")")
                completion(nil)
                return
            }
            do {
                let cities = try JSONDecoder().decode([CityModel].self, from: data)
                print("Veriler Başarıyla İndirildi: \(cities.count) şehir")
                DispatchQueue.main.async {
                    self?.saveCitiesToCoreData(cities)
                }
                completion(cities)
            } catch {
                print("Error decoding JSON: \(error)")
                completion(nil)
            }
        }.resume()
    }
    
    private func saveCitiesToCoreData(_ cities: [CityModel]) {
        let context = CoreDataStack.shared.context
           
           // Önceki verileri silme
           DispatchQueue.main.async {
               self.deleteAllData(entity: "NeighborhoodEntity")
               self.deleteAllData(entity: "DistrictEntity")
               self.deleteAllData(entity: "CountyEntity")
               self.deleteAllData(entity: "CityEntity")
               print("Tüm eski veriler silindi.")
           }

           // İlk olarak, veritabanında zaten veri olup olmadığını kontrol edin
           let fetchRequest: NSFetchRequest<CityEntity> = CityEntity.fetchRequest()
           
           do {
               let cityCount = try context.count(for: fetchRequest)
               if cityCount > 0 {
                   print("Silme işlemi başarısız, veritabanında hala \(cityCount) şehir kaydı var.")
                   return // Veritabanında veri varsa, kaydetme işlemini sonlandır
               } else {
                   print("Tüm eski veriler silindi ve veritabanı temiz.")
               }
           } catch {
               print("Veri kontrolü sırasında hata oluştu: \(error)")
               return
           }
           
           // Verileri kaydetme
           for city in cities {
               guard let cityName = city.name else {
                   print("Hatalı veri: Şehir adı eksik.")
                   continue
               }
               
               let cityEntity = CityEntity(context: context)
               cityEntity.name = cityName
               
               for county in city.counties {
                   guard let countyName = county.name else {
                       print("Hatalı veri: İlçe adı eksik.")
                       continue
                   }
                   
                   let countyEntity = CountyEntity(context: context)
                   countyEntity.name = countyName
                   countyEntity.city = cityEntity // İlçe ile şehri ilişkilendir
                   
                   for district in county.districts {
                       guard let districtName = district.name else {
                           print("Hatalı veri: İlçe adı eksik.")
                           continue
                       }
                       
                       let districtEntity = DistrictEntity(context: context)
                       districtEntity.name = districtName
                       districtEntity.county = countyEntity // İlçe ile ilçeyi ilişkilendir
                       
                       for neighborhood in district.neighborhoods {
                           guard let neighborhoodName = neighborhood.name, let neighborhoodCode = neighborhood.code else {
                               print("Hatalı veri: Mahalle adı veya kodu eksik.")
                               continue
                           }
                           
                           let neighborhoodEntity = NeighborhoodEntity(context: context)
                           neighborhoodEntity.name = neighborhoodName
                           neighborhoodEntity.code = neighborhoodCode
                           neighborhoodEntity.district = districtEntity // Mahalle ile ilçeyi ilişkilendir
                       }
                   }
               }
           }
           
           do {
               try context.save()
               print("Veriler Core Data'ya kaydedildi")
           } catch {
               print("Failed to save cities: \(error)")
           }
    }
    
    func fetchSavedCities() {
        let context = CoreDataStack.shared.context
           let request: NSFetchRequest<CityEntity> = CityEntity.fetchRequest()
           
           do {
               let savedCities = try context.fetch(request)
               print("Kaydedilen Şehir Sayısı: \(savedCities.count)")
               for city in savedCities {
                   print("Şehir: \(city.name ?? "Bilinmiyor")")
                   
                   if let counties = city.counties as? Set<CountyEntity> {
                       print("  İlçe Sayısı: \(counties.count)")
                       for county in counties {
                           print("  İlçe: \(county.name ?? "Bilinmiyor")")
                           
                           // Burada doğrudan mahalleleri listeleyelim
                           if let neighborhoods = county.districts?.compactMap({ $0 as? DistrictEntity }).flatMap({ $0.neighborhoods as? Set<NeighborhoodEntity> }).flatMap({ $0 }) {
                               print("    Mahalle Sayısı: \(neighborhoods.count)")
                               for neighborhood in neighborhoods {
                                   print("      Mahalle: \(neighborhood.name ?? "Bilinmiyor")")
                               }
                           } else {
                               print("    Mahalle bilgisi bulunamadı.")
                           }
                       }
                   } else {
                       print("  İlçe bilgisi bulunamadı.")
                   }
               }
           } catch {
               print("Verileri çekerken hata oluştu: \(error)")
           }
    }
    
    private func deleteAllData(entity: String) {
        let context = CoreDataStack.shared.context
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.execute(deleteRequest)
            try context.save()
            print("\(entity) verileri silindi.")
        } catch let error as NSError {
            print("Verileri silerken hata oluştu: \(error), \(error.userInfo)")
        }
    }
}

