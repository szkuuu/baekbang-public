//
//  BBNetworking.swift
//  BaekBang
//
//  Created by 차상호 on 2021/06/24.
//

import Foundation
import Alamofire
import SwiftyJSON

enum BBError: Error {
    case urlIsInvalid(url: String)
    case didNotResponse(reason: String)
}

extension BBError {
    var errorDescription: String {
        switch self {
        case .urlIsInvalid(let url):
            return "\(url)은 유효한 주소값이 아닙니다."
        case .didNotResponse(let reason):
            return reason
        }
    }
}

typealias BBResponse = (Result<JSON, BBError>) -> Void

struct BBNetworking {
    // MARK: - 주소 api
    struct Juso {
        static func fetch(withQuery query: String, _ completionHandler: @escaping (Result<[BBJuso], BBError>) -> Void) {
            let urlString = BBSecret.baseUrlJuso + "addrlink/addrLinkApi.do"
            guard let url = URL(string: urlString) else {
                completionHandler(.failure(.urlIsInvalid(url: urlString)))
                return
            }
            let parameter: [String: Any] = [
                "confmKey": BBSecret.authKeyJuso,
                "currentPage": "1",
                "countPerPage": "20",
                "keyword": query,
                "resultType": "json"
            ]
            AF.request(url, method: .get, parameters: parameter)
                .responseJSON { response in
                    print("HERE")
                    switch response.result {
                    case .success(let ret):
                        if let addressList = JSON(ret)["results"]["juso"].array {
                            completionHandler(.success(addressList.map { e in
                                BBJuso(
                                    roadAddr: e["roadAddr"].stringValue,
                                    roadAddrPart1: e["roadAddrPart1"].stringValue,
                                    roadAddrPart2: e["roadAddrPart2"].stringValue,
                                    jibunAddr: e["jibunAddr"].stringValue,
                                    engAddr: e["engAddr"].stringValue,
                                    zipNo: e["zipNo"].stringValue,
                                    admCd: e["admCd"].stringValue,
                                    rnMgtSn: e["rnMgtSn"].stringValue,
                                    bdMgtSn: e["bdMgtSn"].stringValue,
                                    detBdNmList: e["detBdNmList"].string,
                                    bdNm: e["bdNm"].string,
                                    bdKdcd: e["bdKdcd"].stringValue,
                                    siNm: e["siNm"].stringValue,
                                    sggNm: e["sggNm"].stringValue,
                                    emdNm: e["emdNm"].stringValue,
                                    liNm: e["liNm"].stringValue,
                                    rn: e["rn"].stringValue,
                                    udrtYn: e["udrtYn"].stringValue,
                                    buldMnnm: e["buldMnnm"].intValue,
                                    buldSlno: e["buldSlno"].intValue,
                                    mtYn: e["mtYn"].stringValue,
                                    lnbrMnnm: e["lnbrMnnm"].intValue,
                                    lnbrSlno: e["lnbrSlno"].intValue,
                                    emdNo: e["emdNo"].stringValue,
                                    hstryYn: e["hstryYn"].stringValue,
                                    relJibun: e["relJibun"].string,
                                    hemdNm: e["hemdNm"].string)
                            }))
                        } else {
                            completionHandler(.success([]))
                        }
                    case .failure(let err):
                        print("\(#function): \(err.localizedDescription)")
                        completionHandler(.failure(.didNotResponse(reason: err.localizedDescription)))
                    }
                }
        }
    }
    
    // MARK: - 유저
    struct User {
        static func verify(withPhone phoneNumber: String, _ completionHandler: @escaping BBResponse) {
            let urlString = BBSecret.baseUrlBaekBang + "login/join/getcerti/"
            guard let url = URL(string: urlString) else {
                completionHandler(.failure(.urlIsInvalid(url: urlString)))
                return
            }
            let parameter: [String: Any] = [
                "key": BBSecret.authKeyBaekBang,
                "phone": phoneNumber
            ]
            AF.request(url, method: .post, parameters: parameter)
                .responseJSON { response in
                    switch response.result {
                    case .success(let ret):
                        completionHandler(.success(JSON(ret)))
                    case .failure(let err):
                        completionHandler(.failure(.didNotResponse(reason: err.localizedDescription)))
                    }
                }
        }
        
        static func login(at user: BBUser, _ completionHandler: @escaping BBResponse) {
            let urlString = BBSecret.baseUrlBaekBang + "login/"
            guard let url = URL(string: urlString) else {
                completionHandler(.failure(.urlIsInvalid(url: urlString)))
                return
            }
            let parameter: [String: Any] = [
                "key": BBSecret.authKeyBaekBang,
                "token": user.token,
                "identifier": user.id
            ]
            AF.request(url, method: .post, parameters: parameter)
                .responseJSON { response in
                    switch response.result {
                    case .success(let ret):
                        completionHandler(.success(JSON(ret)))
                    case .failure(let err):
                        completionHandler(.failure(.didNotResponse(reason: err.localizedDescription)))
                    }
                }
        }
        
