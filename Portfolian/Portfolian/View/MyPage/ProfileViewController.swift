//
//  ProfileViewController.swift
//  Portfolian
//
//  Created by 이상현 on 2021/12/10.
//

import UIKit
import SnapKit
import Then
import PhotosUI
class ProfileViewController: UIViewController {
    lazy var profileButton = UIButton().then { UIButton in
        var image = UIImage(named: "profile")
        UIButton.setImage(image, for: .normal)
        UIButton.layer.cornerRadius = 50
        UIButton.layer.borderWidth = 1
        UIButton.clipsToBounds = true
        UIButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
    }
    
    lazy var profileTextButton = UIButton().then { UIButton in
        UIButton.setTitle("프로필 사진 수정", for: .normal)
        UIButton.setTitleColor(ColorPortfolian.thema, for: .normal)
        UIButton.titleLabel?.font = UIFont(name: "NotoSansKR-Bold", size: 16)
        UIButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
    }
        
    lazy var phpickerConfiguration: PHPickerConfiguration = {
        var configuration = PHPickerConfiguration()
        configuration.filter = .any(of: [.images])
        return configuration
    }()
    
    lazy var phpicker = PHPickerViewController(configuration: phpickerConfiguration)
    
    let identifier = "TagCollectionViewCell"
    
