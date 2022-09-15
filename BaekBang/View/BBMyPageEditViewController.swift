//
//  BBMyPageEditViewController.swift
//  BaekBang
//
//  Created by 차상호 on 2021/06/22.
//

import UIKit
import RxSwift
import RxCocoa
import RealmSwift

public enum BBMyPageEditViewControllerMode: Int {
    case fromMyPage
    case fromRequest
}

class BBMyPageEditViewController: UIViewController {
    
    open weak var bbUser: BBUser?
    
    open var mode: BBMyPageEditViewControllerMode = .fromMyPage
    
    private var isSend: BehaviorRelay<Bool> = .init(value: false)
    
    private var isNameOk: BehaviorRelay<Bool> = .init(value: false)
    
    private var isPhoneOk: BehaviorRelay<Bool> = .init(value: false)
    
    private var isPhoneNumberChanged: BehaviorRelay<Bool> = .init(value: false)
    
    private var isVerifyOk: BehaviorRelay<Bool> = .init(value: false)
    
    private var isAddressOk: BehaviorRelay<Bool> = .init(value: false)
    
    private var verifyCode: String? = nil
    
    private var disposeBag = DisposeBag()

    private lazy var subTitleLabel0: UILabel = {
        let label = UILabel()
        label.text = "성명"
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    
    private lazy var nameTextField: BBRoundedTextField = {
        let textField = BBRoundedTextField(with: "이름을 입력해주세요")
        return textField
    }()
    
    private lazy var section0: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 24.0
        return stackView
    }()
    
    private lazy var subTitleLabel1: UILabel = {
        let label = UILabel()
        label.text = "연락처"
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    
    private lazy var phoneNumberTextField: BBRoundedTextField = {
        let textField = BBRoundedTextField(with: "전화번호를 입력해주세요")
        textField.rightViewMode = .always
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private lazy var verifyCodeTextField: BBRoundedTextField = {
        let textField = BBRoundedTextField(with: "인증번호를 입력해주세요")
        textField.keyboardType = .numberPad
        return textField
    }()
    
    private lazy var section1: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10.0
        return stackView
    }()
    
    private lazy var verifyButton: BBCapsule = {
        let button = BBCapsule(withText: "인증하기")
        return button
    }()
    
    private lazy var subTitleLabel2: UILabel = {
        let label = UILabel()
        label.text = "방문 주소"
        label.font = .boldSystemFont(ofSize: 14)
        return label
    }()
    
    private lazy var mainAddressTextField: BBRoundedTextField = {
        let textField = BBRoundedTextField()
        textField.rightViewMode = .always
        textField.isEditable = false
        return textField
    }()
    
    private lazy var subAddressTextField: BBRoundedTextField = {
        let textField = BBRoundedTextField()
        return textField
    }()
    
    private lazy var section2: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10.0
        return stackView
    }()
    
    private lazy var searchAddressButton: BBCapsule = {
        let button = BBCapsule(withText: "주소검색")
        button.isOn = true
        return button
    }()
    
    private lazy var completeButton: BBRoundedButton = {
        let button = BBRoundedButton(withText: "수정완료")
        return button
    }()
    
