import Foundation
import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func didRecieveAlertController(alertController: UIAlertController?)
}
