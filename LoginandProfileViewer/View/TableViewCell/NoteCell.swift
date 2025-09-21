import UIKit
class NoteCell: UITableViewCell {
   static let identifier = "NoteCell"
   private let nameLabel: UILabel = {
       let label = UILabel()
       label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
       label.numberOfLines = 1
       label.textColor = .black
       return label
   }()
   override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
       super.init(style: style, reuseIdentifier: reuseIdentifier)
       setupViews()
   }
   required init?(coder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
   }
   private func setupViews() {
       contentView.addSubview(nameLabel)
       nameLabel.translatesAutoresizingMaskIntoConstraints = false
       NSLayoutConstraint.activate([
           nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
           nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
           nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
       ])
   }
   func configure(with name: String) {
       nameLabel.text = name
   }
}
