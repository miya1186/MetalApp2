//
//  ViewController.swift
//  MetalApp2
//
//  Created by miyazawaryohei on 2020/09/23.
//

import UIKit
import MetalKit

class ViewController: UIViewController,MTKViewDelegate{

    private let device = MTLCreateSystemDefaultDevice()!
    private var commandQueue: MTLCommandQueue!

    //頂点座標を定義（ここでは画面全体を指定）
    private let vertexData: [Float] = [
        -1, -1, 0, 1,
         1, -1, 0, 1,
        -1,  1, 0, 1,
         1,  1, 0, 1
    ]
    private var vertexBuffer: MTLBuffer!
    private var renderPipeline: MTLRenderPipelineState!
    private let renderPassDescriptor = MTLRenderPassDescriptor()
    
    
    @IBOutlet var mtkView: MTKView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commandQueue = device.makeCommandQueue()
        mtkView.device = device
        mtkView.delegate = self

        let size = vertexData.count * MemoryLayout<Float>.size
        vertexBuffer = device.makeBuffer(bytes: vertexData, length: size)
        
        //パイプラインの作成
        guard let library = device.makeDefaultLibrary() else {fatalError()}
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.vertexFunction = library.makeFunction(name: "vertexShader")
        descriptor.fragmentFunction = library.makeFunction(name: "fragmentShader")
        descriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        renderPipeline = try! device.makeRenderPipelineState(descriptor: descriptor)
    }


    func draw(in view: MTKView) {

        guard let drawable = view.currentDrawable else {return}
        guard let commandBuffer = commandQueue.makeCommandBuffer() else {fatalError()}

        renderPassDescriptor.colorAttachments[0].texture = drawable.texture
        
        // エンコーダ生成
        let renderEncoder =
            commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor)!

        guard let renderPipeline = renderPipeline else {fatalError()}
        renderEncoder.setRenderPipelineState(renderPipeline)
        renderEncoder.setVertexBuffer(vertexBuffer, offset: 0, index: 0)
        renderEncoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)

        renderEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
}

