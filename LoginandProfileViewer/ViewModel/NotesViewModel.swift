import Foundation
class NotesViewModel {
   private var authToken: String
   private(set) var notes: [NoteModel] = []
   init(authToken: String) {
       self.authToken = authToken
   }
   func fetchNotes(completion: @escaping (Result<Void, Error>) -> Void) {
       APIManager.shared.fetchNotes(authToken: authToken) { [weak self] result in
           switch result {
           case .success(let notes):
               self?.notes = [notes]
               completion(.success(()))
           case .failure(let error):
               completion(.failure(error))
           }
       }
   }
   func numberOfNotes() -> Int {
       return notes.count
   }
   func note(at index: Int) -> NoteModel {
       return notes[index]
   }
}
