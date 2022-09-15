//
//  BBPersonalInputViewController.swift
//  BaekBang
//
//  Created by 차상호 on 2021/06/22.
//
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BBPersonalInputViewController: UIViewController {

    open var bbUser: BBUser?
    
    private var disposeBag = DisposeBag()
    
    private var isNameOk: BehaviorRelay<Bool> = .init(value: false)
    
    private var isAddressOk: BehaviorRelay<Bool> = .init(value: false)
    
    private var isGenderOk: BehaviorRelay<Bool> = .init(value: false)
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "개인정보"
        label.font = .systemFont(ofSize: 25.0, weight: .bold)
        return label
    }()

    private lazy var subTitleLabel0: UILabel = {
        let label = UILabel()
        label.text = "성명"
        label.font = .systemFont(ofSize: 14.0, weight: .semibold)
        return label
    }()

    private lazy var nameTextField: BBUnderlineTextField = {
        let textField = BBUnderlineTextField(with: "이름을 입력해주세요")
        return textField
    }()

    private lazy var subTitleLabel1: UILabel = {
        let label = UILabel()
        label.text = "주소지"
        label.font = .systemFont(ofSize: 14.0, weight: .semibold)
        return label
    }()

    private lazy var mainAddressTextField: BBUnderlineTextField = {
        let textField = BBUnderlineTextField()
        textField.rightViewMode = .always
        (textField.textInputView as? UITextView)?.isEditable = false
        return textField
    }()

    private lazy var searchAddressButton: BBCapsule = {
        let capsule = BBCapsule(withText: "주소검색")
        capsule.isOn = true
        return capsule
    }()

    private lazy var subAddressTextField: BBUnderlineTextField = {
        let textField = BBUnderlineTextField(with: "상세 주소를 입력해주세요")
        return textField
    }()

    private lazy var subTitleLabel2: UILabel = {
        let label = UILabel()
        label.text = "성별"
        label.font = .systemFont(ofSize: 14.0, weight: .semibold)
        return label
    }()

    private lazy var maleButton: BBGenderButton = {
        let button = BBGenderButton(with: .init(image: UIImage(named: "IconMale"), text: "남성"))
        return button
    }()

    private lazy var femaleButton: BBGenderButton = {
        let button = BBGenderButton(with: .init(image: UIImage(named: "IconFemale"), text: "여성"))
        return button
    }()

    private lazy var genderSection: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8.0
        stackView.distribution = .fillEqually
        return stackView
    }()

    private lazy var nextButton: BBRoundedButton = {
        let button = BBRoundedButton(withText: "회원가입 완료")
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        arrange()
        layout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rxRegister()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disposeBag = DisposeBag()
    }

    override func viewDidLayoutSubviews() {
        mainAddressTextField.rightView = searchAddressButton
        super.viewDidLayoutSubviews()
    }

    private func arrange() {
        view.addSubview(titleLabel)
        view.addSubview(subTitleLabel0)
        view.addSubview(nameTextField)
        view.addSubview(subTitleLabel1)
        view.addSubview(mainAddressTextField)
        view.addSubview(subAddressTextField)
        view.addSubview(subTitleLabel2)
        genderSection.insertArrangedSubview(maleButton, at: 0)
        genderSection.insertArrangedSubview(femaleButton, at: 1)
        view.addSubview(genderSection)
        view.addSubview(nextButton)
    }

    private func layout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(40)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leadingMargin).offset(40)
        }
        subTitleLabel0.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(45)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leadingMargin).offset(40)
        }
        nameTextField.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel0.snp.bottom).offset(25)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leadingMargin).offset(40)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailingMargin).offset(-40)
            $0.height.equalTo(32)
        }
        subTitleLabel1.snp.makeConstraints {
            $0.top.equalTo(nameTextField.snp.bottom).offset(40)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leadingMargin).offset(40)
        }
        mainAddressTextField.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel1.snp.bottom).offset(25)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leadingMargin).offset(40)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailingMargin).offset(-40)
            $0.height.equalTo(32)
        }
        subAddressTextField.snp.makeConstraints {
            $0.top.equalTo(mainAddressTextField.snp.bottom).offset(5)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leadingMargin).offset(40)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailingMargin).offset(-40)
            $0.height.equalTo(32)
        }
        subTitleLabel2.snp.makeConstraints {
            $0.top.equalTo(subAddressTextField.snp.bottom).offset(40)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leadingMargin).offset(40)
        }
        genderSection.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel2.snp.bottom).offset(25)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leadingMargin).offset(40)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailingMargin).offset(-40)
        }
        maleButton.snp.makeConstraints {
            $0.height.equalTo(view.bounds.height * 0.1)
        }
        femaleButton.snp.makeConstraints {
            $0.height.equalTo(view.bounds.height * 0.1)
        }
        nextButton.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leadingMargin).offset(40)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailingMargin).offset(-40)
            if view.bounds.height < 700 {
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin).offset(-20)
            } else {
                $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin).offset(-70)
            }
            $0.height.equalTo(42)
        }
    }
    
    private func rxRegister() {
        _ = nameTextField.rx
            .text
            .orEmpty
            .map { !$0.isEmpty }
            .bind(onNext: {
                self.isNameOk.accept($0)
            }).disposed(by: disposeBag)
        _ = mainAddressTextField.rx
            .text
            .orEmpty
            .map { !$0.isEmpty }
            .bind(onNext: {
                self.isAddressOk.accept($0)
            }).disposed(by: disposeBag)
        _ = searchAddressButton.rx
            .controlEvent(.touchUpInside)
            .bind(onNext: { _ in
                self.bbUser?.buildingCode = ""
                self.mainAddressTextField.text = ""
                let rootViewController = BBAddressViewController()
                rootViewController.delegate = self
                let navigationController = UINavigationController(rootViewController: rootViewController)
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true, completion: nil)
            }).disposed(by: disposeBag)
        _ = maleButton.rx
            .controlEvent(.touchUpInside)
            .bind(onNext: { _ in
                self.maleButton.isOn = true
                self.femaleButton.isOn = !self.maleButton.isOn
                self.isGenderOk.accept(true)
            }).disposed(by: disposeBag)
        _ = femaleButton.rx
            .controlEvent(.touchUpInside)
            .bind(onNext: { _ in
                self.femaleButton.isOn = true
                self.maleButton.isOn = !self.femaleButton.isOn
                self.isGenderOk.accept(true)
            }).disposed(by: disposeBag)
        _ = Observable.combineLatest(isNameOk, isAddressOk, isGenderOk)
            .subscribe(onNext: {
                self.nextButton.condition = $0 && $1 && $2 ? .activate : .deactivate
            }).disposed(by: disposeBag)
        _ = nextButton.rx
            .controlEvent(.touchUpInside)
            .bind(onNext: { _ in
                guard self.nextButton.condition == .activate else { return }
                let rewind: BBUser? = self.bbUser
                self.bbUser?.name = self.nameTextField.text!
                self.bbUser?.gender = self.maleButton.isOn ? "1" : self.femaleButton.isOn ? "2" : "0"
                self.bbUser?.mainAddr = self.mainAddressTextField.text!
                self.bbUser?.subAddr = self.subAddressTextField.text
                BBNetworking.User.join(with: self.bbUser!) { result in
                    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
                    switch result {
                    case .success(let json):
                        self.bbUser?.token = json.arrayValue[0]["login"]["token"].stringValue
                        alert.title = "회원가입 완료"
                        alert.message = "완료되었습니다."
                        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                            let rootViewController = BBHomeViewController()
                            rootViewController.bbUser = self.bbUser
                            let navigationController = UINavigationController(rootViewController: rootViewController)
                            navigationController.modalPresentationStyle = .fullScreen
                            self.present(navigationController, animated: true, completion: nil)
                        }))
                        self.present(alert, animated: true, completion: nil)
                    case .failure(let err):
                        alert.title = "회원가입 실패"
                        alert.message = "에러: \(err.localizedDescription)"
                        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
                            self.bbUser = rewind
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }).disposed(by: disposeBag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

extension BBPersonalInputViewController: BBAddressViewControllerDelegate {
    func bbAddressViewController(_ bbAddressViewController: BBAddressViewController, selectedData: BBJuso) {
        mainAddressTextField.text = selectedData.roadAddr
        self.bbUser?.buildingCode = selectedData.bdMgtSn
        bbAddressViewController.dismiss(animated: true, completion: nil)
    }
}
