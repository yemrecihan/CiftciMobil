import Foundation
import FirebaseAuth
import FirebaseFirestore

class LoginViewModel {
    
    var verificationID: String?
    private let db = Firestore.firestore()
    
    // Telefon numarası doğrulama işlemi
    func sendVerificationCode(phoneNumber: String, completion: @escaping (Result<Void, Error>) -> Void) {
        var formattedPhoneNumber = formatPhoneNumber(phoneNumber)
        
       
        
        // Firestore'da kullanıcıyı kontrol et
        checkIfUserExists(phoneNumber: formattedPhoneNumber) { [weak self] exists in
            if exists {
                // Kullanıcı mevcutsa doğrulama kodu gönder
                PhoneAuthProvider.provider().verifyPhoneNumber(formattedPhoneNumber, uiDelegate: nil) { verificationID, error in
                    if let error = error {
                        completion(.failure(error))
                        return
                    }
                    self?.verificationID = verificationID
                    UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                    completion(.success(()))
                }
            } else {
                // Kullanıcı yoksa hata mesajı göster
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Telefon numaranıza ait kayıt bulunamadı, giriş yapmadan önce kayıt olmanız gerekmektedir."])))
            }
        }
    }
    
    // Kullanıcının Firestore'da mevcut olup olmadığını kontrol et
    private func checkIfUserExists(phoneNumber: String, completion: @escaping (Bool) -> Void) {
        db.collection("users").whereField("phoneNumber", isEqualTo: phoneNumber).getDocuments { snapshot, error in
            if let error = error {
                print("Error checking user: \(error)")
                completion(false)
                return
            }
            
            if let snapshot = snapshot, !snapshot.isEmpty {
                // Kullanıcı bulundu
                completion(true)
            } else {
                // Kullanıcı bulunamadı
                completion(false)
            }
        }
    }
    // Telefon numarasını formatla
      private func formatPhoneNumber(_ phoneNumber: String) -> String {
          if phoneNumber.hasPrefix("+") {
                      return phoneNumber
                  } else {
                      return "+90" + phoneNumber // Türkiye için varsayılan ülke kodu
                  }
              }
}

