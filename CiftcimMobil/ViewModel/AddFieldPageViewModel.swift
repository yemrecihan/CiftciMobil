import Foundation
import MapKit

class AddFieldPageViewModel {
    
    var coordinate: ((CLLocationCoordinate2D) -> Void)?
    var didUpdateCities: (() -> Void)?
    
    private(set) var cities: [CityModel] = [] {
        didSet {
            didUpdateCities?()
        }
    }
    
    private let cityNetwork = CityNetwork()

    init() {
        loadCities()
    }

    // Şehir verilerini yükler ve 'didUpdateCities' çağrısını tetikler
    func loadCities() {
        cityNetwork.fetchCities { [weak self] cities in
            guard let self = self, let cities = cities else {
                print("Şehirler yüklenemedi veya hata oluştu.")
                return
            }
            self.cities = cities
            print("Şehirler başarıyla yüklendi.")
        }
    }

    func updateLocation(for city: String, district: String, neighborhood: String) {
        let locationString = "\(neighborhood), \(district), \(city)"
        
        geocodeAddressString(locationString) { [weak self] placemark in
            guard let coordinate = placemark?.location?.coordinate else { return }
            self?.coordinate?(coordinate)
        }
    }

    private func geocodeAddressString(_ address: String, completion: @escaping (CLPlacemark?) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(address) { (placemarks, error) in
            guard let placemarks = placemarks, let placemark = placemarks.first, error == nil else {
                completion(nil)
                return
            }
            completion(placemark)
        }
    }

    // Şehir isimlerini döndürür
    func getCityNames() -> [String] {
        return cities.map { $0.name ?? "Unknown" }
    }

    // Seçili şehir için ilçe isimlerini döndürür
    func getCountyNames(forCity city: String) -> [String] {
        guard let selectedCity = cities.first(where: { $0.name == city }) else {
            print("İlçe bulunamadı: Şehir: \(city)")
            return []
        }
        return selectedCity.counties.map { $0.name ?? "Unknown" }
    }

    // Seçili şehir ve ilçe için mahalle isimlerini döndürür
    func getNeighborhoodNames(forCity city: String, county: String) -> [String] {
        guard let selectedCity = cities.first(where: { $0.name == city }) else {
            print("Şehir bulunamadı: \(city)")
            return []
        }
        guard let selectedCounty = selectedCity.counties.first(where: { $0.name == county }) else {
            print("İlçe bulunamadı: \(county) - Şehir: \(city)")
            return []
        }
        
        // Tüm mahalleleri toplamak için District'ler içindeki neighborhoods'a erişiyoruz
        var neighborhoods: [String] = []
        for district in selectedCounty.districts {
            neighborhoods.append(contentsOf: district.neighborhoods.map { $0.name ?? "Unknown" })
        }
        
        print("Mahalleler: \(neighborhoods) - Şehir: \(city), İlçe: \(county)")
        return neighborhoods
    }

    func clearSelections() {
        // Seçimleri temizle ve PickerView bileşenlerini yenile
    }
}





    


