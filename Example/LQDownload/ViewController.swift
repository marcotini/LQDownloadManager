//
//  ViewController.swift
//  LQDownload
//
//  Created by 杨卢青 on 2017/1/6.
//  Copyright © 2017年 杨卢青. All rights reserved.
//

import UIKit
import LQDownloadManager

class ViewController: UIViewController {
    
    // 进度条
    fileprivate lazy var progressView: UIProgressView = {
        let screen = UIScreen.main.bounds
        let rect = CGRect(x: 0, y: screen.height/2, width: screen.width, height: 2)
        let progressView = UIProgressView(frame: rect)
        
        progressView.trackTintColor = UIColor.gray
        progressView.progressTintColor = UIColor.cyan
        return progressView
    }()
    
    // 下载按钮
    fileprivate lazy var downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("start download", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 16
        button.frame.size = CGSize(width: 200, height: 40)
        let screen = UIScreen.main.bounds
        button.center = CGPoint(x: screen.width/2, y: screen.height/2 - 80)
        button.addTarget(self, action: #selector(downloadButtonAction), for: .touchUpInside)
        return button
    }()
    
    // 删除按钮
    fileprivate lazy var cancelButton: UIButton = {
        let button = UIButton()
        button.setTitle("cancel download", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.borderColor = UIColor.black.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 16
        button.frame.size = CGSize(width: 200, height: 40)
        let screen = UIScreen.main.bounds
        button.center = CGPoint(x: screen.width/2, y: screen.height/2 + 80)
        button.addTarget(self, action: #selector(cancelButtonAction), for: .touchUpInside)
        return button
    }()
    
    
    
    let urlString = "https://developer.apple.com/accessories/Accessory-Design-Guidelines.pdf"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(progressView)
        view.addSubview(downloadButton)
        view.addSubview(cancelButton)
        
        debugPrint("\(LQDownloadManager.shared.downloadDirectory())")
    }
    
}

extension ViewController {
    @objc func cancelButtonAction() {
        LQDownloadManager.shared.cancelDownload(urlString)
        downloadButton.setTitle("start download", for: .normal)
        progressView.setProgress(0, animated: true)
    }
    
    @objc func downloadButtonAction() {
        LQDownloadManager.shared.download("https://developer.apple.com/accessories/Accessory-Design-Guidelines.pdf", progress: { progress in
            print("progress: \(progress)")
            self.progressView.progress = Float(progress)
        }) { status in
            switch status {
            case .start:
                print("start")
                self.downloadButton.setTitle("pause download", for: .normal)
            case .suspend:
                print("suspend")
                self.downloadButton.setTitle("start download", for: .normal)
            case .complete:
                print("complete")
                self.downloadButton.setTitle("download completed", for: .normal)
            case .failed:
                print("failed")
                self.downloadButton.setTitle("download again", for: .normal)
            }
        }
    }
}
