//
//  Storyboarded.swift
//  TOG-Test
//
//  Created by Yudha on 16/03/21.
//

import Foundation
import UIKit

//Feel free to add more storyboard names if using multiple storyboard
enum StoryboardNames: String {
    case main = "Main"
}

protocol Storyboarded {
    static func instantiate(storyboardName: StoryboardNames) -> Self
}

extension Storyboarded where Self: UIViewController {
    static func instantiate(storyboardName: StoryboardNames) -> Self {
        // this pulls out "MyApp.MyViewController"
        let fullName = NSStringFromClass(self)

        // this splits by the dot and uses everything after, giving "MyViewController"
        let className = fullName.components(separatedBy: ".")[1]

        // load our storyboard
        var storyboard = UIStoryboard()
        
        switch storyboardName {
        case .main:
            storyboard = UIStoryboard(name: StoryboardNames.main.rawValue, bundle: Bundle.main)
        }

        // instantiate a view controller with that identifier, and force cast as the type that was requested
        return storyboard.instantiateViewController(withIdentifier: className) as! Self
    }
}
