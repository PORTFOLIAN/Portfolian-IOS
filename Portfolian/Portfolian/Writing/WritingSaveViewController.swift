//
//  WritingSaveViewController.swift
//  Portfolian
//
//  Created by 이상현 on 2021/11/30.
//

import UIKit
import SnapKit
import Then
import Alamofire
import SwiftyMarkdown
class WritingSaveViewController: UIViewController {
    lazy var scrollView = UIScrollView()
    lazy var contentView = UIView()
    lazy var shareBarButtonItem = UIBarButtonItem(image: UIImage(named: "Share"), style: .plain, target: self, action: #selector(buttonPressed(_:)))
    

    // cellForItemAt은 콜렉션뷰의 크기가 0보다 커야 실행된다.
//    lazy var tagCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 1, height: 1), collectionViewLayout: LeftAlignedCollectionViewFlowLayout())
    lazy var tagsCollectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: 1, height: 1), collectionViewLayout: LeftAlignedCollectionViewFlowLayout())
    lazy var titleLabel = UILabel().then({ UILabel in
        UILabel.text = "React를 활용한 간단한 로그인 기능 구현하기"
        UILabel.font = UIFont(name: "NotoSansKR-Bold", size: 20)
    })
    lazy var leftUIView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 30)).then({ UIView in
        let icon = UIImage(named: "AddUser")
        var iconView = UIImageView(image: icon)
        iconView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        UIView.addSubview(iconView)
        UIView.contentMode = .bottom
    })
    lazy var viewsLabel = UILabel().then({ UILabel in
        let views = 0
        UILabel.text = "조회수"+String(views)
        UILabel.font = UIFont(name: "NotoSansKR-Regular", size: 12)
        UILabel.textColor = .gray
    })
    
    lazy var recruitLabel = UILabel().then({ UILabel in
        let numberOfPerson = 0
        UILabel.numberOfLines = 0
        UILabel.text = "모집 인원"+String(numberOfPerson)
        UILabel.font = UIFont(name: "NotoSansKR-Regular", size: 14)
    })
    lazy var explainTitleLabel = UILabel().then({ UILabel in
        UILabel.text = "주제 설명"
        UILabel.font = UIFont(name: "NotoSansKR-Bold", size: 16)
    })
    lazy var explainLabel = UILabel().then({ UILabel in
        UILabel.text = "리액트를 사용하여 네이버의 로그인 기능을 구현합니다.\n프론트와 백엔드간의 데이터 통신에 대해 이해하고 소켓 프로그래밍 경험을 목표로 합니다."
        UILabel.numberOfLines = 0
        UILabel.font = UIFont(name: "NotoSansKR-Regular", size: 14)
        UILabel.sizeToFit()
    })
    lazy var periodTitleLabel = UILabel().then({ UILabel in
        UILabel.text = "프로젝트 기간"
        UILabel.font = UIFont(name: "NotoSansKR-Bold", size: 16)
    })
    lazy var periodLabel = UILabel().then({ UILabel in
        UILabel.text = "2021.11 ~ 2022.01"
        UILabel.numberOfLines = 0
        UILabel.font = UIFont(name: "NotoSansKR-Regular", size: 14)
        UILabel.sizeToFit()
    })
    lazy var optionTitleLabel = UILabel().then({ UILabel in
        UILabel.text = "모집 조건"
        UILabel.textColor = .black
        UILabel.font = UIFont(name: "NotoSansKR-Bold", size: 16)
    })
    lazy var optionLabel = UILabel().then({ UILabel in
        UILabel.text = "자바스크립트에 능숙한 분이면 좋습니다.\n 자바스크립트, 리액트 경험이 없어도 열심히 할 수 있는 분이면 좋습니다.\n백단과의 통신을 위해 백앤드 경험자 환영합니다."
        UILabel.numberOfLines = 0
        UILabel.font = UIFont(name: "NotoSansKR-Regular", size: 14)
        UILabel.sizeToFit()
    })
    
    lazy var proceedTitleLabel = UILabel().then { UILabel in
        UILabel.text = "프로젝트 진행 방식"
        UILabel.font = UIFont(name: "NotoSansKR-Bold", size: 16)
    }
    
    lazy var proceedLabel = UILabel().then { UILabel in
        UILabel.text = "주 1회 정해진 요일에 구글 미팅을 통해 회상 회의를 진행합니다.\n한달에 최소 1회는 오프라인 미팅을 합니다.\n장소는 인천, 안양, 건대, 구리 중 랜덤입니다"
        UILabel.numberOfLines = 0
        UILabel.font = UIFont(name: "NotoSansKR-Regular", size: 14)
        UILabel.sizeToFit()
    }
    
    lazy var detailTitleLabel = UILabel().then({ UILabel in
        UILabel.text = "프로젝트 상세 설명"
        UILabel.font = UIFont(name: "NotoSansKR-Bold", size: 16)
    })
    
    lazy var detailTextView = UITextView().then ({ UITextView in
        UITextView.text = "어쩌구 저쩌구"
        UITextView.textColor = .black
        UITextView.font = UIFont(name: "NotoSansKR-Regular", size: 14)
        UITextView.isEditable = false
//        UITextView.isSelectable = false
        UITextView.isUserInteractionEnabled = true
        UITextView.sizeToFit()
        UITextView.isScrollEnabled = false
        UITextView.delegate = self
        
    })
    lazy var footerView = UIView().then { UIView in
    }

    lazy var lineViewFirst = UIView().then({ UIView in
        UIView.backgroundColor = ColorPortfolian.gray2
    })

    lazy var lineViewSecond = UIView().then({ UIView in
        UIView.backgroundColor = ColorPortfolian.gray2
    })

    lazy var lineViewThird = UIView().then({ UIView in
        UIView.backgroundColor = ColorPortfolian.gray2
    })
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
        registrationType = .Writing
        let newProjectID = recruitWriting.newProjectID as String
        MyAlamofireManager.shared.getProject(projectID: newProjectID) { result in
            switch result {
            case .success(let projectInfo):
                
                print("view did load \(writingTeamTag.names)")
                self.titleLabel.text = projectInfo.title
                self.viewsLabel.text = "조회수 " + String(projectInfo.view)
                self.recruitLabel.text = "모집인원 " + String(projectInfo.capacity)
                self.explainLabel.text = projectInfo.contents.subjectDescription
                self.periodLabel.text = projectInfo.contents.projectTime
                self.optionLabel.text = projectInfo.contents.recruitmentCondition
                self.proceedLabel.text = projectInfo.contents.progress
                let md = SwiftyMarkdown(string: "\n" + projectInfo.contents.description)
                self.detailTextView.attributedText = md.attributedString()
                self.configureLabel(md: md)
                
            case .failure(let error):
//                self.view.makeToast(error.rawValue, duration: 5.0, position: .center)
                print("\(error)######")
            }
        }
        DispatchQueue.main.async {
            self.tagsCollectionView.reloadData()
            let height = self.tagsCollectionView.collectionViewLayout.collectionViewContentSize.height
            self.tagsCollectionView.snp.updateConstraints {
                $0.height.equalTo(height)
            }
        self.view.setNeedsLayout()
        }
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tagsCollectionView.isUserInteractionEnabled = false
        
        navigationItem.rightBarButtonItems = [shareBarButtonItem]
        view.addSubview(titleLabel)
        view.addSubview(viewsLabel)
        view.addSubview(scrollView)
        view.addSubview(tagsCollectionView)
        view.addSubview(leftUIView)
        view.addSubview(recruitLabel)
        view.addSubview(lineViewFirst)
        view.addSubview(lineViewSecond)
        view.addSubview(lineViewThird)
        view.addSubview(footerView)
        scrollView.addSubview(contentView)
        contentView.addSubview(explainTitleLabel)
        contentView.addSubview(periodTitleLabel)
        contentView.addSubview(optionTitleLabel)
        contentView.addSubview(proceedTitleLabel)
        contentView.addSubview(detailTitleLabel)
        contentView.addSubview(explainLabel)
        contentView.addSubview(periodLabel)
        contentView.addSubview(optionLabel)
        contentView.addSubview(proceedLabel)
        contentView.addSubview(detailTextView)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.trailing.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(60)
        }
        viewsLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom)
            make.leading.equalTo(titleLabel)
        }
        lineViewFirst.snp.makeConstraints { make in
            make.top.equalTo(viewsLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view).inset(10)
            make.height.equalTo(1)
        }
        tagsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(lineViewFirst.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).offset(10)
            make.height.equalTo(0)
        }
        leftUIView.snp.makeConstraints { make in
            make.top.equalTo(tagsCollectionView.snp.bottom).offset(10)
            make.leading.equalTo(lineViewFirst)
            make.width.equalTo(20)
        }
        
        recruitLabel.snp.makeConstraints { make in
            make.top.equalTo(tagsCollectionView.snp.bottom).offset(10)
            make.leading.equalTo(leftUIView.snp.trailing).offset(10)
            
        }
        lineViewSecond.snp.makeConstraints { make in
            make.top.equalTo(recruitLabel.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view).inset(10)
            make.height.equalTo(1)
        }

        scrollView.snp.makeConstraints { make in
            make.top.equalTo(lineViewSecond.snp.bottom)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(footerView.snp.top)
        }
        contentView.snp.makeConstraints { make in
            make.top.bottom.equalTo(scrollView)
            make.leading.trailing.equalTo(scrollView).inset(20)
            make.width.equalTo(scrollView).offset(-40)
        }
        explainTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(contentView)
            make.leading.equalTo(leftUIView)
        }
        
        explainLabel.snp.makeConstraints { make in
            make.top.equalTo(explainTitleLabel.snp.bottom)
            make.leading.trailing.equalTo(contentView)
        }
        
        periodTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(explainLabel.snp.bottom).offset(50)
            make.leading.equalTo(leftUIView)
        }
        
        periodLabel.snp.makeConstraints { make in
            make.top.equalTo(periodTitleLabel.snp.bottom)
            make.leading.trailing.equalTo(contentView)
        }
        optionTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(periodLabel.snp.bottom).offset(50)
            make.leading.equalTo(leftUIView)
        }
        optionLabel.snp.makeConstraints { make in
            make.top.equalTo(optionTitleLabel.snp.bottom)
            make.leading.trailing.equalTo(contentView)
        }
        proceedTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(optionLabel.snp.bottom).offset(50)
            make.leading.equalTo(leftUIView)
        }
        proceedLabel.snp.makeConstraints { make in
            make.top.equalTo(proceedTitleLabel.snp.bottom)
            make.leading.trailing.equalTo(contentView)
        }
        detailTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(proceedLabel.snp.bottom).offset(50)
            make.leading.equalTo(leftUIView)
        }
        detailTextView.snp.makeConstraints { make in
            make.top.equalTo(detailTitleLabel.snp.bottom)
            make.leading.trailing.equalTo(contentView)
//            make.height.equalTo(1000)
        }
        lineViewThird.snp.makeConstraints { make in
            make.top.equalTo(detailTextView.snp.bottom).offset(50)
            make.leading.trailing.equalTo(view).inset(10)
            make.height.equalTo(1)
            make.bottom.equalTo(contentView)
        }
        footerView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view).inset(10)
            make.height.equalTo(100)
            make.bottom.equalTo(view.snp.bottom)
        }
        // Do any additional setup after loading the view.
