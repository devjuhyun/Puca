//
//  AlertService.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 12/21/23.
//

import UIKit

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
    
    static func deleteAlert(deleteActionHandler: @escaping (UIAlertAction) -> Void) -> UIAlertController {
        let deleteAlert = UIAlertController(title: "정말 삭제하시겠습니까?", message: "모두 삭제됩니다.", preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "삭제", style: .destructive, handler: deleteActionHandler)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        deleteAlert.addAction(deleteAction)
        deleteAlert.addAction(cancelAction)
        
        return deleteAlert
    }
}
