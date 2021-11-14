//
//  WritingViewController.swift
//  Portfolian
//
//  Created by 이상현 on 2021/10/29.
//

import UIKit
import SnapKit
import Then

class WritingViewController: UIViewController {
    lazy var scrollView = UIScrollView()

    lazy var contentView = UIView()

    lazy var saveBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(buttonPressed))
       

    lazy var titleTextField = UITextField().then({ UITextField in
        UITextField.placeholder = "제목을 입력하세요."
        UITextField.font = UIFont(name: "NotoSansKR-Bold", size: 24)
    })
    lazy var configuration: UIButton.Configuration = {
        var configuration = UIButton.Configuration.plain()
        let title = "사용 기술을 선택해주세요. (최대 7개)"
        let icon = UIImage(systemName: "chevron.right")
        configuration.title = title
        configuration.image = icon
//        configuration.imagePadding = 30
        configuration.imagePlacement = .trailing
        configuration.baseForegroundColor = .black
        configuration.buttonSize = .medium
        configuration.baseBackgroundColor = .white
        return configuration
    }()
    
    lazy var stackButton = UIButton(configuration: configuration, primaryAction: nil).then { UIButton in
            UIButton.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
    }
    
    lazy var leftUIView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 30)).then({ UIView in
        let icon = UIImage(named: "AddUser")
        var iconView = UIImageView(image: icon)
        iconView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        UIView.addSubview(iconView)
        UIView.contentMode = .bottom
    })
    
    lazy var recruitTextField = UITextField().then({ UITextField in
        UITextField.placeholder = "모집 인원"
        UITextField.leftView = leftUIView
        UITextField.leftViewMode = .always
        UITextField.font = UIFont(name: "NotoSansKR-Bold", size: 18)
    })
    
    lazy var periodTextView = UITextView().then({ UITextView in
        UITextView.text = "예시: 3개월, 2021.09 ~ 2021.11"
        UITextView.textColor = ColorPortfolian.gray2
        UITextView.textContainer.maximumNumberOfLines = 2
        UITextView.font = UIFont(name: "NotoSansKR-Bold", size: 16)
    })
    
    lazy var explainTextView = UITextView().then({ UITextView in
        UITextView.text = "프로젝트에 대한 간단한 설명을 적어주세요."
        UITextView.textColor = ColorPortfolian.gray2
        UITextView.textContainer.maximumNumberOfLines = 5
        UITextView.font = UIFont(name: "NotoSansKR-Bold", size: 16)
    })
    
    lazy var optionTextView = UITextView().then({ UITextView in
        UITextView.text = "프로젝트에 필요한 기술 역량에 대해 알려주세요"
        UITextView.textColor = ColorPortfolian.gray2
        UITextView.textContainer.maximumNumberOfLines = 5
        UITextView.font = UIFont(name: "NotoSansKR-Bold", size: 16)
    })
    
    lazy var proceedTextView = UITextView().then({ UITextView in
        UITextView.text = "예시: 매주 화요일 강남역에서 오프라인으로 진행합니다."
        UITextView.textColor = ColorPortfolian.gray2
        UITextView.textContainer.maximumNumberOfLines = 5
        UITextView.font = UIFont(name: "NotoSansKR-Bold", size: 16)
    })
    
    lazy var detailTextView = UITextView().then({ UITextView in
        UITextView.text = "프로젝트에 대한 설명을 자유롭게 적어주세요 :)"
        UITextView.textColor = ColorPortfolian.gray2
        UITextView.textContainer.maximumNumberOfLines = 15
        UITextView.font = UIFont(name: "NotoSansKR-Bold", size: 16)
    })
    
    lazy var periodLabel = UILabel().then { UILabel in
        UILabel.text = "프로젝트 기간"
        UILabel.font = UIFont(name: "NotoSansKR-Bold", size: 18)
    }
    
    lazy var recruitLabel = UILabel().then { UILabel in
        UILabel.text = "명 (최대 16명)"
        UILabel.font = UIFont(name: "NotoSansKR-Bold", size: 18)
    }
    
    lazy var explainLabel = UILabel().then { UILabel in
        UILabel.text = "프로젝트 주제 설명"
        UILabel.font = UIFont(name: "NotoSansKR-Bold", size: 18)
    }
    
    lazy var optionLabel = UILabel().then { UILabel in
        UILabel.text = "모집 조건"
        UILabel.font = UIFont(name: "NotoSansKR-Bold", size: 18)
    }
    
    lazy var proceedLabel = UILabel().then { UILabel in
        UILabel.text = "프로젝트 진행 방식"
        UILabel.font = UIFont(name: "NotoSansKR-Bold", size: 18)
    }
    
    lazy var detailLabel = UILabel().then { UILabel in
        UILabel.text = "프로젝트 상세 설명"
        UILabel.font = UIFont(name: "NotoSansKR-Bold", size: 18)
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
    
    lazy var lineViewFourth = UIView().then({ UIView in
        UIView.backgroundColor = ColorPortfolian.gray2
    })
    
    lazy var lineViewFifth = UIView().then({ UIView in
        UIView.backgroundColor = ColorPortfolian.gray2
    })
    
    lazy var lineViewSixth = UIView().then({ UIView in
        UIView.backgroundColor = ColorPortfolian.gray2
    })
    
    lazy var lineViewSeventh = UIView().then({ UIView in
        UIView.backgroundColor = ColorPortfolian.gray2
    })
    
    lazy var lineViewEight = UIView().then({ UIView in
        UIView.backgroundColor = ColorPortfolian.gray2
    })
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.prefersLargeTitles = false
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "글쓰기"
        navigationItem.rightBarButtonItem = saveBarButtonItem
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        contentView.addSubview(titleTextField)
        contentView.addSubview(lineViewFirst)
        contentView.addSubview(lineViewSecond)
        contentView.addSubview(lineViewThird)
        contentView.addSubview(lineViewFourth)
        contentView.addSubview(lineViewFifth)
        contentView.addSubview(lineViewSixth)
        contentView.addSubview(lineViewSeventh)
        contentView.addSubview(lineViewEight)
        contentView.addSubview(stackButton)
        contentView.addSubview(recruitTextField)
        contentView.addSubview(recruitLabel)
        contentView.addSubview(periodLabel)
        contentView.addSubview(explainLabel)
        contentView.addSubview(optionLabel)
        contentView.addSubview(proceedLabel)
        contentView.addSubview(detailLabel)
        contentView.addSubview(periodTextView)
        contentView.addSubview(explainTextView)
        contentView.addSubview(optionTextView)
        contentView.addSubview(proceedTextView)
        contentView.addSubview(detailTextView)
//        scrollView.backgroundColor = .blue
//        contentView.backgroundColor = .yellow
        
        periodTextView.delegate = self
        explainTextView.delegate = self
        optionTextView.delegate = self
        proceedTextView.delegate = self
        detailTextView.delegate = self
        
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        
        contentView.snp.makeConstraints { make in
            make.top.bottom.equalTo(scrollView)
            make.leading.trailing.equalTo(scrollView).inset(20)
            make.width.equalTo(scrollView).offset(-40)
        }
       
        titleTextField.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(5)
            make.leading.equalTo(contentView).offset(10)
        }
        
        lineViewFirst.snp.makeConstraints { make in
            make.top.equalTo(titleTextField.snp.bottom).offset(10)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(1)
        }
        
        stackButton.snp.makeConstraints { make in
            make.top.equalTo(lineViewFirst).offset(10)
            make.leading.equalTo(lineViewFirst)
        }
        
        lineViewSecond.snp.makeConstraints { make in
            make.top.equalTo(stackButton.snp.bottom).offset(10)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(1)
        }
        
        recruitTextField.snp.makeConstraints { make in
            make.top.equalTo(lineViewSecond).offset(10)
            make.leading.equalTo(titleTextField)
        }
        
        recruitLabel.snp.makeConstraints { make in
            make.centerY.equalTo(recruitTextField)
            make.leading.equalTo(recruitTextField.snp.trailing).offset(10)
        }
        
        lineViewThird.snp.makeConstraints { make in
            make.top.equalTo(recruitTextField.snp.bottom).offset(10)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(1)
        }
        
        periodLabel.snp.makeConstraints { make in
            make.top.equalTo(lineViewThird).offset(10)
            make.leading.equalTo(titleTextField)
        }
        
        periodTextView.snp.makeConstraints { make in
            make.top.equalTo(periodLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(100)
        }
        
        lineViewFourth.snp.makeConstraints { make in
            make.top.equalTo(periodTextView.snp.bottom).offset(10)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(1)
        }
        
        explainLabel.snp.makeConstraints { make in
            make.top.equalTo(lineViewFourth).offset(10)
            make.leading.equalTo(titleTextField)
        }
        
        explainTextView.snp.makeConstraints { make in
            make.top.equalTo(explainLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(100)
        }
        
        lineViewFifth.snp.makeConstraints { make in
            make.top.equalTo(explainTextView.snp.bottom).offset(10)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(1)
        }
        
        optionLabel.snp.makeConstraints { make in
            make.top.equalTo(lineViewFifth).offset(10)
            make.leading.equalTo(titleTextField)
        }
        
        optionTextView.snp.makeConstraints { make in
            make.top.equalTo(optionLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(100)
        }
        
        lineViewSixth.snp.makeConstraints { make in
            make.top.equalTo(optionTextView.snp.bottom).offset(10)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(1)
        }
        
        proceedLabel.snp.makeConstraints { make in
            make.top.equalTo(lineViewSixth).offset(10)
            make.leading.equalTo(titleTextField)
        }
        
        proceedTextView.snp.makeConstraints { make in
            make.top.equalTo(proceedLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(100)
        }
        
        lineViewSeventh.snp.makeConstraints { make in
            make.top.equalTo(proceedTextView.snp.bottom).offset(10)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(1)
        }
        
        detailLabel.snp.makeConstraints { make in
            make.top.equalTo(lineViewSeventh).offset(10)
            make.leading.equalTo(titleTextField)
        }
        
        detailTextView.snp.makeConstraints { make in
            make.top.equalTo(detailLabel.snp.bottom).offset(5)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(300)
        }
        
        lineViewEight.snp.makeConstraints { make in
            make.top.equalTo(detailTextView.snp.bottom).offset(10)
            make.leading.trailing.equalTo(contentView)
            make.height.equalTo(1)
            make.bottom.equalTo(contentView.snp.bottom).inset(300)
            
        }
        
        
        
        
        
    }

    // MARK: - Navigation
    @objc private func buttonPressed(_ sender: UIButton) {
        let FilterVC = UIStoryboard(name: "Filter", bundle: nil).instantiateViewController(withIdentifier: "FilterVC")
        FilterVC.modalPresentationStyle = .fullScreen
        registrationType = .Writing
        self.navigationController?.pushViewController(FilterVC, animated: true)
    }


}

extension WritingViewController: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == ColorPortfolian.gray2{
            textView.text = ""
            textView.textColor = .black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""{
            switch textView {
            case periodTextView:
                textView.text = "예시: 3개월, 2021.09 ~ 2021.11"
            case explainTextView:
                textView.text = "프로젝트에 대한 간단한 설명을 적어주세요."
            case optionTextView:
                textView.text = "프로젝트에 필요한 기술 역량에 대해 알려주세요"
            case proceedTextView:
                textView.text = "예시: 매주 화요일 강남역에서 오프라인으로 진행합니다."
            default:
                textView.text = "프로젝트에 대한 설명을 자유롭게 적어주세요 :)"
            }
            textView.textColor = ColorPortfolian.gray2
        }
    }
}

