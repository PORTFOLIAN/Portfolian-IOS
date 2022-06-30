//
//  AlamofireManager.swift
//  Portfolian
//
//  Created by 이상현 on 2021/11/22.
//

import Foundation
import Alamofire
import SwiftyJSON
import CoreData

final class MyAlamofireManager {
    // 싱글턴 사용
    static var shared = MyAlamofireManager()
    
    // 인터셉터
    let interceptors = Interceptor(interceptors:
                                    [
                                        BaseInterceptor()
                                    ])
    
    // 로거 설정
    let monitors = [MyLogger()] as [EventMonitor]
    
    // 세션 설정
    var session : Session
    private init() {
        session = Session(
            interceptor: interceptors,
            eventMonitors: monitors
        )
    }
    
    func getProjectID(projectTerm projectArticle: ProjectArticle, completion: @escaping () -> Void) {
        self.session
            .request(MyProjectRouter.createProject(term: projectArticle))
            .validate(statusCode: 200..<401) // Au th 검증
            .responseJSON  { [weak self] response in
                guard let self = self else { return }
                guard let responseValue = response.value else { return }
                
                let responseJson = JSON(responseValue)
                guard let code = responseJson["code"].int,
                      let message = responseJson["message"].string else { return }
                
                if code == 1 {
                    guard let projectID = responseJson["newProjectID"].string else { return }
                    recruitWriting.code = code
                    recruitWriting.newProjectID = projectID
                    recruitWriting.message = message
                    completion()
                } else {
                    self.toast(message)
                }
            }
    }
    
    func getProject(projectID: String, completion: @escaping () -> Void) {
        self.session
            .request(MyProjectRouter.enterProject(projectID: projectID))
            .validate(statusCode: 200..<401) // Auth 검증
            .responseData { response in
                guard let responseData = response.data else { return }
                projectInfo = try! JSONDecoder().decode(ProjectInfo.self, from: responseData)
                let code = projectInfo.code
                if code == 1 {
                    completion()
                }
            }
    }
    
    func finishProject(projectID: String, complete: Bool, completion: @escaping () -> Void) {
        self.session
            .request(MyProjectRouter.patchFinishProject(projectID: projectID, complete: complete))
            .validate(statusCode: 200..<401) // Auth 검증
            .responseJSON { [weak self] response in
                guard let self = self else { return }
                guard let responseValue = response.value else { return }
                let responseJson = JSON(responseValue)
                guard let code = responseJson["code"].int,
                      let message = responseJson["message"].string else { return }
                if code == 1 {
                    completion()
                } else {
                    self.toast(message)
                }
            }
    }
    
    func deleteProject(projectID: String, completion: @escaping () -> Void) {
        self.session
            .request(MyProjectRouter.deleteProject(projectID: projectID))
            .validate(statusCode: 200..<401) // Auth 검증
            .responseData { response in
                guard let responseData = response.data else { return }
                guard let  codeMessage = try? JSONDecoder().decode(Response.self, from: responseData) else { return }
                let code = codeMessage.code
                let message = codeMessage.message
                if code == 1 {
                    completion()
                } else {
                    self.toast(message)
                }
            }
    }
    
    func getProjectList(searchOption: ProjectSearch, completion: @escaping (ProjectListInfo) -> Void) {
        self.session
            .request(MyProjectRouter.arrangeProject(searchOption: searchOption))
            .validate(statusCode: 200..<401) // Auth 검증
            .responseData { response in
                guard let responseData = response.data else { return }
                projectListInfo = try! JSONDecoder().decode(ProjectListInfo.self, from: responseData)
                let code = projectListInfo.code
                if code == 1 {
                    completion(projectListInfo)
                }
            }
    }
    
    func getBookmarkList(completion: @escaping (ProjectListInfo) -> Void) {
        self.session
            .request(MyUserRouter.arrangeProject)
            .validate(statusCode: 200..<401) // Auth 검증
            .responseData { response in
                guard let responseData = response.data else { return }
                guard let bookmarkListInfo = try? JSONDecoder().decode(ProjectListInfo.self, from: responseData) else { return }
                let code = projectListInfo.code
                if code == 1 {
                    completion(bookmarkListInfo)
                }
            }
    }
    
