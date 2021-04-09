//
//  TextureQuad.swift
//  Metal-Texture-Sampler-Example
//
//  Created by Nilupul Sandeepa on 2021-04-09.
//

import MetalKit

public class TextureQuad {
    
    private var mtlDevice: MTLDevice!
    /**
     rectangle vertices converted to normalized device coordinates
     https://developer.apple.com/documentation/metal/using_a_render_pipeline_to_render_primitives
    */
    private var rectangleVertexData: [Float2] = [
        Float2(x: -0.5, y: 0.5),
        Float2(x: -0.5, y: -0.5),
        Float2(x: 0.5, y: -0.5),
        Float2(x: 0.5, y: 0.5)
    ]
    
    /**
     Order of vertices
     */
    private var rectangleIndexData: [UInt16] = [
        0, 1, 2,
        0, 2, 3
    ]
    
    //Play with these numbers to have an idea
    let numberOfXRepeats: Float = 2
    let numberOfYRepeats: Float = 2
    /**
     Texture coordinates
     */
    private var textureCoodsData: [Float2] = []
    
    /**
     MTLBuffers for vertex and index data
     */
    private var rectangleVertexBuffer: MTLBuffer!
    private var rectangleIndexBuffer: MTLBuffer!
    private var rectangleTextureCoordBuffer: MTLBuffer!
    
    private var rectangleTexture: MTLTexture!
    
    private var textureSampler1: MTLSamplerState!
    private var textureSampler2: MTLSamplerState!
    private var textureSampler3: MTLSamplerState!
    private var textureSampler4: MTLSamplerState!
    
    private var samplerType: SamplerType = .ClampToEdge
    
    /**
     The MTLRenderPipelineDescriptor object specifies the rendering configuration state used during a rendering pass, including rasterization (such as multisampling), visibility, blending, tessellation, and graphics function state. Use standard allocation and initialization techniques to create a MTLRenderPipelineDescriptor object. A MTLRenderPipelineDescriptor object is later used to create a MTLRenderPipelineState object
     */
    public var renderPipelineState: MTLRenderPipelineState!
    
