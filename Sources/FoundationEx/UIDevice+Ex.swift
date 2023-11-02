//
//  UIDevice+Ex.swift
//  GoldRentalMachine
//
//  Created by Q Z on 2023/11/2.
//

import UIKit

extension UIDevice {
    //MARK: Get String Value
   public var totalDiskSpaceInGB:String {
        return ByteCountFormatter.string(fromByteCount: totalDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.decimal)
    }
    
    public var freeDiskSpaceInGB:String {
        return ByteCountFormatter.string(fromByteCount: freeDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.decimal)
    }
    
    public var usedDiskSpaceInGB:String {
        return ByteCountFormatter.string(fromByteCount: usedDiskSpaceInBytes, countStyle: ByteCountFormatter.CountStyle.decimal)
    }
    
    public var totalMemoryInGB:String {
        return GBFormatter(totalMemoryInBytes)
     }
    
    public var freeMemoryInGB:String {
        return GBFormatter(freeMemoryInBytes)
    }
    
    public var usedMemoryInGB:String {
        return GBFormatter(usedMemoryInBytes)
    }
    
    
    public var totalMemoryInMB:String {
        return MBFormatter(totalMemoryInBytes)
     }
    
    public var totalDiskSpaceInMB:String {
        return MBFormatter(totalDiskSpaceInBytes)
    }
    
    public var freeDiskSpaceInMB:String {
        return MBFormatter(freeDiskSpaceInBytes)
    }
    
    public var usedDiskSpaceInMB:String {
        return MBFormatter(usedDiskSpaceInBytes)
    }
    
    //MARK: Get raw value
    private func MBFormatter(_ bytes: Int64) -> String {
         let formatter = ByteCountFormatter()
         formatter.allowedUnits = ByteCountFormatter.Units.useMB
         formatter.countStyle = ByteCountFormatter.CountStyle.decimal
         formatter.includesUnit = false
         return formatter.string(fromByteCount: bytes) as String
     }
    
    private func GBFormatter(_ bytes: Int64) -> String {
         let formatter = ByteCountFormatter()
         formatter.allowedUnits = ByteCountFormatter.Units.useGB
         formatter.countStyle = ByteCountFormatter.CountStyle.decimal
         return formatter.string(fromByteCount: bytes) as String
     }
    
    private var totalMemoryInBytes:Int64 {
        return Int64(ProcessInfo.processInfo.physicalMemory)
    }
    
    private var freeMemoryInBytes:Int64 {
        return totalMemoryInBytes - usedMemoryInBytes
    }
    
    private var usedMemoryInBytes:Int64 {
        var taskInfo = task_vm_info_data_t()
        var count = mach_msg_type_number_t(MemoryLayout<task_vm_info>.size) / 4
        let result: kern_return_t = withUnsafeMutablePointer(to: &taskInfo) {
            $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                task_info(mach_task_self_, task_flavor_t(TASK_VM_INFO), $0, &count)
            }
        }
        
        var used: UInt64 = 0
        if result == KERN_SUCCESS {
            used = UInt64(taskInfo.phys_footprint)
        }
        return Int64(used)
    }
    
    
    private var totalDiskSpaceInBytes:Int64 {
        guard let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String),
              let space = (systemAttributes[FileAttributeKey.systemSize] as? NSNumber)?.int64Value else { return 0 }
        return space
    }
   
    private var freeDiskSpaceInBytes:Int64 {
        if #available(iOS 11.0, *) {
            if let space = try? URL(fileURLWithPath: NSHomeDirectory() as String).resourceValues(forKeys: [URLResourceKey.volumeAvailableCapacityForImportantUsageKey]).volumeAvailableCapacityForImportantUsage {
                return space
            } else {
                return 0
            }
        } else {
            if let systemAttributes = try? FileManager.default.attributesOfFileSystem(forPath: NSHomeDirectory() as String),
               let freeSpace = (systemAttributes[FileAttributeKey.systemFreeSize] as? NSNumber)?.int64Value {
                return freeSpace
            } else {
                return 0
            }
        }
    }
    
    private var usedDiskSpaceInBytes:Int64 {
        return totalDiskSpaceInBytes - freeDiskSpaceInBytes
    }
}
