//
//  AlertPresenterDelegate.swift
//  MovieQuiz
//
//  Created by Максим Фасхетдинов on 10.11.2022.
//

import Foundation
import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func didRecieveAlertController(alertController: UIAlertController?)
}
