//
//  KeychainManager.swift
//  Portfolian
//
//  Created by 이상현 on 2022/04/14.
//

import Foundation
import Security

class KeychainManager {
    static var shared: KeychainManager = KeychainManager()

    let bundleId = "io.github.yi-sang.Portfolian"
    
    func create(key: String, token: String) {
        // 1. query 작성
        let keyChainQuery: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: bundleId,
            kSecAttrAccount: key,
            kSecValueData: token.data(using: .utf8, allowLossyConversion: false)!
            // 인코딩과정에서 손실 비허용
        ]
        
        // 2. Delete
        // Key Chain은 Key값에 중복이 생기면 저장할 수 없기 때문에 먼저 Delete
        SecItemDelete(keyChainQuery)
        
        // 3. Create
        let status: OSStatus = SecItemAdd(keyChainQuery, nil)
        assert(status == noErr, "토큰 저장에 실패하였습니다.")
    }
    
    // Read
    func read(key: String) -> String? {
        let KeyChainQuery: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: bundleId,
            kSecAttrAccount: key,
            kSecReturnData: kCFBooleanTrue!,
            // CFData타입으로 불러오라는 의미
            kSecMatchLimit: kSecMatchLimitOne
            // 중복되는 경우 하나의 값만 가져오라는 의미
        ]
        // CFData 타입 -> AnyObject로 받고, Data로 타입변환해서 사용하면됨
        
        // Read
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(KeyChainQuery, &dataTypeRef)
        
        // Read 성공 및 실패한 경우
        if(status == errSecSuccess) {
            let retrievedData = dataTypeRef as! Data
            let value = String(data: retrievedData, encoding: String.Encoding.utf8)
            return value
        } else {
            print("토큰 로딩에 실패하였습니다., status code = \(status)")
            return nil
        }
    }
    
    // Delete
    func delete(key: String) {
        let keyChainQuery: NSDictionary = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: bundleId,
            kSecAttrAccount: key
        ]
        
        let status = SecItemDelete(keyChainQuery)
        assert(status == noErr, "토큰 삭제에 실패하였습니다., status code = \(status)")
    }
    
//    // HTTPHeaders 구성
//    func getAuthorizationHeader(serviceID: String) -> HTTPHeaders? {
//        let serviceID = serviceID
//        if let accessToken = self.read(serviceID, account: "accessToken") {
//            return ["Authorization" : "bearer \(accessToken)"] as HTTPHeaders
//        } else {
//            return nil
//        }
//    }
}
