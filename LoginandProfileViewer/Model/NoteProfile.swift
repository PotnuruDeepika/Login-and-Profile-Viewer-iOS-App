struct NotesResponse: Codable {
   let invites: InviteSection
}
struct InviteSection: Codable {
   let profiles: [NoteProfile]
}
struct NoteProfile: Codable {
   let id: Int
   let name: String
   let avatar: String
   let location: String?
   let status: String?
}
