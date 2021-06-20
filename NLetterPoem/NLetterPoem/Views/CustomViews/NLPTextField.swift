import UIKit

class NLPTextField: UITextField {
    //MARK: - enum FieldType
    enum FieldType: String {
        case email = "Email"
        case password = "Password"
        case nickname = "Nickname"
    }
    
    //MARK: - Properties
    var textFieldType: FieldType!
    
    //MARK: - Initializer
    init(type: FieldType) {
        textFieldType = type
        super.init(frame: .zero)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Privates
    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .secondarySystemBackground
        placeholder = textFieldType.rawValue
        
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