    init(withDevice device: MTLDevice) {
        self.mtlDevice = device
        
        self.textureCoodsData = [
            Float2(x: 0, y: 0),
            Float2(x: 0, y: self.numberOfYRepeats),
            Float2(x: self.numberOfXRepeats, y: self.numberOfYRepeats),
            Float2(x: self.numberOfXRepeats, y: 0)
        ]
        
        self.rectangleVertexBuffer = self.mtlDevice.makeBuffer(bytes: self.rectangleVertexData, length: MemoryLayout<Float2>.stride * self.rectangleVertexData.count, options: [.storageModeShared])
        self.rectangleIndexBuffer = self.mtlDevice.makeBuffer(bytes: self.rectangleIndexData, length: MemoryLayout<UInt16>.stride * self.rectangleIndexData.count, options: [.storageModeShared])
        self.rectangleTextureCoordBuffer = self.mtlDevice.makeBuffer(bytes: self.textureCoodsData, length: MemoryLayout<Float2>.stride * self.textureCoodsData.count, options: [.storageModeShared])
        
        //Loading texture as MTLTexture
        let textureImage: UIImage = UIImage(named: "texture.jpg")!
        let textureLoader: MTKTextureLoader = MTKTextureLoader(device: self.mtlDevice)
        self.rectangleTexture = try! textureLoader.newTexture(cgImage: textureImage.cgImage!, options: [:])
        
        let library: MTLLibrary = self.mtlDevice.makeDefaultLibrary()!
        
        let vertexFunction: MTLFunction = library.makeFunction(name: "vertexFunction")!
        let fragmentFunction: MTLFunction = library.makeFunction(name: "fragmentFunction")!
        
        let renderPipelineDescriptor: MTLRenderPipelineDescriptor = MTLRenderPipelineDescriptor()
        renderPipelineDescriptor.vertexFunction = vertexFunction
        renderPipelineDescriptor.fragmentFunction = fragmentFunction
        renderPipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        renderPipelineDescriptor.colorAttachments[0].isBlendingEnabled = true
        renderPipelineDescriptor.colorAttachments[0].alphaBlendOperation = .add
        renderPipelineDescriptor.colorAttachments[0].rgbBlendOperation = .add
        renderPipelineDescriptor.colorAttachments[0].sourceRGBBlendFactor = .sourceAlpha
        renderPipelineDescriptor.colorAttachments[0].sourceAlphaBlendFactor = .one
        renderPipelineDescriptor.colorAttachments[0].destinationRGBBlendFactor = .oneMinusSourceAlpha
        renderPipelineDescriptor.colorAttachments[0].destinationAlphaBlendFactor = .oneMinusSourceAlpha
        
        do {
            self.renderPipelineState = try self.mtlDevice.makeRenderPipelineState(descriptor: renderPipelineDescriptor)
        } catch {
            fatalError()
        }
        
        let samplerDescriptor1: MTLSamplerDescriptor = MTLSamplerDescriptor()
        samplerDescriptor1.minFilter = .linear
        samplerDescriptor1.magFilter = .linear
        samplerDescriptor1.mipFilter = .notMipmapped
        samplerDescriptor1.sAddressMode = .clampToEdge
        samplerDescriptor1.tAddressMode = .clampToEdge
        self.textureSampler1 = self.mtlDevice.makeSamplerState(descriptor: samplerDescriptor1)
        
        let samplerDescriptor2: MTLSamplerDescriptor = MTLSamplerDescriptor()
        samplerDescriptor2.minFilter = .linear
        samplerDescriptor2.magFilter = .linear
        samplerDescriptor2.mipFilter = .notMipmapped
        samplerDescriptor2.sAddressMode = .clampToZero
        samplerDescriptor2.tAddressMode = .clampToZero
        self.textureSampler2 = self.mtlDevice.makeSamplerState(descriptor: samplerDescriptor2)
        
        let samplerDescriptor3: MTLSamplerDescriptor = MTLSamplerDescriptor()
        samplerDescriptor3.minFilter = .linear
        samplerDescriptor3.magFilter = .linear
        samplerDescriptor3.mipFilter = .notMipmapped
        samplerDescriptor3.sAddressMode = .repeat
        samplerDescriptor3.tAddressMode = .repeat
        self.textureSampler3 = self.mtlDevice.makeSamplerState(descriptor: samplerDescriptor3)
        
        let samplerDescriptor4: MTLSamplerDescriptor = MTLSamplerDescriptor()
        samplerDescriptor4.minFilter = .linear
        samplerDescriptor4.magFilter = .linear
        samplerDescriptor4.mipFilter = .notMipmapped
        samplerDescriptor4.sAddressMode = .mirrorRepeat
        samplerDescriptor4.tAddressMode = .mirrorRepeat
        self.textureSampler4 = self.mtlDevice.makeSamplerState(descriptor: samplerDescriptor4)
    }
    
    public func changeSamplerType(to type: SamplerType) {
        self.samplerType = type
    }
    
    public func draw(renderCommandEncoder: MTLRenderCommandEncoder) {
        renderCommandEncoder.setVertexBuffer(self.rectangleVertexBuffer, offset: 0, index: 0)
        renderCommandEncoder.setVertexBuffer(self.rectangleTextureCoordBuffer, offset: 0, index: 1)
        renderCommandEncoder.setRenderPipelineState(self.renderPipelineState)
        renderCommandEncoder.setFragmentTexture(self.rectangleTexture, index: 0)
        if (self.samplerType == .ClampToEdge) {
            renderCommandEncoder.setFragmentSamplerState(self.textureSampler1, index: 0)
        } else if (self.samplerType == .ClampToZero) {
            renderCommandEncoder.setFragmentSamplerState(self.textureSampler2, index: 0)
        } else if (self.samplerType == .Repeat) {
            renderCommandEncoder.setFragmentSamplerState(self.textureSampler3, index: 0)
        } else {
            renderCommandEncoder.setFragmentSamplerState(self.textureSampler4, index: 0)
        }
        renderCommandEncoder.drawIndexedPrimitives(type: .triangle, indexCount: self.rectangleIndexData.count, indexType: .uint16, indexBuffer: self.rectangleIndexBuffer, indexBufferOffset: 0)
    }
}

