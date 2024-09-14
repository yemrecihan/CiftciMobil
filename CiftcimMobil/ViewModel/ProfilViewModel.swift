
import Foundation
class ProfilViewModel {

    // Kullanıcı telefon numarasını almak için bir fonksiyon
    func getUserPhoneNumber() -> String? {
        return UserDefaults.standard.string(forKey: "userPhoneNumber")
    }
    
    // Kullanıcı oturumunu kapatma işlemi
    func logout() {
        // Kullanıcı telefon numarasını sil
        UserDefaults.standard.removeObject(forKey: "userPhoneNumber")
        
        // Diğer gerekli temizleme işlemlerini yap (örn: token temizleme, session kapatma vs.)
    }
}
