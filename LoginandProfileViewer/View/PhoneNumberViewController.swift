import UIKit

final class PhoneNumberViewController: UIViewController {
    private let viewModel = PhoneNumberViewModel()
    
    private let getOTPLabel: UILabel = {
        let label = UILabel()
        label.text = "Get OTP"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .left
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Enter your phone number"
        label.numberOfLines = 2
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.textAlignment = .left
        return label
    }()
    
    private let countryCdTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "+91"
        textField.keyboardType = .numbersAndPunctuation
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let phoneTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Phone Number"
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
        //continueButton.isEnabled = true

    }

    private func setupViews() {
        [getOTPLabel,titleLabel, countryCdTextField,phoneTextField, continueButton, errorLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }

        NSLayoutConstraint.activate([
            
            getOTPLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            getOTPLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            getOTPLabel.heightAnchor.constraint(equalToConstant: 22),

            
            titleLabel.topAnchor.constraint(equalTo: getOTPLabel.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            titleLabel.heightAnchor.constraint(equalToConstant: 72),
            titleLabel.widthAnchor.constraint(equalToConstant: 220),

            countryCdTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            countryCdTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 31),
            countryCdTextField.heightAnchor.constraint(equalToConstant: 36),
            countryCdTextField.widthAnchor.constraint(equalToConstant: 64),

            phoneTextField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            phoneTextField.leadingAnchor.constraint(equalTo: countryCdTextField.trailingAnchor, constant: 12),
            phoneTextField.heightAnchor.constraint(equalToConstant: 36),
            phoneTextField.widthAnchor.constraint(equalToConstant: 147),
            
            
            continueButton.topAnchor.constraint(equalTo: countryCdTextField.bottomAnchor, constant: 19),
            continueButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            continueButton.heightAnchor.constraint(equalToConstant: 40),
            continueButton.widthAnchor.constraint(equalToConstant: 96),

            errorLabel.topAnchor.constraint(equalTo: continueButton.bottomAnchor, constant: 10),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)

        ])
    }
    
    @objc private func continueTapped() {
//        continueButton.isEnabled = true
        if validatePhoneNumber() {
           // continueButton.isEnabled = true
            let number = (self.countryCdTextField.text ?? "") + (self.phoneTextField.text ?? "")
            viewModel.phoneNumber = number.replacingOccurrences(of: " ", with: "")
            viewModel.sendPhoneNumber { [ weak self] result in
                if result {
                    DispatchQueue.main.async {
                        let otpVC = OTPViewController()
                        otpVC.viewModel.phoneNumber = self?.viewModel.phoneNumber ?? ""
                        self?.navigationController?.pushViewController(otpVC, animated: true)
                    }
                }
                else {
                    //self?.continueButton.isEnabled = false
                    self?.showAlert(message: "Failed to send phone numbber")
                }
            }
        }
        else {
            //continueButton.isEnabled = false
            showAlert(message: "Validate country code and Phone number.")
        }
    }
    
    func validatePhoneNumber() -> Bool {
        guard let countrycd = countryCdTextField.text, !countrycd.isEmpty else {
            showAlert(message: "Please enter country code")
            return false
        }
        guard let phoneNo = phoneTextField.text, !phoneNo.isEmpty else {
            showAlert(message: "Please enter mobile number")
            return false
        }
        return phoneNo.trimmingCharacters(in: .whitespaces).count == 10 && countrycd.trimmingCharacters(in: .whitespaces).count == 3
    }
    
    func showAlert(message: String) {
        let alertController = UIAlertController(title: "Alert", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(alertController, animated: true)
    }

}
        
 