//        tagCollectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: identifier)
//        tagCollectionView.delegate = self
//        tagCollectionView.dataSource = self

        tagsCollectionView.register(TagCollectionViewCell.self, forCellWithReuseIdentifier: identifier)
        tagsCollectionView.delegate = self
        tagsCollectionView.dataSource = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
        writingTeamTag.names = []
    }
    @objc func buttonPressed(_ sender : UIButton){
        
    }
    
    private func configureLabel(md: SwiftyMarkdown) {
      guard let messageText = detailTextView.text else { return }
      let mutableString = NSMutableAttributedString()

      var urlAttributes: [NSMutableAttributedString.Key: Any] = [
        .foregroundColor: UIColor.systemBlue,
        .underlineStyle: NSUnderlineStyle.single.rawValue,
        .font: UIFont.italicSystemFont(ofSize: 16)
      ]
        
        // swiftyMarkdown
        let normalText = md.attributedString()
      mutableString.append(normalText)

      do {
        let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
        let matches = detector.matches(
          in: messageText,
          options: [],
          range: NSRange(location: 0, length: messageText.count)
        )

        for m in matches {
          if let url = m.url {
            urlAttributes[.link] = url
            mutableString.setAttributes(urlAttributes, range: m.range)
          }
        }
          detailTextView.attributedText = mutableString
      } catch {
        print(error)
      }
    }
}


