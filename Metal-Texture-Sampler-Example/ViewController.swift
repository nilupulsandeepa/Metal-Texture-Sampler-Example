//
//  ViewController.swift
//  Metal-Texture-Sampler-Example
//
//  Created by Nilupul Sandeepa on 2021-04-09.
//

import UIKit

class ViewController: UIViewController {
    
    private var metalView: MetalView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Attach Metal View
        self.metalView = MetalView(frame: self.view.frame)
        self.view.addSubview(metalView)
        
        let clampToEdgeButton: UIButton = UIButton()
        clampToEdgeButton.setTitle("Clamp to edge", for: .normal)
        clampToEdgeButton.backgroundColor = UIColor.red
        clampToEdgeButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(clampToEdgeButton)
        clampToEdgeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.clampToEdge)))
        
        self.view.addConstraint(NSLayoutConstraint(item: clampToEdgeButton, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.25, constant: 0.0))
        self.view.addConstraint(NSLayoutConstraint(item: clampToEdgeButton, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.08, constant: 0.0))
        self.view.addConstraint(NSLayoutConstraint(item: clampToEdgeButton, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        self.view.addConstraint(NSLayoutConstraint(item: clampToEdgeButton, attribute: .left, relatedBy: .equal, toItem: self.view, attribute: .left, multiplier: 1.0, constant: 0.0))
        
        let clampToZeroButton: UIButton = UIButton()
        clampToZeroButton.setTitle("Clamp to zero", for: .normal)
        clampToZeroButton.backgroundColor = UIColor.blue
        clampToZeroButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(clampToZeroButton)
        clampToZeroButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.clampToZero)))
        
        self.view.addConstraint(NSLayoutConstraint(item: clampToZeroButton, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.25, constant: 0.0))
        self.view.addConstraint(NSLayoutConstraint(item: clampToZeroButton, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.08, constant: 0.0))
        self.view.addConstraint(NSLayoutConstraint(item: clampToZeroButton, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        self.view.addConstraint(NSLayoutConstraint(item: clampToZeroButton, attribute: .left, relatedBy: .equal, toItem: clampToEdgeButton, attribute: .right, multiplier: 1.0, constant: 0.0))
        
        let repeatButton: UIButton = UIButton()
        repeatButton.setTitle("Repeat", for: .normal)
        repeatButton.backgroundColor = UIColor.black
        repeatButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(repeatButton)
        repeatButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.texRepeat)))
        
        self.view.addConstraint(NSLayoutConstraint(item: repeatButton, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.25, constant: 0.0))
        self.view.addConstraint(NSLayoutConstraint(item: repeatButton, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.08, constant: 0.0))
        self.view.addConstraint(NSLayoutConstraint(item: repeatButton, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        self.view.addConstraint(NSLayoutConstraint(item: repeatButton, attribute: .left, relatedBy: .equal, toItem: clampToZeroButton, attribute: .right, multiplier: 1.0, constant: 0.0))
        
        let mirrorRepeatButton: UIButton = UIButton()
        mirrorRepeatButton.setTitle("Mirror Repeat", for: .normal)
        mirrorRepeatButton.backgroundColor = UIColor.orange
        mirrorRepeatButton.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(mirrorRepeatButton)
        mirrorRepeatButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.texMirrorRepeat)))
        
        self.view.addConstraint(NSLayoutConstraint(item: mirrorRepeatButton, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.25, constant: 0.0))
        self.view.addConstraint(NSLayoutConstraint(item: mirrorRepeatButton, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.08, constant: 0.0))
        self.view.addConstraint(NSLayoutConstraint(item: mirrorRepeatButton, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1.0, constant: 0.0))
        self.view.addConstraint(NSLayoutConstraint(item: mirrorRepeatButton, attribute: .right, relatedBy: .equal, toItem: self.view, attribute: .right, multiplier: 1.0, constant: 0.0))
    }

    @objc func clampToEdge() {
        self.metalView.changeSamplerType(to: .ClampToEdge)
    }
    
    @objc func clampToZero() {
        self.metalView.changeSamplerType(to: .ClampToZero)
    }
    
    @objc func texRepeat() {
        self.metalView.changeSamplerType(to: .Repeat)
    }
    
    @objc func texMirrorRepeat() {
        self.metalView.changeSamplerType(to: .MirrorRepeat)
    }
}

