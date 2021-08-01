//
//  MainWindowController.swift
//  testOutline
//
//  Created by thierryH24 on 25/07/2021.
//

import Cocoa

class MainWindowController: NSWindowController {
    
    enum ListeOperationsDisplayProperty: String {
        case title
        case date
        case category
    }

    @IBOutlet weak var outlineView: NSOutlineView!
    
    var feeds = [Datas]()
    let dateFormatter = DateFormatter()
    
    override var windowNibName: NSNib.Name? {
        return  "MainWindowController"
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        dateFormatter.dateStyle = .short
        
        feedList("Feeds")
        outlineView.reloadData()
    }
    
    func feedList(_ fileName: String) {
        
        let url = Bundle.main.url(forResource: fileName, withExtension: "plist")!
        let data = try! Data(contentsOf: url)
        feeds = try! data.decoded()
    }
    
    override func deleteBackward(_ sender: Any?) {
        //1
        let selectedRow = outlineView.selectedRow
        if selectedRow == -1 {
            return
        }
        
        //2
        outlineView.beginUpdates()
        //3
        if let item = outlineView.item(atRow: selectedRow) {
            
            //4
            if let item = item as? Datas {
                //5
                if let index = self.feeds.firstIndex( where: {$0.name == item.name} ) {
                    //6
                    self.feeds.remove(at: index)
                    //7
                    outlineView.removeItems(at: IndexSet(integer: selectedRow), inParent: nil, withAnimation: .slideLeft)
                }
            } else if let item = item as? Children {
                //8
                for feed in self.feeds {
                    var feed = feed
                    //9
                    if let index = feed.children.firstIndex( where: {$0.title == item.title} ) {
                        feed.children.remove(at: index)
                        outlineView.removeItems(at: IndexSet(integer: index), inParent: feed, withAnimation: .slideLeft)
                    }
                }
            }
        }
        outlineView.endUpdates()
    }
}

// MARK: - KSHeaderCellView
final class KSHeaderCellView: NSTableCellView {
    
    var fillColor = NSColor.orange
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        let bPath = NSBezierPath(rect: dirtyRect)
        fillColor.set()
        bPath.fill()
    }
}
