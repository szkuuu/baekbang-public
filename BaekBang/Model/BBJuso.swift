//
//  Juso.swift
//  BaekBang
//
//  Created by 차상호 on 2021/06/24.
//

/// 도로명 주소 api 객체
struct BBJuso: Hashable, Codable {
    /// 전체 도로명 주소
    var roadAddr: String = ""
    
    /// 도로명주소(참고항목 제외)
    var roadAddrPart1: String = ""
    
    /// 도로명주소(참고항목)
    var roadAddrPart2: String = ""
    
    /// 지번주소
    var jibunAddr: String = ""
    
    /// 영문주소
    var engAddr: String = ""
    
    /// 우편번호
    var zipNo: String = ""
    
    /// 행정구역코드
    var admCd: String = ""
    
    /// 도로명코드
    var rnMgtSn: String = ""
    
    /// 건물관리번호
    var bdMgtSn: String = ""
    
    /// 상세건물명
    var detBdNmList: String? = nil
    
    /// 건물명
    var bdNm: String? = nil
    
    /// 공동주택여부
    var bdKdcd: String = ""
    
    /// 시도명
    var siNm: String = ""
    
    /// 시군구명
    var sggNm: String = ""
    
    /// 읍면동명
    var emdNm: String = ""
    
    /// 법정리명
    var liNm: String = ""
    
    /// 도로명
    var rn: String = ""
    
    /// 지하여부
    var udrtYn: String = ""
    
    /// 건물본번
    var buldMnnm: Int = 0
    
    /// 건물부번
    var buldSlno: Int = 0
    
    /// 산여부
    var mtYn: String = ""
    
    /// 지번본번
    var lnbrMnnm: Int = 0
    
    /// 지번부번
    var lnbrSlno: Int = 0
    
    /// 읍면동 일련번호
    var emdNo: String = ""
    
    /// 변동이력여부
    var hstryYn: String = ""
    
    /// 관련 지번
    var relJibun: String? = nil
    
    /// 관할주민센터
    var hemdNm: String? = nil
}
