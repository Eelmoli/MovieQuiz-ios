//
//  AlertPresenterDelegate.swift
//  MovieQuiz
//
//  Created by Сергей Кобылянский on 15.06.2023.
//

import Foundation
import UIKit

protocol AlertPresenterDelegate: AnyObject {
    func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?)
}
        
