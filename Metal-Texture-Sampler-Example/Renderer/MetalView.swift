//
//  MetalView.swift
//  Metal-Texture-Sampler-Example
//
//  Created by Nilupul Sandeepa on 2021-04-09.
//

import MetalKit

/**
 The MetalView sub class of MTKView provides a default implementation of a Metal-aware view that you can use to render graphics using Metal and display them onscreen
 */
public class MetalView: MTKView {
    
    //Renderer has methods for responding to a MetalKit view's drawing and resizing events.
    private var renderer: Renderer!
    
    init(frame: CGRect) {
        super.init(frame: frame, device: nil)
        self.configureMetalView()
    }
    
    private func configureMetalView() {
        guard let mtlDevice = MTLCreateSystemDefaultDevice() else {
            fatalError("Metal is not supported by the device")
        }
        
        self.device = mtlDevice
        self.clearColor = MTLClearColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.renderer = Renderer(withDevice: self.device!)
        self.delegate = self.renderer
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func changeSamplerType(to type: SamplerType) {
        self.renderer.changeSamplerType(to: type)
    }
}