extension WritingSaveViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(spacingRow) - 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(spacingColumn) - 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

            let tag = writingTeamTag.names[indexPath.row]
            let tagInfo = Tag.shared.getTagInfo(tag: tag)
            let tagName = tagInfo.name
            let label = TagButton().then {
                $0.informTextInfo(text: tagName, fontSize: 16)
                $0.sizeToFit()
            }
            let size = label.frame.size
            return CGSize(width: size.width, height: size.height)
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath)
        //        TagCOllectionViewCell에서 contentView.isUserInteractionEnabled = true 해주면 함수 동작함. 대신 색이 안 나옴.
    }
    
}

extension WritingSaveViewController: UICollectionViewDataSource {
    // 한 섹션에 몇개의 컬렉션 셀을 보여줄지
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return writingTeamTag.names.count
    }
    
    // 셀을 어떻게 보여줄지
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

            let cell = tagsCollectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! TagCollectionViewCell
            let tag = writingTeamTag.names[indexPath.row]
            let tagInfo = Tag.shared.getTagInfo(tag: tag)
            let tagName = tagInfo.name
            let tagColor = tagInfo.color
            cell.configure(tagName: tagName, tagColor: tagColor, index: tag.index)
            return cell
//        }
        
    }
    
    
}
extension WritingSaveViewController: UITextViewDelegate{
    // 입력된 포지션에 따라 라벨의 문자열의 인덱스 반환
    // - Parameter point: 인덱스 값을 알고 싶은 CGPoint
    // url 사파리로 이동
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return true
    }
}