    lazy var tagCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 1, height: 1), collectionViewLayout: LeftAlignedCollectionViewFlowLayout()).then { UICollectionView in
        
    }
    
    var containerView = UIView().then { UIView in
        UIView.layer.borderColor = UIColor.systemGray5.cgColor
        UIView.layer.borderWidth = 1
    }
    
    var scrollView = UIScrollView().then { UIScrollView in
        UIScrollView.layer.borderColor = UIColor.systemGray5.cgColor
        UIScrollView.layer.borderWidth = 1
    }
    
    lazy var nickNameLabel = UILabel().then { UILabel in
        UILabel.text = "닉네임"
        UILabel.font = UIFont(name: "NotoSansKR-Bold", size: 16)
        UILabel.textColor = ColorPortfolian.thema
    }
    
    lazy var githubLabel = UILabel().then { UILabel in
        UILabel.text = "깃허브"
        UILabel.font = UIFont(name: "NotoSansKR-Bold", size: 16)
        UILabel.textColor = ColorPortfolian.thema
    }
    
    lazy var githubAddressLabel = UILabel().then { UILabel in
        UILabel.text = "https://github.com/"
        UILabel.font = UIFont(name: "NotoSansKR-Bold", size: 16)
        
    }
    
    lazy var emailLabel = UILabel().then { UILabel in
        UILabel.text = "이메일"
        UILabel.font = UIFont(name: "NotoSansKR-Bold", size: 16)
        UILabel.textColor = ColorPortfolian.thema
    }
    
    lazy var introduceLabel = UILabel().then { UILabel in
        UILabel.text = "소개"
        UILabel.font = UIFont(name: "NotoSansKR-Bold", size: 16)
        UILabel.textColor = ColorPortfolian.thema
    }
    
    lazy var nicknameTextField = UITextField().then { UITextField in
        UITextField.placeholder = "최대 10글자"
        UITextField.font = UIFont(name: "NotoSansKR-Regular", size: 16)
        UITextField.layer.cornerRadius = 10
        UITextField.backgroundColor = .white

    }
    
    lazy var githubTextField = UITextField().then { UITextField in
        UITextField.placeholder = "Portfolian"
        UITextField.font = UIFont(name: "NotoSansKR-Regular", size: 16)
        UITextField.layer.cornerRadius = 10
        UITextField.backgroundColor = .white
    }
    
    lazy var emailTextField = UITextField().then { UITextField in
        UITextField.placeholder = "sanghyle@icloud.com"
        UITextField.font = UIFont(name: "NotoSansKR-Regular", size: 16)
        UITextField.layer.cornerRadius = 10
        UITextField.backgroundColor = .white

    }
    
    lazy var introduceTextView = UITextView().then { UITextView in
        UITextView.font = UIFont(name: "NotoSansKR-Regular", size: 16)
        UITextView.layer.borderWidth = 1
        UITextView.layer.cornerRadius = 10
        UITextView.layer.borderColor = UIColor.systemGray5.cgColor
    }
    
    var nicknameLineView = UIView().then { UIView in
        UIView.backgroundColor = .systemGray5
    }
    var githubLineView = UIView().then { UIView in
        UIView.backgroundColor = .systemGray5
    }
    var emailLineView = UIView().then { UIView in
        UIView.backgroundColor = .systemGray5
    }
    var estimateHeight: CGFloat = 0
    
    lazy var stackButton = UIButton().then { UIButton in
        UIButton.setTitle("사용 기술을 선택해주세요. (최대 7개)", for: .normal)
        UIButton.titleLabel?.font = UIFont(name: "NotoSansKR-Bold", size: 16)
        UIButton.contentHorizontalAlignment = .leading
        UIButton.setTitleColor(ColorPortfolian.thema, for: .normal)
        UIButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
    }
    
    lazy var chevronButton = UIButton().then { UIButton in
        UIButton.setImage(UIImage(systemName: "chevron.right")?.withTintColor(ColorPortfolian.thema, renderingMode: .alwaysOriginal), for: .normal)
        UIButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
    }
    
    lazy var cancelBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.backward"), style: .plain, target: self, action: #selector(buttonPressed(_:))).then { UIBarButtonItem in
        
    }
    
    lazy var saveBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(buttonPressed(_:))).then { UIBarButtonItem in
        
    }


    var beforeImage = UIImage()
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        MyAlamofireManager.shared.getProfile(userId: JwtToken.shared.userId ) { [weak self] user in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.tagCollectionView.reloadData()
                
                let height = self.tagCollectionView.collectionViewLayout.collectionViewContentSize.height
                self.tagCollectionView.snp.updateConstraints {
                    $0.height.equalTo(height)
                }
            }
            self.view.setNeedsLayout()
        }

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = cancelBarButtonItem
        navigationItem.rightBarButtonItem = saveBarButtonItem
        navigationController?.navigationBar.prefersLargeTitles = false
        registrationType = .MyPage
        
        view.addSubview(scrollView)
        scrollView.addSubview(profileButton)
        scrollView.addSubview(profileTextButton)
        scrollView.addSubview(containerView)
        scrollView.addSubview(nickNameLabel)
        scrollView.addSubview(githubLabel)
        scrollView.addSubview(emailLabel)
        scrollView.addSubview(introduceLabel)
        scrollView.addSubview(nicknameTextField)
        scrollView.addSubview(githubTextField)
        scrollView.addSubview(emailTextField)
        scrollView.addSubview(githubAddressLabel)
        scrollView.addSubview(introduceTextView)
        scrollView.addSubview(nicknameLineView)
        scrollView.addSubview(githubLineView)
        scrollView.addSubview(emailLineView)
        scrollView.addSubview(stackButton)
        scrollView.addSubview(chevronButton)
        scrollView.addSubview(tagCollectionView)
        
        scrollView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        containerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(scrollView.contentLayoutGuide)
            make.height.equalTo(scrollView.contentLayoutGuide)
            make.bottom.equalTo(tagCollectionView)
        }
        profileButton.snp.makeConstraints { make in
            make.top.equalTo(scrollView).offset(10)
            make.centerX.equalTo(view.center)
            make.width.height.equalTo(100)
        }
        profileTextButton.snp.makeConstraints { make in
            make.top.equalTo(profileButton.snp.bottom)
            make.centerX.equalTo(view.center)
        }

        nickNameLabel.snp.makeConstraints { make in
            make.top.equalTo(profileTextButton.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(nickNameLabel.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-60)
            
        }
        githubLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        githubAddressLabel.snp.makeConstraints { make in
            make.top.equalTo(githubLabel.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        githubTextField.snp.makeConstraints { make in
            make.top.equalTo(githubLabel.snp.bottom).offset(10)
            make.leading.equalTo(githubAddressLabel.snp.trailing)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-60)
        }
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(githubTextField.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-60)

        }
        introduceLabel.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(10)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(10)
        }
        introduceTextView.snp.makeConstraints { make in
            make.top.equalTo(introduceLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalTo(63)
        }
        nicknameLineView.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom)
            make.leading.trailing.equalTo(nicknameTextField)
            make.height.equalTo(1)
        }
        githubLineView.snp.makeConstraints { make in
            make.top.equalTo(githubTextField.snp.bottom)
            make.leading.trailing.equalTo(githubTextField)
            make.height.equalTo(1)
        }
        emailLineView.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom)
            make.leading.trailing.equalTo(emailTextField)
            make.height.equalTo(1)
        }

        stackButton.snp.makeConstraints { make in
            make.top.equalTo(introduceTextView.snp.bottom).offset(20)
            make.leading.equalTo(introduceLabel)
            make.trailing.equalTo(introduceTextView).offset(20)
        }
        
        chevronButton.snp.makeConstraints { make in
            make.centerY.equalTo(stackButton)
            make.trailing.equalTo(introduceTextView)
        }
        
        tagCollectionView.snp.makeConstraints { make in
            make.top.equalTo(stackButton.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(0)
        }
        tagCollectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: identifier)
        tagCollectionView.delegate = self
        tagCollectionView.dataSource = self
        introduceTextView.delegate = self
        hideKeyboard()
        
        MyAlamofireManager.shared.getProfile(userId: JwtToken.shared.userId ) { [weak self] user in
            guard let self = self else { return }
            self.nicknameTextField.text = user.nickName
            self.githubTextField.text = user.github
            self.emailTextField.text = user.mail
            self.introduceTextView.text = user.description
            
            URLSession.shared.dataTask( with: NSURL(string: user.photo)! as URL, completionHandler: {
                    (data, response, error) -> Void in
                    DispatchQueue.main.async {
                        if let data = data {
                            let image = UIImage(data: data)
                            self.profileButton.setImage(image, for: .normal)
                            if self.profileButton.currentImage != nil {
                                self.beforeImage = self.profileButton.currentImage!
                            }
                        }
                    }
                }).resume()
                DispatchQueue.main.async {
                    self.tagCollectionView.reloadData()

                    let height = self.tagCollectionView.collectionViewLayout.collectionViewContentSize.height
                    self.tagCollectionView.snp.updateConstraints {
                        $0.height.equalTo(height)
                    }
                }
                self.view.setNeedsLayout()
        }
    }
    
    func alert(_ title: String){
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .actionSheet)
        let library = UIAlertAction(title: "사진 앨범", style: .default) { _ in
            self.openLibrary()
        }
        let defaultImage = UIAlertAction(title: "기본 이미지", style: .default) { _ in
            MyAlamofireManager.shared.patchMyDefaultPhoto { [weak self] profileURL in
                guard let self = self else { return }
                
                    URLSession.shared.dataTask( with: NSURL(string: profileURL)! as URL, completionHandler: {
                        (data, response, error) -> Void in
                        DispatchQueue.main.async {
                            if let data = data {
                                let image = UIImage(data: data)
                                self.profileButton.setImage(image, for: .normal)
                                self.beforeImage = image!
                            }
                        }
                    }).resume()
            }
            self.view.makeToast("프로필 사진이 기본 이미지로 변경되었습니다.", duration: 0.75, position: .center)
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(library)
        alert.addAction(defaultImage)
        alert.addAction(cancelAction)
        self.present(alert, animated: true)
    }
    
    func saveProfile() {
        if beforeImage != profileButton.currentImage! && isValidEmail(testStr: emailTextField.text!) {
            self.view.makeToast("성공적으로 저장했습니다 :)", duration: 0.5, position: .center) { [weak self] didTap in
                guard let self = self else { return }
                MyAlamofireManager.shared.patchMyPhoto(profileImage: self.profileButton.currentImage!) { [weak self] in
                    var stringTags: [String] = []
                    for tag in myTag.names {
                        stringTags.append(tag.rawValue)
                    }
                    
                    let myInfo = UserProfile(nickName: (self?.nicknameTextField.text)!, description: (self?.introduceTextView.text)!, stack: stringTags, github: (self?.githubTextField.text)!, mail: (self?.emailTextField.text)!)
                    MyAlamofireManager.shared.patchMyProfile(myInfo: myInfo) { [weak self] in
                        guard let self = self else { return }
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        } else if isValidEmail(testStr: emailTextField.text!) {
            self.view.makeToast("성공적으로 저장했습니다 :)", duration: 0.5, position: .center) { [weak self] didTap in
                guard let self = self else { return }
                
                var stringTags: [String] = []
                for tag in myTag.names {
                    stringTags.append(tag.rawValue)
                }
                
                let myInfo = UserProfile(nickName: self.nicknameTextField.text!, description: self.introduceTextView.text!, stack: stringTags, github: self.githubTextField.text!, mail: self.emailTextField.text!)
                MyAlamofireManager.shared.patchMyProfile(myInfo: myInfo) { [weak self] in
                    guard let self = self else { return }
                    self.navigationController?.popViewController(animated: true)
                }
            }
        } else {
            self.view.makeToast("올바르지 않은 이메일 형식입니다.", duration: 1.5, position: .center)
        }
    }
    
    func openLibrary() {
        phpicker.delegate = self
        
        present(phpicker, animated: true, completion: nil)
    }
    
    @objc private func buttonPressed(_ sender: UIButton) {
        switch sender {
        case profileButton, profileTextButton:
            alert("프로필 사진을 선택해주세요 :)")
        case stackButton, chevronButton:
            registrationType = .MyPage
            view.endEditing(true)
            let FilterVC = UIStoryboard(name: "Filter", bundle: nil).instantiateViewController(withIdentifier: "FilterVC")
            self.navigationController?.pushViewController(FilterVC, animated: true)
        case cancelBarButtonItem:
            self.navigationController?.popViewController(animated: true)
        case saveBarButtonItem:
            self.saveProfile()

        default:
            break
        }
    }
}

extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(SPACINGROW)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(SPACINGCOL)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 더비 라벨을 만들어줘서 크기를 버튼의 크기를 예상하여 넣어준다.
        
        let tag = myTag.names[indexPath.row]
        let tagInfo = Tag.shared.getTagInfo(tag: tag)
        let tagName = tagInfo.name
        let button = TagButton().then {
            $0.informTextInfo(text: tagName, fontSize: 16)
            $0.sizeToFit()
        }
        let size = button.frame.size
        return CGSize(width: size.width, height: size.height + 10)
    }
    
    func isValidEmail(testStr:String) -> Bool {
        if testStr == "" {
            return true
        }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}

extension ProfileViewController: UICollectionViewDataSource {
    // 한 섹션에 몇개의 컬렉션 셀을 보여줄지
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myTag.names.count
        
    }
    // 셀을 어떻게 보여줄지
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = tagCollectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! TagCollectionViewCell
        let tag = myTag.names[indexPath.row]
        let tagInfo = Tag.shared.getTagInfo(tag: tag)
        let tagName = tagInfo.name
        let tagColor = tagInfo.color
        cell.configure(tagName: tagName, tagColor: tagColor, index: tag.index)
        return cell
    }
    
}

