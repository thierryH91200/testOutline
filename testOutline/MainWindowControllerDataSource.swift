//
//  MainWindowControllerDataSource.swift
//  testOutline
//
//  Created by thierryH24 on 30/07/2021.
//

import AppKit


extension MainWindowController: NSOutlineViewDataSource {
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        
        if item == nil {
            return feeds.count
        }

        if let feed = item as? Datas {
            return feed.children.count
        }
        
        return 0
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        
        if item == nil {
            let feed = feeds[index]
            return feed
        }

        if let feed = item as? Datas {
            return feed.children[index]
        }
        
        return "child index : BAD ITEM"
        
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return isSourceGroupItem(item)
    }
    
    func isSourceGroupItem(_ item: Any) -> Bool
    {
        if item is Datas {
            return true
        }
        if item is Children {
            return false
        }
        return false
    }
}
