//
//  BBRequestImagePickViewController.swift
//  BaekBang
//
//  Created by 차상호 on 2021/06/22.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class BBRequestImagePickViewController: UIViewController {
    
    private var isPhotoOk: BehaviorRelay<Bool> = .init(value: false)
    
    private var disposeBag = DisposeBag()
    
    private var focusedImagePick: BBImagePick?
    
    open var bbUser: BBUser?

    open var bbRequest: BBRequest = BBRequest()
    
    private lazy var subTitleLabel0: UILabel = {
        let label = UILabel()
        label.text = "사진 촬영"
        label.font = .boldSystemFont(ofSize: 13)
        return label
    }()
    
    private lazy var grayCover: UIView = {
        let view = UIView()
        view.backgroundColor = .bbGray2
        return view
    }()
    
    private lazy var imagePick0: BBImagePick = {
        let imagePick = BBImagePick()
        return imagePick
    }()
    
    private lazy var imagePick1: BBImagePick = {
        let imagePick = BBImagePick()
        return imagePick
    }()
    
    private lazy var imagePick2: BBImagePick = {
        let imagePick = BBImagePick()
        return imagePick
    }()
    
    private lazy var imagePick3: BBImagePick = {
        let imagePick = BBImagePick()
        return imagePick
    }()
    
    private lazy var hSection0: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10.0
        return stackView
    }()
    
    private lazy var hSection1: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10.0
        return stackView
    }()
    
    private lazy var vSection0: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10.0
        return stackView
    }()
    
    private lazy var commentLabel: UILabel = {
        let label = UILabel()
        label.text = "여러 각도에서 1장 이상의 사진을 촬영해주세요"
        label.font = .systemFont(ofSize: 13.0)
        label.textColor = .bbBlack2
        return label
    }()
    
    private lazy var nextButton: BBRoundedButton = {
        let button = BBRoundedButton(withText: "다음으로")
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        arrange()
        layout()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(doDismiss))
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.view.backgroundColor = .clear
        navigationItem.title = "수리 요청하기"
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
        hSection0.insertArrangedSubview(imagePick0, at: 0)
        hSection0.insertArrangedSubview(imagePick1, at: 1)
        hSection1.insertArrangedSubview(imagePick2, at: 0)
        hSection1.insertArrangedSubview(imagePick3, at: 1)
        vSection0.insertArrangedSubview(hSection0, at: 0)
        vSection0.insertArrangedSubview(hSection1, at: 1)
        view.addSubview(subTitleLabel0)
        view.addSubview(grayCover)
        view.addSubview(vSection0)
        view.addSubview(commentLabel)
        view.addSubview(nextButton)
    }
    
    private func layout() {
        subTitleLabel0.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(50)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leadingMargin).offset(40)
        }
        grayCover.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel0.snp.bottom).offset(10)
            $0.leading.trailing.equalToSuperview()
            $0.width.equalTo(grayCover.snp.height).multipliedBy(360.0 / 346.0)
        }
        vSection0.snp.makeConstraints {
            $0.top.equalTo(grayCover.snp.top).offset(20)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leadingMargin).offset(40)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailingMargin).offset(-40)
            $0.bottom.equalTo(grayCover.snp.bottom).offset(-46)
        }
        commentLabel.snp.makeConstraints {
            $0.centerY.equalTo(grayCover.snp.bottom).offset(-23)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leadingMargin).offset(40)
        }
        nextButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin).offset(-70)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leadingMargin).offset(40)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailingMargin).offset(-40)
            $0.height.equalTo(42)
        }
    }
    
    private func rxRegister() {
        _ = imagePick0.plusButton?.rx
            .controlEvent(.touchUpInside)
            .bind(onNext: { _ in
                self.pickButtonTap(self.imagePick0, sheetMessage: "사진 1")
            }).disposed(by: disposeBag)
        _ = imagePick1.plusButton?.rx
            .controlEvent(.touchUpInside)
            .bind(onNext: { _ in
                self.pickButtonTap(self.imagePick1, sheetMessage: "사진 2")
            }).disposed(by: disposeBag)
        _ = imagePick2.plusButton?.rx
            .controlEvent(.touchUpInside)
            .bind(onNext: { _ in
                self.pickButtonTap(self.imagePick2, sheetMessage: "사진 3")
            }).disposed(by: disposeBag)
        _ = imagePick3.plusButton?.rx
            .controlEvent(.touchUpInside)
            .bind(onNext: { _ in
                self.pickButtonTap(self.imagePick3, sheetMessage: "사진 4")
            }).disposed(by: disposeBag)
        isPhotoOk
            .asDriver()
            .drive(onNext: {
                self.nextButton.condition = $0 ? .activate : .deactivate
            }).disposed(by: disposeBag)
        nextButton.rx
            .controlEvent(.touchUpInside)
            .bind(onNext: {
                guard self.nextButton.condition == .activate else { return }
                let images: [UIImage?] = [self.imagePick0.source,
                                          self.imagePick1.source,
                                          self.imagePick2.source,
                                          self.imagePick3.source]
                self.bbRequest.pictures = images.map { $0?.jpegData(compressionQuality: 0.5)}
                let viewController = BBRequestDetailViewController()
                viewController.bbUser = self.bbUser
                viewController.bbRequest = self.bbRequest
                self.navigationController?.pushViewController(viewController, animated: true)
            }).disposed(by: disposeBag)
    }
    
    private func pickButtonTap(_ sender: BBImagePick, sheetMessage: String? = nil) {
        focusedImagePick = sender
        let alert = UIAlertController(title: nil, message: sheetMessage, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "카메라로 \(focusedImagePick?.source == nil ? "" : "다시 ")찍기", style: .default, handler: { _ in
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = .camera
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true)
        }))
        alert.addAction(UIAlertAction(title: "사진에서 \(focusedImagePick?.source == nil ? "" : "다시 ")가져오기", style: .default, handler: { _ in
            let imagePicker = UIImagePickerController()
            imagePicker.modalPresentationStyle = .fullScreen
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            imagePicker.delegate = self
            self.present(imagePicker, animated: true)
        }))
        if self.focusedImagePick?.source != nil {
            alert.addAction(UIAlertAction(title: "사진 삭제하기", style: .destructive, handler: { _ in
                self.focusedImagePick?.source = nil
                self.isPhotoOk.accept(self.checkImages())
            }))
        }
        alert.addAction(UIAlertAction(title: "취소", style: .cancel))
        self.present(alert, animated: true)
    }
    
    private func checkImages() -> Bool {
        return imagePick0.source != nil || imagePick1.source != nil || imagePick2.source != nil || imagePick3.source != nil
    }
    
    @objc
    private func doDismiss() {
        dismiss(animated: true)
    }
}

extension BBRequestImagePickViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var newImage: UIImage? = nil
        if let editedImage = info[.editedImage] as? UIImage {
            newImage = editedImage
        } else if let originalImage = info[.originalImage] as? UIImage {
            newImage = originalImage
        }
        focusedImagePick?.source = newImage
        isPhotoOk.accept(checkImages())
        picker.dismiss(animated: true)
    }
}
