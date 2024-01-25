//
//  AlertService.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 12/21/23.
//

import UIKit

enum DeleteOption {
    case category
    case vocabulary
    case vocabularies
}

struct AlertService {
    
    private init() {}
    
    static func showToast(in vc: UIViewController, toastView: UIView) {
        vc.view.addSubview(toastView)
        
        NSLayoutConstraint.activate([
            toastView.topAnchor.constraint(equalTo: vc.view.safeAreaLayoutGuide.topAnchor),
            toastView.leadingAnchor.constraint(equalToSystemSpacingAfter: vc.view.leadingAnchor, multiplier: 1),
            vc.view.trailingAnchor.constraint(equalToSystemSpacingAfter: toastView.trailingAnchor, multiplier: 1),
            toastView.centerXAnchor.constraint(equalTo: vc.view.centerXAnchor),
            toastView.heightAnchor.constraint(equalToConstant: 30)
        ])
            
        UIView.animate(withDuration: 1, delay: 1, options: .curveEaseOut, animations: {
            toastView.alpha = 0.0
        }, completion: {(isCompleted) in
            toastView.removeFromSuperview()
        })
    }
    
    static func deleteAlert(deleteOption: DeleteOption, deleteActionHandler: @escaping (UIAlertAction) -> Void) -> UIAlertController {
        var title: String?
        var message: String?
        
        switch deleteOption {
        case .category:
            title = "정말 삭제할까요?"
            message = "카테고리에 저장된 모든 단어가 삭제되고 복구할 수 없습니다."
        case .vocabulary:
            title = nil
            message = nil
        case .vocabularies:
            title = "선택한 모든 단어가 삭제됩니다."
            message = nil
        }
        
        let deleteAlert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive, handler: deleteActionHandler)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        deleteAlert.addAction(deleteAction)
        deleteAlert.addAction(cancelAction)
        
        return deleteAlert
    }
    
    static func checkAlert(checkActionHandler: @escaping (UIAlertAction) -> Void, unCheckActionHandler:  @escaping (UIAlertAction) -> Void) -> UIAlertController {
        let checkAlert = UIAlertController(title: "체크 옵션을 선택하세요.", message: "선택한 모든 단어에 적용됩니다.", preferredStyle: .actionSheet)
        let checkAction = UIAlertAction(title: "체크하기", style: .default, handler: checkActionHandler)
        let unCheckAction = UIAlertAction(title: "체크 해제하기", style: .default, handler: unCheckActionHandler)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        checkAlert.addAction(checkAction)
        checkAlert.addAction(unCheckAction)
        checkAlert.addAction(cancelAction)
        
        return checkAlert
    }
}
