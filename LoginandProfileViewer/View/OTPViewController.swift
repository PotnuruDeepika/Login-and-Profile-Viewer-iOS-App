import UIKit

final class OTPViewController: UIViewController {
    
    let viewModel = OTPViewModel()
    var timer: Timer?
    var secondsLeft = 59
    private let phoneNoTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Phone number"
        textField.keyboardType = .numbersAndPunctuation
        textField.textAlignment = .center
        textField.font = UIFont.boldSystemFont(ofSize: 18)
        textField.borderStyle = .none
        textField.isUserInteractionEnabled = false
        return textField
    }()
    
    private let editButton: UIButton = {
        let button = UIButton(type: .system)
        let icon = UIImage(named: "edit_Icon")?.withRenderingMode(.alwaysOriginal)
        button.setImage(icon, for: .normal)
        button.addTarget(self, action: #selector(editBtnTapped), for: .touchUpInside)

        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter The OTP"
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textAlignment = .left
        return label
    }()
    
    private let otpTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "OTP"
        textField.keyboardType = .numberPad
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let continueButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Continue", for: .normal)
        button.backgroundColor = UIColor(red: 0.976, green: 0.796, blue: 0.063, alpha: 1)
        button.tintColor = .black
        button.layer.cornerRadius = 20
        button.addTarget(self, action: #selector(continueTapped), for: .touchUpInside)
        return button
    }()
    
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textAlignment = .center
        return label
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.font = .systemFont(ofSize: 14)
        label.textAlignment = .center
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViews()
        phoneNoTextField.text = viewModel.phoneNumber
    }
    
    private func setupViews() {
        [phoneNoTextField, editButton,titleLabel, otpTextField, continueButton,timerLabel, errorLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            
            phoneNoTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            phoneNoTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            phoneNoTextField.heightAnchor.constraint(equalToConstant: 22),
            phoneNoTextField.widthAnchor.constraint(equalToConstant: 152),
            
            
            editButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 84),
            editButton.leadingAnchor.constraint(equalTo: phoneNoTextField.trailingAnchor, constant: 7),
            editButton.heightAnchor.constraint(equalToConstant: 14),
            editButton.widthAnchor.constraint(equalToConstant: 14),
            
            titleLabel.topAnchor.constraint(equalTo: phoneNoTextField.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            titleLabel.heightAnchor.constraint(equalToConstant: 72),
            titleLabel.widthAnchor.constraint(equalToConstant: 144),
            
            otpTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            otpTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 31),
            otpTextField.heightAnchor.constraint(equalToConstant: 36),
            otpTextField.widthAnchor.constraint(equalToConstant: 64),
            
            
            continueButton.topAnchor.constraint(equalTo: otpTextField.bottomAnchor, constant: 19),
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            continueButton.heightAnchor.constraint(equalToConstant: 40),
            continueButton.widthAnchor.constraint(equalToConstant: 96),
            
            timerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 260),
            timerLabel.leadingAnchor.constraint(equalTo: continueButton.trailingAnchor, constant: 12),
            timerLabel.heightAnchor.constraint(equalToConstant: 17),
            timerLabel.widthAnchor.constraint(equalToConstant: 42),
            
            errorLabel.topAnchor.constraint(equalTo: continueButton.bottomAnchor, constant: 10),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
            
        ])
        startTimer()
        
    }
    func startTimer() {
        updateLabel()
        timer = Timer.scheduledTimer(timeInterval: 1.0,
                                     target: self,
                                     selector: #selector(updateTimer),
                                     userInfo: nil,
                                     repeats: true)
    }
    @objc func updateTimer() {
        secondsLeft -= 1
        updateLabel()
        if secondsLeft <= 0 {
            timer?.invalidate()
            timer = nil
            timerLabel.text = "00:00"
            continueButton.isEnabled = false
        }
    }
    func updateLabel() {
        let min = secondsLeft / 60
        let sec = secondsLeft % 60
        timerLabel.text = String(format: "%02d:%02d", min,sec)
    }
    
    @objc private func continueTapped() {
        viewModel.otpCode = otpTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        
        viewModel.verifyOTP { [weak self] result in
            DispatchQueue.main.async {
                switch result  {
                case .success(let authToken):
                    let notesVC = NotesViewController(authToken: authToken)
                    self?.navigationController?.pushViewController(notesVC, animated: true)
                case .failure(let error):
                    print("Error: \(error)")
                    //showAlert(message: error)
                }
            }
        }

    }
    @objc private func editBtnTapped() {
        phoneNoTextField.isUserInteractionEnabled = true
        phoneNoTextField.borderStyle = .roundedRect
        let phoneNo = self.phoneNoTextField.text ?? ""
        viewModel.phoneNumber = phoneNo
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true)
    }

    
}



 
