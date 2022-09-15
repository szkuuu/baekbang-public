//
//  BBGenderButton.swift
//  BaekBang
//
//  Created by 차상호 on 2021/06/18.
//
//

import UIKit
import SnapKit

struct BBGender {
    let image: UIImage?
    let text: String?
}

class BBGenderButton: UIControl {

    // MARK: - Element
    private var container: UIStackView?

    private var genderImage: UIImageView?

    private var genderLabel: UILabel?

    // MARK: - Property
    private var color: UIColor = .bbGray1

    public var genderInfo: BBGender? = nil {
        didSet {
            setNeedsLayout()
        }
    }

    public var isOn: Bool = false {
        didSet {
            color = isOn ? .bbAccent : .bbGray1
            setNeedsLayout()
        }
    }

    // MARK: - Method
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupUi()
    }

    public convenience init(with genderInfo: BBGender) {
        self.init()
        self.genderInfo = genderInfo
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUi()
    }

    private func setupUi() {
        layer.cornerRadius = 5.0
        layer.borderWidth = 1.0
        layer.borderColor = color.cgColor
        genderImage = {
            let imageView = UIImageView()
            imageView.image = genderInfo?.image
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        genderLabel = {
            let label = UILabel()
            label.text = genderInfo?.text
            label.font = .systemFont(ofSize: 14.0, weight: .semibold)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        container = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.alignment = .center
            stackView.spacing = 3.0
            stackView.isUserInteractionEnabled = false
            return stackView
        }()
        if let container = container {
            if let genderImage = genderImage {
                container.insertArrangedSubview(genderImage, at: 0)
            }
            if let genderLabel = genderLabel {
                container.insertArrangedSubview(genderLabel, at: 1)
            }
            addSubview(container)
        }
        setNeedsUpdateConstraints()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        guard let genderImageView = genderImage,
              let genderLabelView = genderLabel else { return }
        genderImageView.image = genderInfo?.image?.withRenderingMode(.alwaysTemplate)
        genderImageView.tintColor = color
        genderLabelView.text = genderInfo?.text
        genderLabelView.textColor = color
        layer.borderColor = color.cgColor
    }

    override func updateConstraints() {
        if let containerView = container {
            containerView.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
        }
        super.updateConstraints()
    }
}
