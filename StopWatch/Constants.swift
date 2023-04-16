//
//  Constants.swift
//  StopWatch
//
//  Created by poskreepta on 14.04.23.
//

import UIKit

struct Const {
    static let stopButtonImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "stop.circle.fill")
        return imageView
    }()
    
    static let pauseButtonImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "pause.circle.fill")
        return imageView
    }()
    
    static let startButtonImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "play.circle.fill")
        return imageView
    }()
    
    static let stopButtonTappedImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "stop.circle")
        return imageView
    }()
    
    static let pauseButtonTappedImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "pause.circle")
        return imageView
    }()
    
    static let startButtonTapeedImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "play.circle")
        return imageView
    }()
    
}
  
 
