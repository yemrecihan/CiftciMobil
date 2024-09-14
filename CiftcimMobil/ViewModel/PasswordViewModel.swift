import Foundation
import FirebaseAuth
import FirebaseFirestore

class PasswordViewModel {
    
    var verificationID: String? {
        return UserDefaults.standard.string(forKey: "authVerificationID")
    }
    private let db = Firestore.firestore()
    
    func verifyCode(verificationCode: String, phoneNumber: String,isFromSignUp: Bool, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let verificationID = verificationID else {
            completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Doğrulama ID'si bulunamadı."])))
            return
        }
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificationID, verificationCode: verificationCode)
        
        Auth.auth().signIn(with: credential) { [weak self] authResult, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Kullanıcı doğrulandı
                     if isFromSignUp {
                         // Signup sayfasından geldiyse, kullanıcıyı kaydet
                         self?.registerUserInFirestore(phoneNumber: phoneNumber, completion: completion)
                     } else {
                         // LoginSecond sayfasından geldiyse, kullanıcıyı kaydetmeden sadece giriş yap
                         completion(.success(()))
                     }
                 }
    }
    
    func registerUserInFirestore(phoneNumber: String, completion: @escaping (Result<Void, Error>) -> Void) {
         let formattedPhoneNumber = phoneNumber.hasPrefix("+") ? phoneNumber : "+90" + phoneNumber
         
         let db = Firestore.firestore()
         db.collection("users").addDocument(data: [
             "phoneNumber": formattedPhoneNumber
         ]) { error in
             if let error = error {
                 print("Kullanıcı kaydı sırasında hata: \(error)")
                 completion(.failure(error))
             } else {
                 print("Kullanıcı başarıyla kaydedildi.")
                 completion(.success(()))
             }
         }
     }
}

