import Foundation
class APIManager {
   static let shared = APIManager()
   private init() {}
   private let baseURL = "https://app.aisle.co/V1"
   func sendPhoneNumber(_ number: String, completion: @escaping (Result<String, Error>) -> Void) {
       guard let url = URL(string: "\(baseURL)/users/phone_number_login") else { return }
       var request = URLRequest(url: url)
       request.httpMethod = "POST"
       let numb = number.suffix(10)
       let parameters = ["number": numb]
       request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
       request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//       URLSession.shared.dataTask(with: request) { data, _, error in
//           if let error = error {
//               completion(.failure(error))
//           } else {
//               completion(.success(number))
//           }
//       }.resume()
       URLSession.shared.dataTask(with: request) { data, _, error in
          if let error = error {
              completion(.failure(error))
          } else {
              if let data = data, let raw = String(data: data, encoding: .utf8) {
                  print("📱 Phone Login Raw:", raw)
              }
              completion(.success(number))
          }
       }.resume()
   }
    
//   func verifyOTP(number: String, otp: String, completion: @escaping (Result<String, Error>) -> Void) {
//       guard let url = URL(string: "\(baseURL)/users/verify_otp") else { return }
//       var request = URLRequest(url: url)
//       request.httpMethod = "POST"
//       let parameters = ["number": number, "otp": otp]
//       request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
//       request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//       URLSession.shared.dataTask(with: request) { data, response, error in
//           if let error = error {
//               print("Network: Error fetching data: \(error.localizedDescription)")
//               completion(.failure(error))
//           }
//           guard let httpRes = response as? HTTPURLResponse else {
//               print("Inval")
//               completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Inavlid response"])))
//               return
//           }
//           print("Http code: \(httpRes.statusCode)")
//           guard let data = data else {
//               print("No dta")
//               completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data"])))
//               return
//           }
//           if let rs = String(data: data, encoding: .utf8) {
//               print("ras str: \(rs)")
//           }
//           do {
//               if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
//                  let token = json["token"] as? String {
//                   print("Token found")
//                    completion(.success(token))
//           } else {
//                   print("Tpjen no founf")
//               completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "token miss"])))
//
//               }
//           } catch {
//               print("JSON \(error.localizedDescription)")
//               completion(.failure(error))
//           }
//       }.resume()
//   }
//    func sendPhoneNumber(_ number: String, completion: @escaping (Result<String, Error>) -> Void) {
//       guard let url = URL(string: "\(baseURL)/users/phone_number_login") else { return }
//       var request = URLRequest(url: url)
//       request.httpMethod = "POST"
//        let parameters = ["number": number.suffix(10)]
//       request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
//       request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//       print("📤 Sending phone number: \(number)")
//       URLSession.shared.dataTask(with: request) { data, response, error in
//           if let error = error {
//               print("❌ Network error: \(error)")
//               completion(.failure(error))
//               return
//           }
//           if let httpResponse = response as? HTTPURLResponse {
//               print("🌐 Status Code: \(httpResponse.statusCode)")
//           }
//           if let data = data, let raw = String(data: data, encoding: .utf8) {
//               print("📦 Raw Response: \(raw)")
//               if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
//                   let status = json["status"] as? Bool
//                   print("✅ Status in JSON: \(status ?? false)")
//                   if status == true {
//                       completion(.success(number))
//                   } else {
//                       let error = NSError(domain: "", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Phone login failed"])
//                       completion(.failure(error))
//                   }
//               } else {
//                   print("❌ JSON parsing failed")
//                   completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Invalid JSON"])))
//               }
//           }
//       }.resume()
//    }
    
    func verifyOTP(number: String, otp: String, completion: @escaping (Result<String, Error>) -> Void) {
       guard let url = URL(string: "\(baseURL)/users/verify_otp") else { return }
       var request = URLRequest(url: url)
       request.httpMethod = "POST"
       let parameters = ["number": number, "otp": otp]
       request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
       request.setValue("application/json", forHTTPHeaderField: "Content-Type")
       URLSession.shared.dataTask(with: request) { data, response, error in
           if let error = error {
               completion(.failure(error))
               return
           }
           guard let data = data else {
               completion(.failure(NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "No data"])))
               return
           }
           if let rawString = String(data: data, encoding: .utf8) {
               print("📨 Raw Response:", rawString)
           }
           do {
               if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                   if let token = json["token"] as? String {
                       completion(.success(token))
                   } else if let message = json["message"] as? String {
                       let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: message])
                       completion(.failure(error))
                   } else {
                       let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey: "Token not found"])
                       completion(.failure(error))
                   }
               }
           } catch {
               completion(.failure(error))
           }
       }.resume()
    }
    
   func fetchNotes(authToken: String, completion: @escaping (Result<NoteModel, Error>) -> Void) {
       guard let url = URL(string: "\(baseURL)/users/test_profile_list") else { return }
       var request = URLRequest(url: url)
       request.httpMethod = "GET"
       request.setValue(authToken, forHTTPHeaderField: "Authorization")
       URLSession.shared.dataTask(with: request) { data, _, error in
           if let error = error {
               completion(.failure(error))
           } else if let data = data {
               do {
                   let model = try JSONDecoder().decode(NoteModel.self, from: data)
                   completion(.success(model))
               } catch {
                   completion(.failure(error))
               }
           }
       }.resume()
   }
}