extension ProfileViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        dismiss(animated: true)
        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                let uiImage = image as? UIImage
                DispatchQueue.main.async {
                    self.profileButton.setImage(uiImage, for: .normal)
                }
            }
        } else {
            
        }
    }
}

extension ProfileViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            guard let self = self else { return }
            self.scrollView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 300, right: 0.0)
            self.estimateHeight = self.scrollView.contentSize.height - self.scrollView.bounds.size.height + self.scrollView.contentInset.bottom
            let bottomOffset = CGPoint(x: 0, y: self.estimateHeight/2)
            self.scrollView.setContentOffset(bottomOffset, animated: true)
        })
        return true
    }

    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: { [weak self] in
            guard let self = self else { return }
            self.scrollView.contentInset = .zero
            self.scrollView.setContentOffset(.zero, animated: true)
        })
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: textView.bounds.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        if estimatedSize.height <= 100 && estimatedSize.height >= 63 {
            introduceTextView.snp.updateConstraints { make in
                make.height.equalTo(estimatedSize.height)
            }
        } else if estimatedSize.height < 63 {
            introduceTextView.snp.updateConstraints { make in
                make.height.equalTo(63)
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //이전 글자 - 선택된 글자 + 새로운 글자(대체될 글자)
        let newLength = textView.text.count - range.length + text.count
        let koreanMaxCount = 100 + 1
        //글자수가 초과 된 경우 or 초과되지 않은 경우
        if newLength > koreanMaxCount {
            let overflow = newLength - koreanMaxCount //초과된 글자수
            if text.count < overflow {
                return true
            }
            let index = text.index(text.endIndex, offsetBy: -overflow)
            let newText = text[..<index]
            guard let startPosition = textView.position(from: textView.beginningOfDocument, offset: range.location) else { return false }
            guard let endPosition = textView.position(from: textView.beginningOfDocument, offset: NSMaxRange(range)) else { return false }
            guard let textRange = textView.textRange(from: startPosition, to: endPosition) else { return false }
            textView.replace(textRange, withText: String(newText))
            return false
        }
        return true
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.count > 100 {
        //글자수 제한에 걸리면 마지막 글자를 삭제함.
            textView.text.removeLast()
        }
    }
}
