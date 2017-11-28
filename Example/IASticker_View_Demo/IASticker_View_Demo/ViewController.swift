//
//  ViewController.swift
//  IASticker_View_Demo
//
//  Created by Md Abu Sufian on 28/11/17.
//  Copyright © 2017 Md Abu Sufian. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func addSticker(_ sender: Any) {
        let size = view.frame.size
        let stickerView = IAStickerView(frame: CGRect(x: size.width / 2 - 50, y: size.height / 2 - 50, width: 100, height: 100))
        let imageView = UIImageView(frame: stickerView.bounds)
        imageView.image = UIImage(named: "emoji_1")
        stickerView.contentView = imageView
        view.addSubview(stickerView)
    }
    

}

