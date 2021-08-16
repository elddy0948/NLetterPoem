import UIKit

class NLPTextField: UITextField {
    
    //MARK: - enum FieldType
    enum FieldType: String {
        case email = "Email"
        case password = "영어와 숫자를 포함한 최소 8자리 이상"
        case repeatPassword = "Repeat Password"
        case nickname = "Nickname"
        
        var keyBoardType: UIKeyboardType {
            switch self {
            case .email:
                return .emailAddress
            default:
                return .default
            }
        }
        
        var isSecureTextEntry: Bool {
            switch self {
            case .password:
                return true
            case .repeatPassword:
                return true
            default:
                return false
            }
        }
    }
    
    //MARK: - Initializer
    init(type: FieldType) {
        super.init(frame: .zero)
        configure(with: type)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Privates
    private func configure(with fieldType: FieldType) {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .secondarySystemBackground
        placeholder = fieldType.rawValue
        keyboardType = fieldType.keyBoardType
        isSecureTextEntry = fieldType.isSecureTextEntry
        
        layer.cornerRadius = 16
        layer.masksToBounds = true
        layer.borderWidth = 3
        layer.borderColor = UIColor.systemGray.cgColor
        
        autocorrectionType = .no
        autocapitalizationType = .none
        
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        leftViewMode = .always
    }
}
