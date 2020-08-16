import Foundation

enum Errors : Error {
    case eof
    case overflow
}

class Reader {
    let data: Data
    let offset: Int
    
    var log = false
    
    var i: Int = 0 {
        didSet {
            if log && oldValue != i {
                print(String(format: "~~ buffer: %x  -- %x", i, i + offset))
            }
        }
    }
    
    init(data: Data, offset: Int = 0) {
        self.data = data
        self.offset = offset
    }
    
    func byte() throws -> UInt8 {
        if i == data.count {
            throw Errors.eof
        }
        
        let v = data[i]
        i += 1
        return v
    }

    func data(size: Int) throws -> Data {
        let r = Data(data[i ..< i + size])
        i += size
        return r
    }
    
    func align(alignment: Int) {
        var idx = i + offset
        
        if idx & (alignment - 1) != 0 {
            idx += alignment - (idx & (alignment - 1))
        }
        
        i = idx - offset
    }
    
}

protocol BinaryRepresented : AnyObject {
    func read(reader: Reader) throws
}

extension BinaryRepresented {
    func read(reader: Reader) throws {
        try Mirror(reflecting: self)
            .children
            .compactMap { $1 as? BinaryRepresented }
            .forEach    { try $0.read(reader: reader) }
    }
}

class WORD : BinaryRepresented {
    var value: UInt16 = 0
    
    func read(reader: Reader) throws {
        value =
            (UInt16(try reader.byte())     ) +
            (UInt16(try reader.byte()) << 8)
    }
}

class DWORD : BinaryRepresented {
    var value: UInt32 = 0
    
    func read(reader: Reader) throws {
        value =
            (UInt32(try reader.byte())      ) +
            (UInt32(try reader.byte()) <<  8) +
            (UInt32(try reader.byte()) << 16) +
            (UInt32(try reader.byte()) << 24)
    }
}

class ResourceString : BinaryRepresented {
    
    var value = ""
    
    func read(reader: Reader, initialCharacter: WORD? = nil) throws {
        value = ""
        let dw = WORD()
        
        if initialCharacter?.value == 0 {
            return
        }
        
        if let s = initialCharacter.flatMap({ UnicodeScalar($0.value) }) {
            value += String(s)
        }

        while true {
            try dw.read(reader: reader)
            
            if dw.value == 0 {
                break
            }
            
            if let s = UnicodeScalar(dw.value) {
                value += String(s)
            }
        }
    }
    
}

class StringOrNumeric : BinaryRepresented {
    
    enum StringOrNumeric : Hashable {
        case numeric(Int)
        case string(String)
        
        func asString() -> String {
            switch self {
            case .numeric(let x): return "~~ NUMERIC \(x)"
            case .string(let x):  return x
            }
        }
    }
    
    var value = StringOrNumeric.numeric(0)
    
    func read(reader: Reader) throws {
        let dw = WORD()
        try dw.read(reader: reader)
        
        if dw.value == 0xffff {
            try dw.read(reader: reader)
            value = .numeric(Int(dw.value))
        }
        else {
            let string = ResourceString()
            try string.read(reader: reader, initialCharacter: dw)
            value = .string(string.value)
        }
    }
    
}

class StringOrNumericOrZero : BinaryRepresented {
    
    enum Info {
        case zero
        case numeric(Int)
        case string(String)
    }

    var value = Info.zero
    
    func read(reader: Reader) throws {
        let dw = WORD()
        try dw.read(reader: reader)
        
        if dw.value == 0x0000 {
            value = .zero
        }
        else if dw.value == 0xffff {
            try dw.read(reader: reader)
            value = .numeric(Int(dw.value))
        }
        else {
            let string = ResourceString()
            try string.read(reader: reader, initialCharacter: dw)
            value = .string(string.value)
            reader.align(alignment: 2)
        }

    }
}

class ResourceType : BinaryRepresented {
    
    enum Types : Int {
        case HEADER       =   0
        case CURSOR       =   1
        case BITMAP       =   2
        case ICON         =   3
        case MENU         =   4
        case DIALOG       =   5
        case STRING       =   6
        case FONTDIR      =   7
        case FONT         =   8
        case ACCELERATOR  =   9
        case RCDATA       =  10
        case MESSAGETABLE =  11
        case GROUP_CURSOR =  12
        case GROUP_ICON   =  14
        case VERSION      =  16
        case DLGINCLUDE   =  17
        case PLUGPLAY     =  19
        case VXD          =  20
        case ANICURSOR    =  21
        case ANIICON      =  22
        case HTML         =  23
        case DLGINIT      = 240
        case TOOLBAR      = 241
    }
    
    enum Errors : Error {
        case notimplemented
    }
    
    var value = Types.HEADER
    
