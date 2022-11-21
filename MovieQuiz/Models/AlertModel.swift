//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Максим Фасхетдинов on 10.11.2022.
//

import Foundation
import UIKit

struct AlertModel {
    let title: String
    let message: String
    let buttonText: String
    let completion: (UIAlertAction) -> Void
}