    func postKaKaoToken(token: String, completion: @escaping () -> Void) {
        self.session
            .request(MyOauthRouter.postKaKaoToken(token: token))
            .validate(statusCode: 200..<401) // Auth 검증
            .responseJSON { response in
                if let cookie = response.response?.allHeaderFields["Set-Cookie"] as? String {
                    let start = cookie.index(cookie.startIndex, offsetBy: 8)
                    guard let end = cookie.firstIndex(of: ";") else { return }
                    let refreshToken = String(cookie[start..<end])
                    KeychainManager.shared.create(key: "refreshToken", token: refreshToken)
                }
            }
            .responseData { response in
                guard let responseData = response.data else { return }
                guard let jwt = try? JSONDecoder().decode(Jwt.self, from: responseData) else { return }
                KeychainManager.shared.create(key: "userId", token: jwt.userId)
                KeychainManager.shared.create(key: "accessToken", token: jwt.accessToken)
                Jwt.shared = jwt
                let code = jwt.code
                if code == 1 {
                    UserDefaults.standard.set(LoginType.kakao.rawValue, forKey: "loginType")
                    loginType = LoginType(rawValue: LoginType.kakao.rawValue)
                    completion()
                }
            }
    }
    
    func postAppleToken(userId: String, completion: @escaping () -> Void) {
        self.session
            .request(MyOauthRouter.postAppleToken(userId: userId))
            .validate(statusCode: 200..<401) // Auth 검증
            .responseJSON { response in
                if let cookie = response.response?.allHeaderFields["Set-Cookie"] as? String {
                    let start = cookie.index(cookie.startIndex, offsetBy: 8)
                    guard let end = cookie.firstIndex(of: ";") else { return }
                    let refreshToken = String(cookie[start..<end])
                    KeychainManager.shared.create(key: "refreshToken", token: refreshToken)
                }
            }
            .responseData { response in
                guard let responseData = response.data else { return }
                guard let jwt = try? JSONDecoder().decode(Jwt.self, from: responseData) else { return }
                KeychainManager.shared.create(key: "userId", token: jwt.userId)
                KeychainManager.shared.create(key: "accessToken", token: jwt.accessToken)
                Jwt.shared = jwt
                let code = jwt.code
                if code == 1 {
                    UserDefaults.standard.set(LoginType.apple.rawValue, forKey: "loginType")
                    loginType = LoginType(rawValue: LoginType.apple.rawValue)
                    completion()
                }
            }
    }
    
    func patchNickName(nickName: String, completion: @escaping () -> Void) {
        self.session
            .request(MyUserRouter.patchNickName(nickName: nickName))
            .validate(statusCode: 200..<401) // Auth 검증
            .responseJSON { response in
                guard let responseValue = response.value else { return }
                let responseJson = JSON(responseValue)
                guard let code = responseJson["code"].int,
                      let message = responseJson["message"].string else { return }

                if code == 1 {
                    completion()
                } else {
                    self.toast(message)
                }
            }
    }
    
    func patchMyProfile(myInfo: UserProfile, completion: @escaping () -> Void) {
        self.session
            .request(MyUserRouter.patchMyProfile(myInfo: myInfo))
            .validate(statusCode: 200..<401)
            .responseJSON { [weak self] response in
                guard let self = self else { return }
                guard let responseValue = response.value else { return }
                
                let responseJson = JSON(responseValue)
                guard let code = responseJson["code"].int,
                      let message = responseJson["message"].string else { return }

                if code == 1 {
                    completion()
                } else {
                    self.toast(message)
                }
            }
    }
    
    func patchFcm(fcm: String, completion: @escaping () -> Void) {
        self.session
            .request((MyUserRouter.patchFcm(fcm: fcm)))
            .validate(statusCode: 200..<401)
            .responseJSON { [weak self] response in
                guard let self = self else { return }
                guard let responseValue = response.value else { return }
                
                let responseJson = JSON(responseValue)
                guard let code = responseJson["code"].int,
                      let message = responseJson["message"].string else { return }

                if code == 1 {
                    completion()
                } else {
                    self.toast(message)
                }
            }
    }
    
    func patchMyDefaultPhoto(completion: @escaping (String) -> Void) {
        self.session
            .request(MyUserRouter.patchMyDefaultPhoto)
            .validate(statusCode: 200..<401)
            .responseJSON { response in
                guard let responseValue = response.value else { return }
                
                let responseJson = JSON(responseValue)
                guard let code = responseJson["code"].int,
                      let profileImage = responseJson["profileURL"].string,
                      let message = responseJson["message"].string else { return }
                
                if code == 1 {
                    completion(profileImage)
                } else {
                    self.toast(message)
                }
            }
    }
    
