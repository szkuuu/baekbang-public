//
//  BBRequestDetailViewController.swift
//  BaekBang
//
//  Created by 차상호 on 2021/06/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RealmSwift

class BBRequestDetailViewController: UIViewController {
    
    private var disposeBag = DisposeBag()
    
    open var bbUser: BBUser?
    
    open var bbRequest: BBRequest?
    
    private var isContentOk: BehaviorRelay<Bool> = .init(value: false)
    
    private var isDayOk: BehaviorRelay<Bool> = .init(value: false)
    
    private var isTimeOk: BehaviorRelay<Bool> = .init(value: false)
    
    // MARK: - Container
    
    private lazy var scrollContainer: UIScrollView = {
        let scrollView = UIScrollView()
        return scrollView
    }()
    
    // MARK: - Base
    
    private lazy var baseView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    // MARK: - 수리내용 Section
    
    private lazy var subTitleLabel0: UILabel = {
        let label = UILabel()
        label.text = "수리 내용"
        label.font = .boldSystemFont(ofSize: UIFont.systemFontSize)
        return label
    }()
    
    private lazy var requestTextField: UITextView = {
        let textView = UITextView()
        textView.layer.masksToBounds = true
        textView.layer.cornerRadius = 5.0
        textView.layer.borderWidth = 1
        textView.layer.borderColor =  UIColor.bbGray1.cgColor
        textView.textAlignment = .left
        textView.dataDetectorTypes = .all
        textView.textContainerInset = .init(top: 10, left: 5, bottom: 10, right: 5)
        textView.font = .systemFont(ofSize: UIFont.systemFontSize)
        textView.isEditable = true
        return textView
    }()
    
    private lazy var section0: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10.0
        return stackView
    }()
    
    // MARK: - 방문주소 Section
    
    private lazy var subTitleLabel1: UILabel = {
        let label = UILabel()
        label.text = "방문 주소"
        label.font = .boldSystemFont(ofSize: UIFont.systemFontSize)
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
        textField.rightViewMode = .always
        textField.isEditable = false
        return textField
    }()
    
    private lazy var section1: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10.0
        return stackView
    }()
    
    private lazy var editMainAddressCapsule: BBCapsule = {
        let capsule = BBCapsule(withText: "수정하기")
        capsule.isOn = true
        return capsule
    }()
    
    // MARK: - 연락처 Section
    
    private lazy var subTitleLabel2: UILabel = {
        let label = UILabel()
        label.text = "연락처"
        label.font = .boldSystemFont(ofSize: UIFont.systemFontSize)
        return label
    }()
    
    private lazy var phoneNumberTextField: BBRoundedTextField = {
        let textField = BBRoundedTextField()
        textField.rightViewMode = .always
        textField.isEditable = false
        return textField
    }()
    
    private lazy var securePhoneCheck: BBCheck = {
        let check = BBCheck()
        return check
    }()
    
    private lazy var securePhoneLabel: UILabel = {
        let label = UILabel()
        label.text = "안심번호 사용하기"
        return label
    }()
    
    private lazy var section20: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