    public convenience init(mode: BBMyPageEditViewControllerMode = .fromMyPage) {
        self.init()
        self.mode = mode
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        arrange()
        layout()
        if mode == .fromRequest {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(doDismiss))
        }
        guard let user = bbUser else { return }
        nameTextField.text = user.name
        phoneNumberTextField.text = user.phoneNumber
        mainAddressTextField.text = user.mainAddr
        subAddressTextField.text = user.subAddr
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        navigationItem.title = "회원정보 수정"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rxRegister()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disposeBag = DisposeBag()
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        phoneNumberTextField.rightView = verifyButton
        mainAddressTextField.rightView = searchAddressButton
        super.viewDidLayoutSubviews()
    }
    
    private func arrange() {
        section0.insertArrangedSubview(subTitleLabel0, at: 0)
        section0.insertArrangedSubview(nameTextField, at: 1)
        section1.insertArrangedSubview(subTitleLabel1, at: 0)
        section1.insertArrangedSubview(phoneNumberTextField, at: 1)
        section1.insertArrangedSubview(verifyCodeTextField, at: 2)
        section2.insertArrangedSubview(subTitleLabel2, at: 0)
        section2.insertArrangedSubview(mainAddressTextField, at: 1)
        section2.insertArrangedSubview(subAddressTextField, at: 2)
        view.addSubview(section0)
        view.addSubview(section1)
        view.addSubview(section2)
        view.addSubview(completeButton)
    }
    
    private func layout() {
        section0.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(61)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leadingMargin).offset(40)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailingMargin).offset(-40)
        }
        nameTextField.snp.makeConstraints {
            $0.height.equalTo(38)
        }
        section1.snp.makeConstraints {
            $0.top.equalTo(section0.snp.bottom).offset(50)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leadingMargin).offset(40)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailingMargin).offset(-40)
        }
        phoneNumberTextField.snp.makeConstraints {
            $0.height.equalTo(38)
        }
        verifyCodeTextField.snp.makeConstraints {
            $0.height.equalTo(38)
        }
        section2.snp.makeConstraints {
            $0.top.equalTo(section1.snp.bottom).offset(50)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leadingMargin).offset(40)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailingMargin).offset(-40)
        }
        mainAddressTextField.snp.makeConstraints {
            $0.height.equalTo(38)
        }
        subAddressTextField.snp.makeConstraints {
            $0.height.equalTo(38)
        }
        completeButton.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leadingMargin).offset(40)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailingMargin).offset(-40)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin).offset(-70)
            $0.height.equalTo(42)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func rxRegister() {
        _ = nameTextField.rx
            .text
            .orEmpty
            .map { !$0.isEmpty }
            .bind(to: isNameOk).disposed(by: disposeBag)
        _ = phoneNumberTextField.rx
            .text
            .orEmpty
            .distinctUntilChanged()
            .map { $0.count == 11 }
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {
                self.isPhoneOk.accept($0)
                self.verifyButton.isOn = $0
            }).disposed(by: disposeBag)
        _ = phoneNumberTextField.rx
            .text
            .orEmpty
            .distinctUntilChanged()
            .map { $0 == self.bbUser?.phoneNumber }
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {
                self.isPhoneNumberChanged.accept($0)
            }).disposed(by: disposeBag)
        _ = verifyCodeTextField.rx
            .text
            .orEmpty
            .distinctUntilChanged()
            .map { $0.count > 0 }
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: {
                self.isVerifyOk.accept($0)
            }).disposed(by: disposeBag)
        _ = mainAddressTextField.rx
            .text
            .orEmpty
            .map { !$0.isEmpty }
            .bind(onNext: {
                self.isAddressOk.accept($0)
            }).disposed(by: disposeBag)
        verifyButton.rx
            .controlEvent(.touchUpInside)
            .subscribe(onNext: { _ in
                BBNetworking.User.verify(withPhone: self.phoneNumberTextField.text!) {
                    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
                    switch $0 {
                    case .success(let json):
                        self.verifyCode = json.arrayValue[0]["login"]["certi"].stringValue
                        self.isSend.accept(true)
                        alert.title = "전송 완료"
                        alert.message = "인증번호를 전송하였습니다."
                        alert.addAction(.init(title: "확인", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    case .failure(let err):
                        self.isSend.accept(false)
                        alert.title = "전송 실패"
                        alert.message = "\(err.errorDescription ?? "에러")"
                        alert.addAction(.init(title: "확인", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }).disposed(by: disposeBag)
        _ = searchAddressButton.rx
            .controlEvent(.touchUpInside)
            .bind(onNext: { _ in
                let realm = try! Realm()
                try! realm.write {
                    guard let user = self.bbUser else { return }
                    user.buildingCode = ""
                }
                self.mainAddressTextField.text = ""
                let rootViewController = BBAddressViewController()
                rootViewController.delegate = self
                let navigationController = UINavigationController(rootViewController: rootViewController)
                navigationController.modalPresentationStyle = .fullScreen
                self.present(navigationController, animated: true, completion: nil)
            }).disposed(by: disposeBag)
        _ = Observable.combineLatest(isNameOk, isPhoneOk, isVerifyOk, isPhoneNumberChanged, isAddressOk)
            .bind(onNext: {
                self.completeButton.condition = $0 && $1 && ($2 || $3) && $4 ? .activate : .deactivate
            }).disposed(by: disposeBag)
        _ = completeButton.rx
            .controlEvent(.touchUpInside)
            .bind(onNext: { _ in
                guard self.completeButton.condition == .activate,
                      let user = self.bbUser else { return }
                let isValidated =  self.verifyCode == self.verifyCodeTextField.text
                guard (isValidated || self.isPhoneNumberChanged.value) else {
                    let alert = UIAlertController(title: "처리 실패", message: "인증 번호를 다시 확인해주세요", preferredStyle: .alert)
                    alert.addAction(.init(title: "확인", style: .default))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                let rewind = user
                let realm = try! Realm()
                try! realm.write {
                    user.name = self.nameTextField.text!
                    user.phoneNumber = self.phoneNumberTextField.text!
                    user.mainAddr = self.mainAddressTextField.text!
                    user.subAddr = self.subAddressTextField.text
                }
                BBNetworking.User.update(with: user) { result in
                    let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
                    switch result {
                    case .success(_):
                        alert.title = "수정 완료"
                        alert.message = "회원정보를 수정하였습니다"
                        alert.addAction(.init(title: "확인", style: .default, handler: { _ in
                            switch self.mode {
                            case .fromMyPage:
                                self.navigationController?.popViewController(animated: true)
                            case .fromRequest:
                                self.doDismiss()
                            }
                        }))
                        self.present(alert, animated: true, completion: nil)
                    case .failure(let err):
                        alert.title = "수정 실패"
                        alert.message = "에러: \(err.localizedDescription)"
                        alert.addAction(.init(title: "확인", style: .cancel))
                        self.present(alert, animated: true, completion: {
                            try! realm.write {
                                user.name = rewind.name
                                user.phoneNumber = rewind.phoneNumber
                                user.mainAddr = rewind.mainAddr
                                user.subAddr = rewind.subAddr
                            }
                        })
                    }
                }
            }).disposed(by: disposeBag)
    }
    
    @objc
    private func doDismiss() {
        dismiss(animated: true)
    }
    
    @objc
    private func keyboardWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo as NSDictionary?
        let keyboardFrame = userInfo?.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as? NSValue
        let keyboardRect = keyboardFrame?.cgRectValue
        guard let keyboardRect = keyboardRect else { return }
        if mainAddressTextField.isEditing == true {
            keyboardAnimate(keyboardRect: keyboardRect)
        } else if subAddressTextField.isEditing == true {
            keyboardAnimate(keyboardRect: keyboardRect)
        }
    }
    
    @objc
    private func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    private func keyboardAnimate(keyboardRect keyRect: CGRect) {
        view.frame.origin.y = 0
        view.frame.origin.y -= keyRect.height
    }
}

extension BBMyPageEditViewController: BBAddressViewControllerDelegate {
    func bbAddressViewController(_ bbAddressViewController: BBAddressViewController, selectedData: BBJuso) {
        mainAddressTextField.text = selectedData.roadAddr
        let realm = try! Realm()
        try! realm.write {
            guard let user = self.bbUser else { return }
            user.buildingCode = selectedData.bdMgtSn
        }
        bbAddressViewController.dismiss(animated: true, completion: nil)
    }
}