        static func newToken(at user: BBUser, _ completionHandler: @escaping BBResponse) {
            let urlString = BBSecret.baseUrlBaekBang + "login/new/"
            guard let url = URL(string: urlString) else {
                completionHandler(.failure(.urlIsInvalid(url: urlString)))
                return
            }
            let parameter: [String: Any] = [
                "key": BBSecret.authKeyBaekBang,
                "phone": user.phoneNumber,
                "identifier": user.id
            ]
            AF.request(url, method: .post, parameters: parameter)
                .responseJSON { response in
                    switch response.result {
                    case .success(let ret):
                        completionHandler(.success(JSON(ret)))
                    case .failure(let err):
                        completionHandler(.failure(.didNotResponse(reason: err.localizedDescription)))
                    }
                }
        }
        
        static func get(with user: BBUser, _ completionHandler: @escaping BBResponse) {
            let urlString = BBSecret.baseUrlBaekBang + "mypage/info/"
            guard let url = URL(string: urlString) else {
                completionHandler(.failure(.urlIsInvalid(url: urlString)))
                return
            }
            let parameter: [String: Any] = [
                "key": BBSecret.authKeyBaekBang,
                "token": user.token
            ]
            AF.request(url, method: .post, parameters: parameter)
                .responseJSON { response in
                    switch response.result {
                    case .success(let ret):
                        let escapingResult = JSON(ret)
                        if escapingResult.arrayValue[0]["result"].boolValue {
                            completionHandler(.success(escapingResult))
                        } else {
                            completionHandler(.failure(.didNotResponse(reason: "타 기기에서 로그인 되었습니다. 다시 로그인 해주세요.")))
                        }
                    case .failure(let err):
                        completionHandler(.failure(.didNotResponse(reason: err.localizedDescription)))
                    }
                }
        }
        
        static func join(with user: BBUser, _ completionHandler: @escaping BBResponse) {
            let urlString = BBSecret.baseUrlBaekBang + "login/join/"
            guard let url = URL(string: urlString) else {
                completionHandler(.failure(.urlIsInvalid(url: urlString)))
                return
            }
            let parameter: [String: Any] = [
                "key": BBSecret.authKeyBaekBang,
                "phone": user.phoneNumber,
                "name": user.name,
                "address1": user.mainAddr,
                "address2": user.subAddr ?? "",
                "gender": user.gender,
                "building_code": user.buildingCode,
                "marketing": user.isAllowedMarketing,
                "identifier" : user.id
            ]
            AF.request(url, method: .post, parameters: parameter)
                .responseJSON { response in
                    switch response.result {
                    case .success(let ret):
                        completionHandler(.success(JSON(ret)))
                    case .failure(let err):
                        completionHandler(.failure(.didNotResponse(reason: err.localizedDescription)))
                    }
                }
        }
        
        static func update(with user: BBUser, _ completionHandler: @escaping BBResponse) {
            let urlString = BBSecret.baseUrlBaekBang + "mypage/update/"
            guard let url = URL(string: urlString) else {
                completionHandler(.failure(.urlIsInvalid(url: urlString)))
                return
            }
            let parameter: [String: Any] = [
                "key": BBSecret.authKeyBaekBang,
                "token": user.token,
                "phone": user.phoneNumber,
                "name": user.name,
                "address1": user.mainAddr,
                "address2": user.subAddr ?? "",
                "building_code": user.buildingCode
            ]
            AF.request(url, method: .post, parameters: parameter)
                .responseJSON { response in
                    switch response.result {
                    case .success(let ret):
                        completionHandler(.success(JSON(ret)))
                    case .failure(let err):
                        completionHandler(.failure(.didNotResponse(reason: err.localizedDescription)))
                    }
                }
        }
    }
    
    // MARK: - 수리요청
    struct Request {
        static func send(with request: BBRequest, _ completionHandler: @escaping BBResponse) {
            let urlString = BBSecret.baseUrlBaekBang + "repair/request/test/"
            guard let url = URL(string: urlString),
                  let user = request.user else {
                completionHandler(.failure(.urlIsInvalid(url: urlString)))
                return
            }
            let parameter: [String: Any] = [
                "key": BBSecret.authKeyBaekBang,
                "token": user.token,
                "detail": request.content,
                "building_code": request.buildingCode,
                "week": request.visitDay,
                "time": request.visitTime,
                "test": "0"
            ]
            AF.upload(multipartFormData: { data in
                parameter.forEach {
                    data.append("\($0.value)".data(using: .utf8)!, withName: $0.key, mimeType: "text/plain")
                }
                request.pictures.filter { $0 != nil }.enumerated().forEach {
                    data.append($0.element!, withName: "pic\($0.offset + 1)", fileName: "\(UUID().uuidString).jpg", mimeType: "image/jpg")
                }
            }, to: url, method: .post)
            .responseJSON { response in
                switch response.result {
                case .success(let ret):
                    completionHandler(.success(JSON(ret)))
                case .failure(let err):
                    completionHandler(.failure(.didNotResponse(reason: err.localizedDescription)))
                }
            }
        }
    }
}
