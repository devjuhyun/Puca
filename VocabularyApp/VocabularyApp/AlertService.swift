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
            title = "Are you sure you want to delete this category?"
            message = "All words in this category will be permanently deleted."
        case .vocabulary:
            title = nil
            message = nil
        case .vocabularies:
            title = "All words selected will be permanently deleted."
            message = nil
        }
        
        let deleteAlert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: deleteActionHandler)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        deleteAlert.addAction(deleteAction)
        deleteAlert.addAction(cancelAction)
        
        return deleteAlert
    }
    
    static func checkAlert(checkActionHandler: @escaping (UIAlertAction) -> Void, unCheckActionHandler:  @escaping (UIAlertAction) -> Void) -> UIAlertController {
        let checkAlert = UIAlertController(title: "Please select one.", message: "It will apply to all words selected.", preferredStyle: .actionSheet)
        let checkAction = UIAlertAction(title: "Check", style: .default, handler: checkActionHandler)
        let unCheckAction = UIAlertAction(title: "Uncheck", style: .default, handler: unCheckActionHandler)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        checkAlert.addAction(checkAction)
        checkAlert.addAction(unCheckAction)
        checkAlert.addAction(cancelAction)
        
        return checkAlert
    }
    
    static func playHaptics() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
}
