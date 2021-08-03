//
//  MainWindowController.swift
//  testOutline
//
//  Created by thierryH24 on 25/07/2021.
//

import Cocoa

class MainWindowController: NSWindowController {
    
    enum ListeOperationsDisplayProperty: String {
        case mode
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

        self.outlineView.autosaveTableColumns = false
        self.outlineView.autosaveExpandedItems = false
        outlineView.reloadData()
        self.outlineView.autosaveExpandedItems = true
        
        reloadData(false, true)
    }
    
    func feedList(_ fileName: String) {
        
        let url = Bundle.main.url(forResource: fileName, withExtension: "plist")!
        let data = try! Data(contentsOf: url)
        feeds = try! data.decoded()
    }
    
    func reloadData(_ expand: Bool = false,_ auto: Bool = false) {
        
        DispatchQueue.main.async {
            self.outlineView.autosaveExpandedItems = false
            self.outlineView.reloadData()
            self.outlineView.autosaveExpandedItems = auto

            if expand == true {
                self.outlineView.expandItem(nil, expandChildren: true)
                return
            }
            
            if self.outlineView.autosaveExpandedItems,
               let autosaveName = self.outlineView.autosaveName,
               let persistentObjects = UserDefaults.standard.array(forKey: "NSOutlineView Items \(autosaveName)"),
               let itemIds = persistentObjects as? [String] {
                let items = itemIds.sorted{ $0 < $1}
                items.forEach {
                    let item = self.outlineView.dataSource?.outlineView?(self.outlineView, itemForPersistentObject: $0)
                    if let item = item as? Datas {
                        self.outlineView.expandItem(item)
                    }
//                    if let item = item as? GroupedMonthOperations {
//                        self.outlineListView.expandItem(item)
//                    }
                }
            }
        }
    }

    
    override func deleteBackward(_ sender: Any?) {
        //1
        let selectedRow = outlineView.selectedRow
        if selectedRow == -1 {
            return
        }
        
        outlineView.beginUpdates()
        if let item = outlineView.item(atRow: selectedRow) {
            
            if let item = item as? Datas {
                if let index = self.feeds.firstIndex( where: {$0.name == item.name} ) {
                    self.feeds.remove(at: index)
                    outlineView.removeItems(at: IndexSet(integer: selectedRow), inParent: nil, withAnimation: .slideLeft)
                }
            } else if let item = item as? Children {
                for feed in self.feeds {
                    let feed = feed
                    if let index = feed.children.firstIndex( where: {$0.mode == item.mode} ) {
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
