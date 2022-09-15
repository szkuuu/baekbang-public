//
//  BBImagePick.swift
//  BaekBang
//
//  Created by 차상호 on 2021/06/21.
//
//

import UIKit
import SnapKit

class BBImagePick: UIView {

    // MARK: - Element
    private var image: UIImageView?

    private(set) var plusButton: BBPlusButton?

    // MARK: - Property
    public var source: UIImage? = nil {
        didSet {
            setNeedsLayout()
        }
    }

    // MARK: - Method
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUi()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUi()
    }

    private func setupUi() {
        image = {
            let view = UIImageView()
            view.layer.cornerRadius = 5.0
            view.backgroundColor = .white
            view.layer.masksToBounds = true
            return view
        }()
        plusButton = {
            let button = BBPlusButton()
            return button
        }()
        if let image = image {
            addSubview(image)
        }
        if let plusButton = plusButton {
            addSubview(plusButton)
        }
        setNeedsUpdateConstraints()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let imageView = image else { return }
        imageView.image = source
    }

    override func updateConstraints() {
        if let imageView = image {
            imageView.snp.makeConstraints {
                $0.top.leading.trailing.bottom.equalToSuperview()
            }
//            NSLayoutConstraint.activate([
//                imageView.topAnchor.constraint(equalTo: topAnchor),
//                imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
//                imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
//                imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
//            ])
        }
        if let plusButtonView = plusButton {
            plusButtonView.snp.makeConstraints {
                $0.trailing.equalToSuperview().offset(-10)
                $0.bottom.equalToSuperview().offset(-10)
                $0.width.height.equalTo(30)
            }
//            NSLayoutConstraint.activate([
//                plusButtonView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
//                plusButtonView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
//                plusButtonView.widthAnchor.constraint(equalToConstant: 30),
//                plusButtonView.heightAnchor.constraint(equalToConstant: 30)
//            ])
        }
        super.updateConstraints()
    }
}