    func read(reader: Reader) throws {
        let type = StringOrNumeric()
        try type.read(reader: reader)
        reader.align(alignment: 4)
        
        switch type.value {
        case .numeric(let i):
            if let t = Types(rawValue: i) {
                value = t
            }
            else {
                throw Errors.notimplemented
            }
        case .string(let x):
            print(" DIOCANCANAIADEDIO this resource type is a string >>\(x)<<")
            // throw Errors.notimplemented
        }
    }
}

class Alignment : BinaryRepresented {
    
    let alignment: Int
    
    init(alignment: Int) { self.alignment = alignment }
    
    func read(reader: Reader) throws {
        reader.align(alignment: alignment)
    }
}

class ResourceHeader : BinaryRepresented {
    let dataSize        = DWORD()
    let headerSize      = DWORD()
    let type            = ResourceType()
    let name            = StringOrNumeric()
    let align           = Alignment(alignment: 4)
    let dataVersion     = DWORD()
    let memoryFlags     = WORD()
    let languageId      = WORD()
    let version         = DWORD()
    let characteristics = DWORD()
}

class Resource : BinaryRepresented {
    let header = ResourceHeader()
    var data : (data: Data, offset: Int)? = nil
    
    func read(reader: Reader) throws {
        try header.read(reader: reader)

        let off = reader.i
        data = (try reader.data(size: Int(header.dataSize.value)), off)
        reader.align(alignment: 4)
    }
}

/* - */

class WindowStyles : BinaryRepresented {
    struct WindowStyles : OptionSet {
        let rawValue: UInt32
        
        static let WS_POPUP         = WindowStyles(rawValue: 0x80000000)
        static let WS_CHILD         = WindowStyles(rawValue: 0x40000000)
        static let WS_MINIMIZE      = WindowStyles(rawValue: 0x20000000)
        static let WS_VISIBLE       = WindowStyles(rawValue: 0x10000000)
        static let WS_DISABLED      = WindowStyles(rawValue: 0x08000000)
        static let WS_CLIPSIBLINGS  = WindowStyles(rawValue: 0x04000000)
        static let WS_CLIPCHILDREN  = WindowStyles(rawValue: 0x02000000)
        static let WS_MAXIMIZE      = WindowStyles(rawValue: 0x01000000)
        static let WS_BORDER        = WindowStyles(rawValue: 0x00800000)
        static let WS_DLGFRAME      = WindowStyles(rawValue: 0x00400000)
        static let WS_VSCROLL       = WindowStyles(rawValue: 0x00200000)
        static let WS_HSCROLL       = WindowStyles(rawValue: 0x00100000)
        static let WS_SYSMENU       = WindowStyles(rawValue: 0x00080000)
        static let WS_THICKFRAME    = WindowStyles(rawValue: 0x00040000)
        static let WS_GROUP         = WindowStyles(rawValue: 0x00020000)
        static let WS_TABSTOP       = WindowStyles(rawValue: 0x00010000)
        static let WS_MINIMIZEBOX   = WindowStyles(rawValue: 0x00020000)
        static let WS_MAXIMIZEBOX   = WindowStyles(rawValue: 0x00010000)
        
        static let DS_ABSALIGN      = WindowStyles(rawValue: 0x00000001)
        static let DS_SYSMODAL      = WindowStyles(rawValue: 0x00000002)
        static let DS_3DLOOK        = WindowStyles(rawValue: 0x00000004)
        static let DS_FIXEDSYS      = WindowStyles(rawValue: 0x00000008)
        static let DS_NOFAILCREATE  = WindowStyles(rawValue: 0x00000010)
        static let DS_LOCALEDIT     = WindowStyles(rawValue: 0x00000020)
        static let DS_SETFONT       = WindowStyles(rawValue: 0x00000040)
        static let DS_MODALFRAME    = WindowStyles(rawValue: 0x00000080)
        static let DS_NOIDLEMSG     = WindowStyles(rawValue: 0x00000100)
        static let DS_SETFOREGROUND = WindowStyles(rawValue: 0x00000200)
        static let DS_CONTROL       = WindowStyles(rawValue: 0x00000400)
        static let DS_CENTER        = WindowStyles(rawValue: 0x00000800)
        static let DS_CENTERMOUSE   = WindowStyles(rawValue: 0x00001000)
        static let DS_CONTEXTHELP   = WindowStyles(rawValue: 0x00002000)
        static let DS_USEPIXELS     = WindowStyles(rawValue: 0x00008000)
    }
    
    var value = WindowStyles(rawValue: 0)
    
    func read(reader: Reader) throws {
        let x = DWORD()
        try x.read(reader: reader)
        value = WindowStyles(rawValue: x.value)
    }
}

