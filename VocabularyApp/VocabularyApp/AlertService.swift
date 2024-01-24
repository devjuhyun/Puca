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
        var message: String
        
        switch deleteOption {
        case .category:
            message = "카테고리와 카테고리에 포함된 단어가 영원히 삭제되고 복구할 수 없어요."
        case .vocabulary:
            message = ""
        case .vocabularies:
            message = "선택되어 있는 모든 단어가 삭제됩니다."
        }
        
        let deleteAlert = UIAlertController(title: "정말 삭제할까요?", message: message, preferredStyle: .alert)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive, handler: deleteActionHandler)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        deleteAlert.addAction(deleteAction)
        deleteAlert.addAction(cancelAction)
        
        return deleteAlert
    }
}
