import UIKit
class NotesViewController: UIViewController {
   private let tableView = UITableView()
   private var viewModel: NotesViewModel
   init(authToken: String) {
       self.viewModel = NotesViewModel(authToken: authToken)
       super.init(nibName: nil, bundle: nil)
   }
   required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }
   override func viewDidLoad() {
       super.viewDidLoad()
       title = "Notes"
       view.backgroundColor = .white
       setupTableView()
       fetchNotes()
   }
   private func setupTableView() {
       view.addSubview(tableView)
       tableView.translatesAutoresizingMaskIntoConstraints = false
       NSLayoutConstraint.activate([
           tableView.topAnchor.constraint(equalTo: view.topAnchor),
           tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
           tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
           tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
       ])
       tableView.dataSource = self
       tableView.register(NoteCell.self, forCellReuseIdentifier: NoteCell.identifier)
   }
   private func fetchNotes() {
       viewModel.fetchNotes { [weak self] result in
           DispatchQueue.main.async {
               switch result {
               case .success():
                   self?.tableView.reloadData()
               case .failure(let error):
                   print("Failed to fetch notes:", error)
               }
           }
       }
   }
}
extension NotesViewController: UITableViewDataSource {
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       return viewModel.numberOfNotes()
   }
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let note = viewModel.note(at: indexPath.row)
       guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteCell.identifier, for: indexPath) as? NoteCell else {
           return UITableViewCell()
       }
       cell.configure(with: note.name)
       return cell
   }
}
