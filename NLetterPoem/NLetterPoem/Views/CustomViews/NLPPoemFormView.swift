import UIKit

class NLPPoemFormView: UIView {
    
    //MARK: - Views
    private(set) var letterLabel: UILabel!
    private(set) var inputTextField: UITextField!
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        configureLetterLabel()
        configureInputTextField()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureLetterLabel() {
        letterLabel = UILabel()
        addSubview(letterLabel)
        
        letterLabel.translatesAutoresizingMaskIntoConstraints = false
        letterLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        letterLabel.text = " "
        letterLabel.textColor = .label
        
        NSLayoutConstraint.activate([
            letterLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            letterLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            letterLabel.widthAnchor.constraint(equalToConstant: 40),
            letterLabel.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    private func configureInputTextField() {
        inputTextField = UITextField()
        addSubview(inputTextField)
        
        inputTextField.translatesAutoresizingMaskIntoConstraints = false
        inputTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 4, height: 0))
        inputTextField.leftViewMode = .always
        inputTextField.backgroundColor = .secondarySystemBackground
        inputTextField.autocorrectionType = .no
        inputTextField.autocapitalizationType = .none
        inputTextField.layer.cornerRadius = 8
        inputTextField.layer.borderWidth = 2
        inputTextField.layer.borderColor = UIColor.systemGray.cgColor
        
        inputTextField.delegate = self

        let padding: CGFloat = 8
        NSLayoutConstraint.activate([
            inputTextField.centerYAnchor.constraint(equalTo: centerYAnchor),
            inputTextField.leadingAnchor.constraint(equalTo: letterLabel.trailingAnchor, constant: padding),
            inputTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding),
            inputTextField.heightAnchor.constraint(equalTo: letterLabel.heightAnchor)
        ])
    }
    
    func configureLetter(with letter: String, line: String?) {
        letterLabel.text = letter
        inputTextField.text = line ?? ""
    }
    
    func fetchLine() -> String? {
        guard let line = inputTextField.text else { return nil }
        return line
    }
}

extension NLPPoemFormView: UITextFieldDelegate {
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        return range.location < 15
    }
}
