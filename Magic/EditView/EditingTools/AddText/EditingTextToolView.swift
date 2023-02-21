//
//  EditingTextToolView.swift
//  Magic
//
//  Created by Devel on 27.12.2022.
//

import UIKit
import SnapKit

final class EditingTextToolView: UIViewController {
    weak var addTextView: AddTextView? = nil
    
    private var fontName = "" {
        didSet {
            textView.font = UIFont(name: fontName, size: 14)
        }
    }
    private var text = "" {
        didSet {
            textView.text = text
        }
    }
    private var color = UIColor.black {
        didSet {
            textView.textColor = color
        }
    }
    
    private lazy var colorWell: UIColorWell = {
        let colorWell = UIColorWell()
        colorWell.addTarget(self, action: #selector(colorChanged), for: .valueChanged)
        return colorWell
    }()
    
    private lazy var confirmButton: UIButton = {
        var btn = UIButton()
        let btnImg = UIImage(systemName: "checkmark")?
            .withTintColor(.black, renderingMode: .alwaysOriginal)
        btn.setImage(btnImg, for: .normal)
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 20
        btn.addTarget(self, action: #selector(confirmPresssed), for: .touchUpInside)
        return btn
    }()
    
    private lazy var cancelButton: UIButton = {
        var btn = UIButton()
        let btnImg = UIImage(systemName: "xmark")?
            .withTintColor(.black, renderingMode: .alwaysOriginal)
        btn.setImage(btnImg, for: .normal)
        btn.backgroundColor = .white
        btn.layer.cornerRadius = 20
        btn.addTarget(self, action: #selector(cancelPressed), for: .touchUpInside)
        return btn
    }()
    
    
    private lazy var textView: UITextView = {
        let textView = UITextView()
        textView.keyboardAppearance = .dark
        textView.returnKeyType = .default
        textView.indicatorStyle = .white
        textView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        textView.tintColor = .black
        textView.textColor = .white
        textView.text = text
        textView.font = UIFont(name: "Poppins-Regular", size: 14)
        textView.textAlignment = .center
        return textView
    }()
    
    private lazy var vStack: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .center
        stack.axis = .vertical
        stack.spacing = 20
        stack.addArrangedSubview(hStack)
        stack.addArrangedSubview(textView)
        
        return stack
    }()
    
    private lazy var hStack: UIStackView = {
        let stack = UIStackView()
        stack.alignment = .center
        stack.axis = .horizontal
        stack.spacing = 40
        stack.addArrangedSubview(confirmButton)
        stack.addArrangedSubview(colorWell)
        stack.addArrangedSubview(cancelButton)
        return stack
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIApplication.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(_:)), name: UIApplication.keyboardDidHideNotification, object: nil)
        view.backgroundColor = .black
        setupViews()
        setupConstraints()
    }
    
    
    func setup (for addTextView: AddTextView) {
        self.addTextView = addTextView
        self.fontName    = addTextView.fontName
        self.text        = addTextView.text
        self.color       = addTextView.color
    }
    
    @objc
    private func keyboardWillShow (_ notify: Notification) {
        let rect = notify.userInfo?[UIApplication.keyboardFrameEndUserInfoKey] as? CGRect
        let keyboardH = rect?.height ?? 366
        let duration: TimeInterval = notify.userInfo?[UIApplication.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.25
        
        UIView.animate(withDuration: max(duration, 0.25)) { [weak self] in
            self?.vStack.snp.updateConstraints { make in
                make.bottom.lessThanOrEqualToSuperview().offset(-keyboardH).priority(.medium)
            }
        }
    }
    
    @objc
    private func keyboardDidHide (_ notify: Notification) {
        let duration: TimeInterval = notify.userInfo?[UIApplication.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.25
        
        UIView.animate(withDuration: max(duration, 0.25)) { [weak self] in
            self?.vStack.snp.updateConstraints { make in
                make.bottom.lessThanOrEqualToSuperview().offset(0).priority(.medium)
            }
        }
    }
    
    @objc
    private func colorChanged () {
        color = colorWell.selectedColor ?? .black
    }
    
    @objc
    private func cancelPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc
    private func confirmPresssed() {
        let text = textView.text.trimmingCharacters(in: .newlines)
        addTextView?.update(text: text, color: color)
        dismiss(animated: true, completion: nil)
    }
    
    private func setupViews() {
        view.addSubview(vStack)
    }
    
    private func setupConstraints() {
        vStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(0).priority(.low)
            make.bottom.lessThanOrEqualToSuperview().offset(0).priority(.medium)
            make.height.equalTo(textView).offset(60).priority(.medium)
        }
        textView.snp.makeConstraints { make in
            make.height.width.equalTo(200)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.width.height.equalTo(40)
        }
        cancelButton.snp.makeConstraints { make in
            make.width.height.equalTo(confirmButton)
        }
        colorWell.snp.makeConstraints { make in
            make.width.height.equalTo(confirmButton)
        }
    }
}