class DLGITEMTEMPLATE : BinaryRepresented {
    let style         = WindowStyles()
    let extendedStyle = DWORD()
    let x             = WORD()
    let y             = WORD()
    let width         = WORD()
    let height        = WORD()
    let id            = WORD()
}

class DialogItemTemplate : BinaryRepresented {
    enum StandardWindowClass : Int {
        case button     = 0x0080
        case edit       = 0x0081
        case statictext = 0x0082
        case listbox    = 0x0083
        case scrollbar  = 0x0084
        case combobox   = 0x0085
    }
    
    enum WindowClass {
        case standard(StandardWindowClass)
        case custom(String)
        
        init(from: StringOrNumeric) {
            switch from.value {
            case .numeric(let n):
                if let klass = StandardWindowClass(rawValue: n) {
                    self = .standard(klass)
                }
                else {
                    self = .custom("unkown class \(n)")
                }
            case .string(let s):
                self = .custom(s)
            }
        }
    }
    
    let itemTemplate = DLGITEMTEMPLATE()
    var windowClass: WindowClass = .standard(.button)
    let title        = StringOrNumeric()
    
    var creationData: Data? = nil
    
    func read(reader: Reader) throws {
        reader.align(alignment: 4)
        try itemTemplate.read(reader: reader)
        
        let klass = StringOrNumeric()
        reader.align(alignment: 2)
        try klass.read(reader: reader)
        windowClass = WindowClass(from: klass)
        
        reader.align(alignment: 2)
        try title.read(reader: reader)
        
        let dataSize = WORD()
        try dataSize.read(reader: reader)
        
        if dataSize.value > 0 {
            creationData = try reader.data(size: Int(dataSize.value) - 2)
        }
    }
}

class DLGTEMPLATE : BinaryRepresented {
    let style         = WindowStyles()
    let extendedStyle = DWORD()
    let count         = WORD()
    let x             = WORD()
    let y             = WORD()
    let width         = WORD()
    let height        = WORD()
    let menu          = StringOrNumericOrZero()
    let windowClass   = StringOrNumericOrZero()
    let title         = StringOrNumericOrZero()
}

class Dialog : BinaryRepresented {
    let template = DLGTEMPLATE()
    var items = [DialogItemTemplate]()
    
    func read(reader: Reader) throws {
        try template.read(reader: reader)
                
        if template.style.value.contains(.DS_SETFONT) {
            let fontsize = WORD()
            try fontsize.read(reader: reader)
            let fontname = ResourceString()
            try fontname.read(reader: reader)
        }
        
        
        items = []
        for _ in 0 ..< template.count.value {
            let item = DialogItemTemplate()
            try item.read(reader: reader)
            items.append(item)
        }
    }
}

class ResourceFile {
    
    let url : URL
    
    var resources = [Resource]()
    
    var dialogs = [StringOrNumeric.StringOrNumeric : Dialog]()
    
    init(url: URL) throws {
        self.url = url
    }
    
    func load() throws {
        resources = []
        dialogs = [:]
        
        let data = try! Data(contentsOf: url)
        let reader = Reader(data: data)
        
        while true {
            let x = Resource()
            
            do {
                try x.read(reader: reader)
            }
            catch (Errors.eof) {
                break
            }
                        
            resources.append(x)
            
            switch x.header.type.value {
            
            case .HEADER:
                continue
                
            case .DIALOG:
                if dialogs[x.header.name.value] != nil {
                    print("already have dialog named \(x.header.name.value)")
                }
                
                if let data = x.data {
                    let dialog = Dialog()
                    let reader = Reader(data: data.data, offset: data.offset)
                    try dialog.read(reader: reader)
                    dialogs[x.header.name.value] = dialog
                }
                else {
                    print("dialog \(x.header.name.value) has no data")
                }
                
            case .BITMAP:       fallthrough
            case .ICON:         fallthrough
            case .MENU:         fallthrough
            case .GROUP_ICON:
                continue
                
            case .CURSOR:       fallthrough
            case .STRING:       fallthrough
            case .FONTDIR:      fallthrough
            case .FONT:         fallthrough
            case .ACCELERATOR:  fallthrough
            case .RCDATA:       fallthrough
            case .MESSAGETABLE: fallthrough
            case .GROUP_CURSOR: fallthrough
            case .VERSION:      fallthrough
            case .DLGINCLUDE:   fallthrough
            case .PLUGPLAY:     fallthrough
            case .VXD:          fallthrough
            case .ANICURSOR:    fallthrough
            case .ANIICON:      fallthrough
            case .HTML:         fallthrough
            case .DLGINIT:      fallthrough
            case .TOOLBAR:
                print(x.header.type.value)
            }
            
        }
        
    }
    
}
