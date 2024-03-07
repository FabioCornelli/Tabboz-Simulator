//
//  Win32BMP.swift
//  Tabboz Simulator
//
//  Created by Antonio Malara on 27/08/2020.
//  Copyright © 2020 Antonio Malara. All rights reserved.
//

import Foundation
import CoreImage

fileprivate func BMP_RGB_to_32bpp(
    _ reader: Reader,
    _ w: Int,
    _ h: Int,
    _ bitCount: Int,
    _ hasMask: Bool,
    _ dst: UnsafeMutableRawBufferPointer,
    _ palette: Data
) throws
{
    let srcStride  = (w * bitCount + 31) / 32 * 4
    let maskStride = (w  + 31) / 32 * 4
    let src        = try reader.data(size: srcStride * h)

    let mask = hasMask ? try reader.data(size: maskStride * h) : nil

    for y in 0 ..< h {
        for x in 0 ..< w {
            let srcY = h - y - 1
            let off = y * w + x
            
            let pix : Int
            let maskBit : Bool
            
            if bitCount == 8 {
                pix = Int(src[srcY * srcStride + x])
            }
            else if bitCount == 4 {
                let pixByte = src[srcY * srcStride + (x / 2)]
                pix = (x % 2) == 0 ? Int(pixByte & 0xf0) >> 4 : Int(pixByte & 0x0f)
            }
            else {
                // bitCount == 1
                let pixByte = Int(src[(srcY * srcStride) + (x / 8)])
                pix = (pixByte & (0x80 >> (x % 8))) >> (7 - (x % 8))
            }
            
            if let mask = mask {
                let maskByte = mask[(srcY * maskStride) + (x / 8)]
                maskBit  = (maskByte & (0x80 >> (x % 8))) != 0
            }
            else {
                maskBit = false
            }
            
            dst[off * 4 + 0] = palette[(pix * 4) + 2]
            dst[off * 4 + 1] = palette[(pix * 4) + 1]
            dst[off * 4 + 2] = palette[(pix * 4) + 0]
            dst[off * 4 + 3] = maskBit == false ? 0xff : 0x00
        }
    }
}

fileprivate func BMP_RLE_to_32bpp(
    _ reader: Reader,
    _ w: Int,
    _ h: Int,
    _ dst: UnsafeMutableRawBufferPointer,
    _ palette: Data,
    
    colorForByte: (Int, Int) -> Int,
    runDataForCount: (Reader, Int) throws -> Data,
    colorForRun: (Data, Int) -> UInt8
) throws
{
    var x = 0
    var y = 0
    
    let incrementPixelPosition = {
        x += 1
        if x >= w {
            x = 0
        }
    }
    
    let setColor = { (pix: Int) in
        let off = (h - y - 1) * w + x
        
        dst[off * 4 + 0] = palette[(pix * 4) + 2]
        dst[off * 4 + 1] = palette[(pix * 4) + 1]
        dst[off * 4 + 2] = palette[(pix * 4) + 0]
        dst[off * 4 + 3] = 0
    }
    
    var command : UInt8
    
    while true {
        do {
            command = try reader.byte()
            
            if command != 0 {
                // Encoded Mode
                
                let count = Int(command)
                let colors = Int(try reader.byte())
                
                for i in 0 ..< count {
                    let pix = colorForByte(colors, i)
                    setColor(pix)
                    incrementPixelPosition()
                }
            }
            else {
                // Absolute Mode
                
                let escaped = try reader.byte()
                
                if escaped == 0 {
                    // end of line
                    x = 0
                    y += 1
                }
                else if escaped == 1 {
                    // end of bitmap
                    break
                }
                else if escaped == 2 {
                    // delta
                    x += Int(try reader.byte())
                    y += Int(try reader.byte())
                }
                else {
                    let count = Int(escaped)
                    let run = try runDataForCount(reader, count)
                    
                    if (run.count % 2) == 1 {
                        _ = try reader.byte()
                    }
                    
                    for i in 0 ..< count {
                        let col = colorForRun(run, i)
                        let pix = colorForByte(Int(col), i)
                        
                        setColor(pix)
                        incrementPixelPosition()
                    }
                }
            }
            
        }
        catch (Reader.Errors.eof) {
            break
        }
    }
}

fileprivate func BMP_RLE4_to_32bpp(
    _ reader: Reader,
    _ w: Int,
    _ h: Int,
    _ dst: UnsafeMutableRawBufferPointer,
    _ palette: Data
) throws
{
    try BMP_RLE_to_32bpp(
        reader,
        w,
        h,
        dst,
        palette,
        colorForByte: { (colors, i) in
            (i % 2 == 0)
                ? (colors & 0xf0) >> 4
                : (colors & 0x0f)
        },
        runDataForCount: { (reader, count) in
            try reader.data(size: (count + 1) / 2)
        },
        colorForRun: { (run, i)  in
            run[i / 2]
        }
    )
}

fileprivate func BMP_RLE8_to_32bpp(
    _ reader: Reader,
    _ w: Int,
    _ h: Int,
    _ dst: UnsafeMutableRawBufferPointer,
    _ palette: Data
) throws
{
    try BMP_RLE_to_32bpp(
        reader,
        w,
        h,
        dst,
        palette,
        colorForByte: { (colors, i) in
            colors
        },
        runDataForCount: { (reader, count) in
            try reader.data(size: count)
        },
        colorForRun: { (run, i) in
            run[i]
        }
    )
}

func dataToImage(data: Data, hasMask: Bool = false) throws -> CGImage {
    enum Errors : Error {
        case moreThanOnePlane
        case unsupportedCompression(BITMAPINFOHEADER.Compression)
        case unsupportedBitCount(UInt16)
    }
    
    let header = BITMAPINFOHEADER()
    let reader = Reader(data: data)
    try header.read(reader: reader)
    
    guard header.planes.value == 1 else {
        throw Errors.moreThanOnePlane
    }
    
    guard
        header.bitCount.value == 8 ||
        header.bitCount.value == 4 ||
        header.bitCount.value == 1
    else {
        throw Errors.unsupportedBitCount(header.bitCount.value)
    }

    let w                   = Int(header.width.value)
    let h                   = hasMask
                                ? Int(header.height.value) / 2
                                : Int(header.height.value)

    let bitCount            = Int(header.bitCount.value)
    let defaultPaletteCount = bitCount == 8 ? 256 :
                              bitCount == 4 ? 16  : 2
    
    let paletteCount        = header.clrUsed.value == 0
                                ? defaultPaletteCount
                                : Int(header.clrUsed.value)
    
    let palette             = try reader.data(size: 4 * paletteCount)
    
    let c = CGContext(
        data: nil,
        width: w,
        height: h,
        bitsPerComponent: 8,
        bytesPerRow: w * 4,
        space: CGColorSpace(name: CGColorSpace.sRGB)!,
        bitmapInfo: hasMask
            ? CGImageAlphaInfo.premultipliedLast.rawValue
            : CGImageAlphaInfo.noneSkipLast.rawValue
    )!
    
    let dst = UnsafeMutableRawBufferPointer(start: c.data, count: w * h * 4)

    switch header.compression.value {
    case .BI_RGB:
        try BMP_RGB_to_32bpp(reader, w, h, bitCount, hasMask, dst, palette)
        
    case .BI_RLE4:
        try BMP_RLE4_to_32bpp(reader, w, h, dst, palette)
        
    case .BI_RLE8:
        try BMP_RLE8_to_32bpp(reader, w, h, dst, palette)
        
    default:
        throw Errors.unsupportedCompression(header.compression.value)
    }
        
    return c.makeImage()!
}
