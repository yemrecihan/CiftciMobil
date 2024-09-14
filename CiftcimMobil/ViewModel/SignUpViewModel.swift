import Foundation
import FirebaseAuth
import FirebaseFirestore

class SignUpViewModel {
    
    var verificationID: String?
    
    // Telefon numarasına doğrulama kodu gönderme
    func sendVerificationCode(phoneNumber: String, completion: @escaping (Result<Void, Error>) -> Void) {
        var formattedPhoneNumber = phoneNumber
        if !formattedPhoneNumber.hasPrefix("+") {
                    formattedPhoneNumber = "+90" + phoneNumber // Türkiye için varsayılan ülke kodu
                }
        print("Doğrulama kodu gönderiliyor... Telefon numarası: \(formattedPhoneNumber)")
        
        // Firestore'da kullanıcıyı kontrol et
        checkIfUserExists(phoneNumber: formattedPhoneNumber) { [weak self] exists in
            if exists {
                // Kullanıcı zaten mevcutsa hata mesajı göster
                completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Bu kullanıcı zaten mevcut, giriş yap sayfasından giriş yapabilirsiniz."])))
            } else {
                
                print("Doğrulama kodu gönderiliyor... Telefon numarası: \(formattedPhoneNumber)")
                
                // Kullanıcı yoksa doğrulama kodu gönder
                PhoneAuthProvider.provider().verifyPhoneNumber(formattedPhoneNumber, uiDelegate: nil) { verificationID, error in
                    if let error = error {
                        let nsError = error as NSError
                                print("Doğrulama kodu gönderme hatası: \(nsError.localizedDescription)")
                                print("Hata kodu: \(nsError.code), Hata bilgisi: \(nsError.userInfo)")
                                completion(.failure(error))
                                return
                    }
                    print("Doğrulama kodu başarıyla gönderildi.")
                    self?.verificationID = verificationID
                    UserDefaults.standard.set(verificationID, forKey: "authVerificationID")
                    print("Doğrulama kodu başarıyla gönderildi. Verification ID: \(verificationID ?? "Bilinmiyor")")
                    completion(.success(()))
                }
            }
        }
    }
    
    // Kullanıcının Firestore'da mevcut olup olmadığını kontrol et
    private func checkIfUserExists(phoneNumber: String, completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
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
    
    // Kullanıcıyı Firestore'a kaydet
       func registerUserInFirestore(phoneNumber: String) {
           let formattedPhoneNumber = phoneNumber.hasPrefix("+") ? phoneNumber : "+90" + phoneNumber // Firestore'a kaydederken doğru formatı kullan
           
           let db = Firestore.firestore()
           db.collection("users").addDocument(data: [
               "phoneNumber": formattedPhoneNumber
           ]) { error in
               if let error = error {
                   print("Kullanıcı kaydı sırasında hata: \(error)")
               } else {
                   print("Kullanıcı başarıyla kaydedildi.")
               }
           }
       }
}

