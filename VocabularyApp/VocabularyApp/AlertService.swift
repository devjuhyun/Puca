//
//  AlertService.swift
//  VocabularyApp
//
//  Created by Juhyun Yun on 12/21/23.
//

import UIKit

struct AlertService {
    
    private init() {}
    
    static func showToast(in vc: UIViewController, message: String, color: UIColor, imageName: String) {
        let toastView = UIView()
        toastView.translatesAutoresizingMaskIntoConstraints = false
        toastView.backgroundColor = color
        toastView.layer.cornerRadius = 5
        toastView.clipsToBounds = true
        
        let toastImageView = UIImageView(image: UIImage(systemName: imageName)?.withTintColor(.white, renderingMode: .alwaysOriginal))
        toastImageView.translatesAutoresizingMaskIntoConstraints = false
        let toastLabel = UILabel()
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastLabel.textColor = .white
        toastLabel.font = .boldSystemFont(ofSize: 14)
        toastLabel.textAlignment = .left
        toastLabel.text = message
        
        toastView.addSubview(toastImageView)
        toastView.addSubview(toastLabel)
        vc.view.addSubview(toastView)
        
        NSLayoutConstraint.activate([
            toastImageView.leadingAnchor.constraint(equalToSystemSpacingAfter: toastView.leadingAnchor, multiplier: 1),
            toastImageView.centerYAnchor.constraint(equalTo: toastView.centerYAnchor),
            
            toastLabel.leadingAnchor.constraint(equalToSystemSpacingAfter: toastImageView.trailingAnchor, multiplier: 1),
            toastLabel.centerYAnchor.constraint(equalTo: toastImageView.centerYAnchor),
            
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
