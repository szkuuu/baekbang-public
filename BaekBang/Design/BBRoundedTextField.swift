//
//  BBRoundedTextField.swift
//  BaekBang
//
//  Created by 차상호 on 2021/06/18.
//
//

import UIKit

class BBRoundedTextField: UITextField {
    // MARK: - Element
    override var rightView: UIView? {
        didSet {
            setNeedsLayout()
        }
    }

    // MARK: - Property
    private let lineWidth: CGFloat = 1.0

    private let radius: CGFloat = 5.0

    private let textPadding: UIEdgeInsets = .init(top: 8, left: 10, bottom: 8, right: 10)

    public var lineColor: UIColor = .bbGray1 {
        didSet {
            setNeedsLayout()
        }
    }
    
    public var isEditable: Bool = true

    // MARK: - Method
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUi()
    }

    public convenience init(with placeholder: String?) {
        self.init()
        self.placeholder = placeholder
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUi()
    }

    private func setupUi() {
        delegate = self
        borderStyle = .none
        font = .systemFont(ofSize: 15.0)
        layer.borderWidth = lineWidth
        layer.borderColor = lineColor.cgColor
        layer.cornerRadius = radius
        setNeedsUpdateConstraints()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderColor = lineColor.cgColor
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        var inset = textPadding
        let _: CGFloat = 5.0
        if let rightView = rightView {
            inset.right += rightView.bounds.size.width + textPadding.right
        }
        return bounds.inset(by: inset)
    }

    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        textRect(forBounds: bounds)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        textRect(forBounds: bounds)
    }

    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var rect = super.rightViewRect(forBounds: bounds)
        rect.origin.x -= textPadding.right
        return rect
    }
}

extension BBRoundedTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        isEditable
    }
}