//        stackView.distribution = .fillProportionally
        stackView.spacing = 6.0
        return stackView
    }()
    
    private lazy var section2: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10.0
        return stackView
    }()
    
    private lazy var editPhoneNumberCapsule: BBCapsule = {
        let capsule = BBCapsule(withText: "수정하기")
        capsule.isOn = true
        return capsule
    }()
    
    // MARK: - 방문 가능 시간대 선택 Section
    
    private lazy var subTitleLabel30: UILabel = {
        let label = UILabel()
        label.text = "방문 가능 시간대 선택"
        label.font = .boldSystemFont(ofSize: UIFont.systemFontSize)
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    private lazy var subTitleLabel31: UILabel = {
        let label = UILabel()
        label.text = "(중복선택 가능)"
        label.font = .boldSystemFont(ofSize: UIFont.systemFontSize - 2.0)
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    private lazy var spacerView30: UIView = {
        let view = UIView()
        view.setContentHuggingPriority(.defaultLow, for: .horizontal)
        return view
    }()
    
    private lazy var section30: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 1.0
        stackView.alignment = .bottom
        return stackView
    }()
    
    private lazy var mondayButton: BBDayButton = {
        let button = BBDayButton(withText: "월")
        return button
    }()
    
    private lazy var tuesdayButton: BBDayButton = {
        let button = BBDayButton(withText: "화")
        return button
    }()
    
    private lazy var wednesdayButton: BBDayButton = {
        let button = BBDayButton(withText: "수")
        return button
    }()
    
    private lazy var thursdayButton: BBDayButton = {
        let button = BBDayButton(withText: "목")
        return button
    }()
    
    private lazy var fridayButton: BBDayButton = {
        let button = BBDayButton(withText: "금")
        return button
    }()
    
    private lazy var saturdayButton: BBDayButton = {
        let button = BBDayButton(withText: "토")
        return button
    }()
    
    private lazy var section31: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10.0
        return stackView
    }()
    
    private lazy var section3: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10.0
        return stackView
    }()
    
    // MARK: - 시간대 Section
    
    private lazy var quarter0Button: BBTImeButton = {
        let button = BBTImeButton(withText: "09:00 ~ 12:00")
        return button
    }()
    
    private lazy var quarter1Button: BBTImeButton = {
        let button = BBTImeButton(withText: "12:00 ~ 15:00")
        return button
    }()
    
    private lazy var hSection0: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10.0
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var quarter2Button: BBTImeButton = {
        let button = BBTImeButton(withText: "15:00 ~ 18:00")
        return button
    }()
    
    private lazy var quarter3Button: BBTImeButton = {
        let button = BBTImeButton(withText: "18:00 ~ 21:00")
        return button
    }()
    
    private lazy var hSection1: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10.0
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var vSection0: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10.0
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    // MARK: - 부가 설명 Section
    
    private lazy var subTitleLabel400: UILabel = {
        let label = UILabel()
        label.text = "* 오후 6시 이후에는 수리방문이 지연되거나"
        label.font = .systemFont(ofSize: 10.0)
        return label
    }()
    
    private lazy var subTitleLabel401: UILabel = {
        let label = UILabel()
        label.text = "추가 요금이 발생할 수 있습니다."
        label.font = .systemFont(ofSize: 10.0)
        return label
    }()
    
    private lazy var section40: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 1.0
        return stackView
    }()
    
    private lazy var subTitleLabel410: UILabel = {
        let label = UILabel()
        label.text = "* 정확한 방문일정은 시설관리업체와 조율을 통해"
        label.font = .systemFont(ofSize: 10.0)
        return label
    }()
    
    private lazy var subTitleLabel411: UILabel = {
        let label = UILabel()
        label.text = "변경될 수 있습니다."
        label.font = .systemFont(ofSize: 10.0)
        return label
    }()
    
    private lazy var section41: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 1.0
        return stackView
    }()
    
    private lazy var section4: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5.0
        return stackView
    }()
    
    // MARK: - Footer Section
    
    private lazy var requestButton: BBRoundedButton = {
        let button = BBRoundedButton(withText: "요청 완료하기")
        return button
    }()
    
    // MARK: - Method
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        arrange()
        layout()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        navigationItem.title = "수리 요청하기"
    }
    
    override func viewDidLayoutSubviews() {
        mainAddressTextField.rightView = editMainAddressCapsule
        phoneNumberTextField.rightView = editPhoneNumberCapsule
        super.viewDidLayoutSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let user = bbUser else { return }
        BBNetworking.User.get(with: user) { result in
            switch result {
            case .success(let json):
                let retPck = json.arrayValue[0]["login"]
                let realm = try! Realm()
                try! realm.write {
                    user.name = retPck["name"].stringValue
                    user.mainAddr = retPck["address1"].stringValue
                    user.subAddr = retPck["address2"].string
                    user.phoneNumber = retPck["phone"].stringValue
                    user.gender = retPck["gender"].stringValue
                    user.buildingCode = retPck["building_code"].stringValue
                }
                self.mainAddressTextField.text = user.mainAddr
                self.subAddressTextField.text = user.subAddr
                self.phoneNumberTextField.text = user.phoneNumber
            case .failure(let err):
                let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
                alert.title = "유저 불러오기 실패"
                alert.message = "에러: \(err.errorDescription)"
                alert.addAction(.init(title: "확인", style: .cancel, handler: { [weak self] _ in
                    let realm = try! Realm()
                    if let user = self?.bbUser {
                        try! realm.write {
                            realm.delete(user)
                        }
                    }
                    let viewController = BBSignUpViewController()
                    viewController.bbUser = BBUser()
                    let navigationController = UINavigationController(rootViewController: viewController)
                    navigationController.modalPresentationStyle = .fullScreen
                    self?.present(navigationController, animated: true, completion: nil)
                }))
                self.present(alert, animated: true)
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rxRegister()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        disposeBag = DisposeBag()
    }
    
    private func arrange() {
        section0.insertArrangedSubview(subTitleLabel0, at: 0)
        section0.insertArrangedSubview(requestTextField, at: 1)
        section1.insertArrangedSubview(subTitleLabel1, at: 0)
        section1.insertArrangedSubview(mainAddressTextField, at: 1)
        section1.insertArrangedSubview(subAddressTextField, at: 2)
        section20.insertArrangedSubview(securePhoneCheck, at: 0)
        section20.insertArrangedSubview(securePhoneLabel, at: 1)
        section20.isHidden = true
        section2.insertArrangedSubview(subTitleLabel2, at: 0)
        section2.insertArrangedSubview(phoneNumberTextField, at: 1)
        section2.insertArrangedSubview(section20, at: 2)
        section30.insertArrangedSubview(subTitleLabel30, at: 0)
        section30.insertArrangedSubview(subTitleLabel31, at: 1)
        section30.insertArrangedSubview(spacerView30, at: 2)
        section31.insertArrangedSubview(mondayButton, at: 0)
        section31.insertArrangedSubview(tuesdayButton, at: 1)
        section31.insertArrangedSubview(wednesdayButton, at: 2)
        section31.insertArrangedSubview(thursdayButton, at: 3)
        section31.insertArrangedSubview(fridayButton, at: 4)
        section31.insertArrangedSubview(saturdayButton, at: 5)
        section3.insertArrangedSubview(section30, at: 0)
        section3.insertArrangedSubview(section31, at: 1)
        hSection0.insertArrangedSubview(quarter0Button, at: 0)
        hSection0.insertArrangedSubview(quarter1Button, at: 1)
        hSection1.insertArrangedSubview(quarter2Button, at: 0)
        hSection1.insertArrangedSubview(quarter3Button, at: 1)
        vSection0.insertArrangedSubview(hSection0, at: 0)
        vSection0.insertArrangedSubview(hSection1, at: 1)
        section40.insertArrangedSubview(subTitleLabel400, at: 0)
        section40.insertArrangedSubview(subTitleLabel401, at: 1)
        section41.insertArrangedSubview(subTitleLabel410, at: 0)
        section41.insertArrangedSubview(subTitleLabel411, at: 1)
        section4.insertArrangedSubview(section40, at: 0)
        section4.insertArrangedSubview(section41, at: 1)
        view.addSubview(scrollContainer)
        scrollContainer.addSubview(baseView)
        baseView.addSubview(section0)
        baseView.addSubview(section1)
        baseView.addSubview(section2)
        baseView.addSubview(section3)
        baseView.addSubview(vSection0)
        baseView.addSubview(section4)
        view.addSubview(requestButton)
    }
    
    private func layout() {
        requestButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin).offset(-70)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leadingMargin).offset(40)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailingMargin).offset(-40)
            $0.height.equalTo(42)
        }
        scrollContainer.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(50)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(40)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).offset(-40)
            $0.bottom.equalTo(requestButton.snp.top).offset(-50)
        }
        baseView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
            $0.width.equalTo(scrollContainer)
        }
        section0.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
        }
        requestTextField.snp.makeConstraints {
            $0.height.equalTo(154)
        }
        section1.snp.makeConstraints {
            $0.top.equalTo(section0.snp.bottom).offset(50)
            $0.leading.trailing.equalToSuperview()
        }
        mainAddressTextField.snp.makeConstraints {
            $0.height.equalTo(38)
        }
        subAddressTextField.snp.makeConstraints {
            $0.height.equalTo(38)
        }
        section2.snp.makeConstraints {
            $0.top.equalTo(section1.snp.bottom).offset(50)
            $0.leading.trailing.equalToSuperview()
        }
        section20.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(1)
        }
        securePhoneCheck.snp.makeConstraints {
            $0.width.height.equalTo(17.28)
        }
        section3.snp.makeConstraints {
            $0.top.equalTo(section2.snp.bottom).offset(50)
            $0.leading.trailing.equalToSuperview()
        }
        section31.snp.makeConstraints {
            $0.height.equalTo(38)
        }
        vSection0.snp.makeConstraints {
            $0.top.equalTo(section3.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
        }
        hSection0.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        hSection1.snp.makeConstraints {
            $0.height.equalTo(44)
        }
        section4.snp.makeConstraints {
            $0.top.equalTo(vSection0.snp.bottom).offset(10)
            $0.leading.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func rxRegister() {
        editMainAddressCapsule.rx
            .controlEvent(.touchUpInside)
            .bind(onNext: { _ in
                self.editBbUser()
            }).disposed(by: disposeBag)
        editPhoneNumberCapsule.rx
            .controlEvent(.touchUpInside)
            .bind(onNext: { _ in
                self.editBbUser()
            }).disposed(by: disposeBag)
        securePhoneCheck.rx
            .controlEvent(.touchUpInside)
            .bind(onNext: { _ in
                self.securePhoneCheck.isOn.toggle()
            }).disposed(by: disposeBag)
        mondayButton.rx
            .controlEvent(.touchUpInside)
            .bind(onNext: { _ in
                self.onButtonToggle(self.mondayButton)
            }).disposed(by: disposeBag)
        tuesdayButton.rx
            .controlEvent(.touchUpInside)
            .bind(onNext: { _ in
                self.onButtonToggle(self.tuesdayButton)
            }).disposed(by: disposeBag)
        wednesdayButton.rx
            .controlEvent(.touchUpInside)
            .bind(onNext: { _ in
                self.onButtonToggle(self.wednesdayButton)
            }).disposed(by: disposeBag)
        thursdayButton.rx
            .controlEvent(.touchUpInside)
            .bind(onNext: { _ in
                self.onButtonToggle(self.thursdayButton)
            }).disposed(by: disposeBag)
        fridayButton.rx
            .controlEvent(.touchUpInside)
            .bind(onNext: { _ in
                self.onButtonToggle(self.fridayButton)
            }).disposed(by: disposeBag)
        saturdayButton.rx
            .controlEvent(.touchUpInside)
            .bind(onNext: { _ in
                self.onButtonToggle(self.saturdayButton)
            }).disposed(by: disposeBag)
        quarter0Button.rx
            .controlEvent(.touchUpInside)
            .bind(onNext: { _ in
                self.onButtonToggle(self.quarter0Button)
            }).disposed(by: disposeBag)
        quarter1Button.rx
            .controlEvent(.touchUpInside)
            .bind(onNext: { _ in
                self.onButtonToggle(self.quarter1Button)
            }).disposed(by: disposeBag)
        quarter2Button.rx
            .controlEvent(.touchUpInside)
            .bind(onNext: { _ in
                self.onButtonToggle(self.quarter2Button)
            }).disposed(by: disposeBag)
        quarter3Button.rx
            .controlEvent(.touchUpInside)
            .bind(onNext: { _ in
                self.onButtonToggle(self.quarter3Button)
            }).disposed(by: disposeBag)
        requestTextField.rx
            .text
            .orEmpty
            .map { $0.count > 0 }
            .bind(onNext: {
                self.isContentOk.accept($0)
            }).disposed(by: disposeBag)
        _ = Observable.combineLatest(isContentOk, isDayOk, isTimeOk)
            .bind(onNext: {
                self.requestButton.condition = $0 && $1 && $2 ? .activate : .deactivate
            }).disposed(by: disposeBag)
        requestButton.rx
            .controlEvent(.touchUpInside)
            .bind(onNext: { _ in
                guard self.requestButton.condition == .activate else { return }
                self.requestButton.condition = .loading
                let visitDay = [self.mondayButton.isOn, self.tuesdayButton.isOn, self.wednesdayButton.isOn, self.thursdayButton.isOn, self.fridayButton.isOn, self.saturdayButton.isOn]
                let visitTime = [self.quarter0Button.isOn, self.quarter1Button.isOn, self.quarter2Button.isOn, self.quarter3Button.isOn]
                self.bbRequest?.user = self.bbUser
                self.bbRequest?.content = self.requestTextField.text
                self.bbRequest?.mainAddr = self.bbUser?.mainAddr ?? ""
                self.bbRequest?.subAddr = self.bbUser?.subAddr ?? ""
                self.bbRequest?.buildingCode = self.bbUser?.buildingCode ?? ""
                self.bbRequest?.phoneNumber = self.bbUser?.phoneNumber ?? ""
                self.bbRequest?.isSecure = self.securePhoneCheck.isOn
                self.bbRequest?.visitDay = visitDay.enumerated()
                    .filter { $0.element }
                    .map { $0.offset + 1 }
                    .reduce("") { "\($0)" + "\($1)" }
                self.bbRequest?.visitTime = visitTime.enumerated()
                    .filter { $0.element }
                    .map { $0.offset + 1 }
                    .reduce("") { "\($0)" + "\($1)" }
                guard let request = self.bbRequest else { return }
                BBNetworking.Request.send(with: request) { result in
                    switch(result) {
                    case .success(_):
                        self.requestButton.condition = .activate
                        let viewController = BBRequestCompleteViewController()
                        self.navigationController?.pushViewController(viewController, animated: true)
                    case .failure(let err):
                        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
                        alert.title = "수리요청 실패"
                        alert.message = "에러: \(err.localizedDescription)"
                        alert.addAction(.init(title: "확인", style: .cancel, handler: { _ in
                            self.requestButton.condition = .activate
                        }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }).disposed(by: disposeBag)
    }
    
    private func editBbUser() {
        let viewController = BBMyPageEditViewController(mode: .fromRequest)
        viewController.bbUser = bbUser
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalPresentationStyle = .fullScreen
        self.present(navigationController, animated: true)
    }
    
    private func onButtonToggle(_ dayButton: BBDayButton) {
        dayButton.isOn.toggle()
        isDayOk.accept(mondayButton.isOn || tuesdayButton.isOn || wednesdayButton.isOn || thursdayButton.isOn || fridayButton.isOn || saturdayButton.isOn)
    }
    
    private func onButtonToggle(_ timeButton: BBTImeButton) {
        timeButton.isOn.toggle()
        isTimeOk.accept(quarter0Button.isOn || quarter1Button.isOn || quarter2Button.isOn || quarter3Button.isOn)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

