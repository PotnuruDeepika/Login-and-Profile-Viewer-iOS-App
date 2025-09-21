import Foundation
class OTPViewModel {
   var phoneNumber: String = ""
   var otpCode: String = ""
   func verifyOTP(completion: @escaping (Result<String, Error>) -> Void) {
       APIManager.shared.verifyOTP(number: phoneNumber, otp: otpCode) { result in
           switch result {
           case .success(let authToken):
               completion(.success(authToken))
           case .failure(let error):
               completion(.failure(error))
           }
       }
   }
}