    func patchMyPhoto(profileImage: UIImage, completion: @escaping () -> Void) {
        let route = MyUserRouter.patchMyPhoto(image: profileImage)
        self.session
            .upload(multipartFormData: route.multipartFormData, with: route)
            .uploadProgress { (progress) in
                print("\(progress)")
            }
            .validate(statusCode: 200..<401)
            .responseData { (response) in
                completion()
            }
    }
    
    func getProfile(userId: String, completion: @escaping (User) -> Void) {
        self.session
            .request(MyUserRouter.getProfile(userId: userId))
            .validate(statusCode: 200..<401) // Auth 검증
            .responseData { response in
                guard let responseData = response.data else { return }
                guard let user = try? JSONDecoder().decode(User.self, from: responseData) else { return }
                
                completion(user)
            }
    }
    
    func renewAccessToken(completion: @escaping (Bool) -> Void) {
        self.session
            .request(MyOauthRouter.postRefreshToken)
            .validate(statusCode: 200..<401) // Auth 검증
            .responseJSON { response in
                guard let responseValue = response.value else { return }
                let responseJson = JSON(responseValue)
                
                guard let code = responseJson["code"].int else { return }

                if code == 1 {
                    guard let accessToken = responseJson["accessToken"].string else { return }
                    KeychainManager.shared.create(key: "accessToken", token: accessToken)
                    JwtToken.shared.accessToken = accessToken
                    completion(true)
                } else {
                    completion(false)
                }
            }
    }
    
    func patchLogout(completion: @escaping () -> Void) {
        self.session
            .request(MyOauthRouter.patchLogout)
            .validate(statusCode: 200..<401) // Auth 검증
            .responseData { [weak self] response in
                guard let self = self else { return }
                guard let responseData = response.data else { return }
                guard let codeMessage = try? JSONDecoder().decode(Response.self, from: responseData) else { return }
                
                let code = codeMessage.code
                let message = codeMessage.message

                if code == 1 {
                    UserDefaults.standard.set(LoginType.first.rawValue, forKey: "loginType")
                    loginType = LoginType.first
                    completion()
                } else {
                    self.toast(message)
                }
            }
    }
    
    func putProject(projectArticle: ProjectArticle, completion: @escaping () -> Void) {
        self.session
            .request(MyProjectRouter.putProject(term: projectArticle))
            .validate(statusCode: 200..<401) // Auth 검증
            .responseData { [weak self] response in
                guard let self = self else { return }
                guard let responseData = response.data else { return }
                guard let codeMessage = try? JSONDecoder().decode(Response.self, from: responseData) else { return }
                
                let code = codeMessage.code
                let message = codeMessage.message

                if code == 1 {
                    completion()
                } else {
                    self.toast(message)
                }
            }
    }
    
    func deleteUserId(completion: @escaping () -> Void) {
        self.session
            .request(MyUserRouter.deleteUserId)
            .validate(statusCode: 200..<401) // Auth 검증
            .responseData { [weak self] response in
                guard let self = self else { return }
                guard let responseData = response.data else { return }
                guard let codeMessage = try? JSONDecoder().decode(Response.self, from: responseData) else { return }
                let code = codeMessage.code
                let message = codeMessage.message
                if code == 1 {
                    UserDefaults.standard.set(LoginType.first.rawValue, forKey: "loginType")
                    loginType = LoginType.first
                    return completion()
                } else {
                    self.toast(message)
                }
            }
    }
    
    func postBookmark(bookmark: Bookmark) {
        self.session
            .request(MyUserRouter.postBookMark(bookmark: bookmark))
            .validate(statusCode: 200..<401) // Auth 검증
            .responseData { [weak self] response in
                guard let self = self else { return }
                guard let responseData = response.data else { return }
                guard let codeMessage = try? JSONDecoder().decode(Response.self, from: responseData) else { return }
                
                let code = codeMessage.code
                let message = codeMessage.message
                
                if code != 1 {
                    self.toast(message)
                }
            }
    }
    
    func fetchRoomId(userId: String, projectId: String, completion: @escaping (String) -> Void) {
        self.session
            .request(MyChatRouter.postChatRoom(userId: userId, projectId: projectId))
            .validate(statusCode: 200..<401) // Auth 검증
            .responseJSON { [weak self] response in
                guard let self = self else { return }
                guard let responseValue = response.value else { return }
                
                let responseJson = JSON(responseValue)
                guard let code = responseJson["code"].int,
                      let message = responseJson["message"].string,
                      let chatRoomId = responseJson["chatRoomId"].string
                else { return }
                if code == 1 {
                    completion(chatRoomId)
                } else {
                    self.toast(message)
                }
            }
    }
    
