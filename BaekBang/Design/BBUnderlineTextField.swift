//
//  BBUnderlineTextField.swift
//  BaekBang
//
//  Created by 차상호 on 2021/06/18.
//
//

import UIKit

class BBUnderlineTextField: UITextField {

    // MARK: - Element
    private var line: CAShapeLayer?

    override var rightView: UIView? {
        didSet {
            setNeedsLayout()
        }
    }

    // MARK: - Property
    private let lineWidth: CGFloat = 1.0

    private let textPadding: UIEdgeInsets = .init(top: 0, left: 0, bottom: 10.5, right: 5)

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
        line = {
            let shapeLayer = CAShapeLayer()
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.strokeColor = lineColor.cgColor
            shapeLayer.lineWidth = lineWidth
            return shapeLayer
        }()
        if let line = line {
            layer.addSublayer(line)
        }
        setNeedsUpdateConstraints()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let lineLayer = line else { return }
        let path: UIBezierPath = {
            let path = UIBezierPath()
            path.move(to: .init(x: .zero, y: frame.height - lineWidth))
            path.addLine(to: .init(x: frame.width, y: frame.height - lineWidth))
            return path
        }()
        lineLayer.path = path.cgPath
        lineLayer.strokeColor = lineColor.cgColor
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        var inset = textPadding
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
        rect.origin.y -= (textPadding.bottom / 2)
        return rect
    }
}

extension BBUnderlineTextField: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        isEditable
    }
}
