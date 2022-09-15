//
//  BBAddressViewController.swift
//  BaekBang
//
//  Created by 차상호 on 2021/06/23.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import SwiftyJSON

class BBAddressViewController: UIViewController {
    
    private var disposeBag = DisposeBag()
    
    private var items: PublishRelay<[BBJuso]> = .init()
    
    public weak var delegate: BBAddressViewControllerDelegate?
    
    private lazy var leftButton: UIBarButtonItem = {
        let button = UIBarButtonItem(title: "완료", style: .plain, target: self, action: nil)
        return button
    }()

    private lazy var titleLabel0: UILabel = {
        let label = UILabel()
        label.text = "도로명이나 지번주소를"
        label.font = .systemFont(ofSize: 21, weight: .bold)
        return label
    }()
    
    private lazy var titleLabel1: UILabel = {
        let label = UILabel()
        label.text = "입력해주세요"
        label.font = .systemFont(ofSize: 21, weight: .bold)
        return label
    }()
    
    private lazy var section0: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 1.0
        return stackView
    }()
    
    private lazy var jusoSearchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.backgroundImage = UIImage()
        searchBar.placeholder = "주소를 입력해주세요"
        return searchBar
    }()
    
    private lazy var jusoStorage: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 70
        tableView.separatorStyle = .none
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        arrange()
        layout()
        navigationItem.leftBarButtonItem = leftButton
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
        section0.insertArrangedSubview(titleLabel0, at: 0)
        section0.insertArrangedSubview(titleLabel1, at: 1)
        view.addSubview(section0)
        view.addSubview(jusoSearchBar)
        jusoStorage.register(UITableViewCell.self, forCellReuseIdentifier: "jusoStorageCell")
        view.addSubview(jusoStorage)
    }
    
    private func layout() {
        section0.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.topMargin).offset(29)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leadingMargin).offset(40)
        }
        jusoSearchBar.snp.makeConstraints {
            $0.top.equalTo(section0.snp.bottom).offset(23)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leadingMargin).offset(40)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailingMargin).offset(-40)
        }
        jusoStorage.snp.makeConstraints {
            $0.top.equalTo(jusoSearchBar.snp.bottom).offset(29)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leadingMargin).offset(40)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailingMargin).offset(-40)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottomMargin)
        }
    }
    
    private func rxRegister() {
        _ = leftButton.rx
            .tap
            .bind(onNext: { _ in
                self.dismiss(animated: true, completion: nil)
            }).disposed(by: disposeBag)
        _ = jusoSearchBar.rx
            .text
            .orEmpty
            .throttle(.milliseconds(400), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: {
                BBNetworking.Juso.fetch(withQuery: $0) { result in
                    switch result {
                    case .success(let juso):
                        self.items.accept(juso)
                    case .failure(let err):
                        self.items.accept([])
                        print("error: \(err.localizedDescription)")
                    }
                }
            }).disposed(by: disposeBag)
        _ = items
            .bind(to: self.jusoStorage.rx.items) { tableView, row, element in
                let cell: UITableViewCell = UITableViewCell(style: .subtitle, reuseIdentifier: "jusoStorageCell")
                cell.textLabel?.text = element.roadAddr
                cell.textLabel?.font = .systemFont(ofSize: 14.0)
                cell.detailTextLabel?.text = element.jibunAddr
                cell.detailTextLabel?.font = .systemFont(ofSize: 12.0)
                cell.detailTextLabel?.textColor = .bbGray1
                return cell
            }.disposed(by: disposeBag)
        _ = Observable.zip(jusoStorage.rx.itemSelected, jusoStorage.rx.modelSelected(BBJuso.self))
            .subscribe(onNext: { indexPath, modelType in
                self.jusoStorage.deselectRow(at: indexPath, animated: true)
                self.delegate?.bbAddressViewController(self, selectedData: modelType)
            }).disposed(by: disposeBag)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        
    }
}

protocol BBAddressViewControllerDelegate: AnyObject {
    func bbAddressViewController(_ bbAddressViewController: BBAddressViewController, selectedData: BBJuso)
}
