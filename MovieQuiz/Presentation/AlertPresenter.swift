//
//  AlertPresenter.swift
//  MovieQuiz
//
//  Created by Максим Фасхетдинов on 10.11.2022.
//

import Foundation
import UIKit

struct AlertPresenter: AlertPresenterProtocol {
    
    private weak var delegate: AlertPresenterDelegate?
    
    init(delegate: AlertPresenterDelegate) {
        self.delegate = delegate
    }
    
    func showAlert(alertModel: AlertModel?) {
        let alertController = UIAlertController(
            title: alertModel?.title,
            message: alertModel?.message,
            preferredStyle: .alert)
        
        let action = UIAlertAction(title: alertModel?.buttonText, style: .default, handler: alertModel?.completion)
        
        alertController.addAction(action)
                
        delegate?.didRecieveAlertController(alertController: alertController)
        
    }
}
