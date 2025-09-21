import Foundation
final class PhoneNumberViewModel {
   var phoneNumber: String = ""
   func sendPhoneNumber(completion: @escaping (Bool) -> Void) {
       APIManager.shared.sendPhoneNumber(phoneNumber) { result in
           DispatchQueue.main.async {
               switch result {
               case .success:
                   completion(true)
               case .failure(let error):
                   print("Phone number send failed:", error)
                   completion(false)
               }
           }
       }
   }
}