    func fetchChatRoomList(completion: @escaping (ChatRoomList) -> Void) {
        self.session
            .request(MyChatRouter.getChatRoomList)
            .validate(statusCode: 200..<401) // Auth 검증
            .responseData { [weak self] response in
                guard let self = self else { return }
                guard let responseData = response.data else { return }
                guard let chatRoomList = try? JSONDecoder().decode(ChatRoomList.self, from: responseData) else { return }
                let code = chatRoomList.code
                let message = chatRoomList.message
                if code == 1 {
                    completion(chatRoomList)
                } else {
                    self.toast(message)
                }
            }
    }
    
    func fetchChatMessageList(chatRoomId: String, completion: @escaping (ChatMessageList) -> Void) {
        self.session
            .request(MyChatRouter.getChatMessageList(chatRoomId: chatRoomId))
            .validate(statusCode: 200..<401) // Auth 검증
            .responseData { [weak self] response in
                guard let self = self else { return }
                guard let responseData = response.data else { return }
                guard let chatMessageList = try? JSONDecoder().decode(ChatMessageList.self, from: responseData) else { return }
                let code = chatMessageList.code
                let message = chatMessageList.message
                if code == 1 {
                    completion(chatMessageList)
                } else {
                    self.toast(message)
                }
            }
    }
    
    func exitChatRoom(chatRoomId: String, completion: @escaping () -> Void) {
        self.session
            .request(MyChatRouter.putChatRoom(chatRoomId: chatRoomId))
            .validate(statusCode: 200..<401) // Auth 검증
            .responseData { [weak self] response in
                guard let self = self else { return }
                guard let responseData = response.data else { return }
                guard let  codeMessage = try? JSONDecoder().decode(Response.self, from: responseData) else { return }
                let code = codeMessage.code
                let message = codeMessage.message
                if code == 1 {
                    completion()
                } else {
                    self.toast(message)
                }
            }
    }
    
    func reportUser(userId: String, reason: String, completion: @escaping () -> Void) {
        self.session
            .request(MyReportsRouter.postReportUser(userId: userId, reason: reason))
            .validate(statusCode: 200..<401) // Auth 검증
            .responseData { [weak self] response in
                guard let self = self else { return }
                guard let responseData = response.data else { return }
                guard let  codeMessage = try? JSONDecoder().decode(Response.self, from: responseData) else { return }
                let code = codeMessage.code
                let message = codeMessage.message
                if code == 1 {
                    completion()
                } else {
                    self.toast(message)
                }
            }
    }
    
    func reportProject(projectID: String, reason: String, completion: @escaping () -> Void) {
        self.session
            .request(MyReportsRouter.postReportProject(projectID: projectID, reason: reason))
            .validate(statusCode: 200..<401) // Auth 검증
            .responseData { [weak self] response in
                guard let self = self else { return }
                guard let responseData = response.data else { return }
                guard let  codeMessage = try? JSONDecoder().decode(Response.self, from: responseData) else { return }
                let code = codeMessage.code
                let message = codeMessage.message
                if code == 1 {
                    completion()
                } else {
                    self.toast(message)
                }
            }
    }
    func fetchIsBan(completion: @escaping () -> Void) {
        self.session
            .request(MyUserRouter.getIsBan)
            .validate(statusCode: 200..<401) // Auth 검증
            .responseJSON  { [weak self] response in
                guard let self = self else { return }
                guard let responseValue = response.value else { return }
                
                let responseJson = JSON(responseValue)
                // 데이터 파싱
                guard let code = responseJson["code"].int,
                      let message = responseJson["message"].string,
                      let isBan = responseJson["isBan"].bool else { return }
                
                if code == 1 {
                    if !isBan {
                        completion()
                    } else {
                        self.toast("신고가 3번이상 누적되어 이용 정지되었습니다.\n관리자에게 문의하세요.")
                    }
                } else {
                    self.toast(message)
                }
            }
    }
    
    private func toast(_ message: String) {
        DispatchQueue.main.async {
            if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
                sceneDelegate.window?.rootViewController?.view.makeToast("😅 \(message)", duration: 1, position: .center)
            }
        }
    }
}
