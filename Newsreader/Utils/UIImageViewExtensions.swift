//
//  UIImageViewHelper.swift
//  Newsreader_560825
//
//  Created by Geoffrey Arkenbout on 10/12/17.
//  Copyright © 2017 Geoffrey Arkenbout. All rights reserved.
//

import Foundation
import UIKit

extension UIImageView {
    public func loadImageAsync(from: String) -> URLSessionTask? {
        DispatchQueue.main.async {
            self.image = UIImage(named: "placeholder")
        }
        
        // image handling
        // succes closure
        let succes = { (_ data: Data) in
            // Call ui view
            DispatchQueue.main.async {
                self.image = UIImage(data: data)
            }
        }
        
        // failure closure
        let failure = {
            // Call ui view
            DispatchQueue.main.async {
                self.image = UIImage(named: "broken_image")
            }
        }
        
        if let url = URL(string: from) {
            // call async
            return WebClient.send(withUrl: url, onSucces: succes, onFailure: failure)
        } else {
            failure()
        }
        return nil
    }
    
}
