//
//  BLEManager.swift
//  BluetoothPostion
//
//  Created by Jeremiah Givens on 12/18/21.
//

import Foundation
import CoreBluetooth
import SwiftUI

class BLEManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate{
    var centralManager: CBCentralManager!
    var HM10Peripheral: CBPeripheral!
    var HM10Service = CBUUID(string: "0000FFE0-0000-1000-8000-00805F9B34FB")
    var HM10MessageCharacteristic: CBCharacteristic!
    var HM10MessageCharacteristicCBUUID = CBUUID(string: "FFE1")
    
    @Published var message = ""
    @Published var foundPeripherals = [UUID:CBPeripheral]()
    
    override init(){
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {

        case .unknown:
            print("central.state is unknown")
        case .resetting:
            print("central.state is resetting")
        case .unsupported:
            print("central.state is unsupported")
        case .unauthorized:
            print("central.state is unauthorized")
        case .poweredOff:
            print("central.state is poweredOff")
        case .poweredOn:
            print("central.state is poweredOn")
            centralManager.scanForPeripherals(withServices: [HM10Service])
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        // This just attaches to the first HM-10 it finds. You will need to modify this
        // if there are more than one HM-10's within range.
        //HM10Peripheral = peripheral
        foundPeripherals[peripheral.identifier] = peripheral
        print(peripheral)
        //HM10Peripheral.delegate = self
        //centralManager.stopScan()
        //central.connect(HM10Peripheral)
        //centralManager.connect(HM10Peripheral)
    }
    
    func setPeripheral(peripheral: CBPeripheral?){
        if HM10Peripheral != nil{
            centralManager.cancelPeripheralConnection(HM10Peripheral)
        }
        HM10Peripheral = peripheral
        HM10Peripheral.delegate = self
        centralManager.connect(HM10Peripheral)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("Connected!!!")
        HM10Peripheral.discoverServices([HM10Service])
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        guard let services = peripheral.services else { return }

        for service in services {
            print(service)
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService,
                    error: Error?) {
      guard let characteristics = service.characteristics else { return }

      for characteristic in characteristics {
          print(characteristic)
          if characteristic.properties.contains(.read) {
              print("\(characteristic.uuid): properties contains .read")
              peripheral.readValue(for: characteristic)
          }
          if characteristic.properties.contains(.notify) {
              print("\(characteristic.uuid): properties contains .notify")
              HM10MessageCharacteristic = characteristic
              peripheral.setNotifyValue(true, for: characteristic)
          }
          if characteristic.properties.contains(.write) {
              print("\(characteristic.uuid): properties contains .write")
          }
      }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic,
                    error: Error?) {
      switch characteristic.uuid {
        case HM10MessageCharacteristicCBUUID:
          print(HM10Message(from: characteristic))
        default:
          print("Unhandled Characteristic UUID: \(characteristic.uuid)")
      }
    }
    
    private func HM10Message(from characteristic: CBCharacteristic) -> String {
      guard let characteristicData = characteristic.value else { return "Fubar" }
        let string = String(data: characteristicData, encoding: .utf8)
        
        message = string ?? ""
        return string ?? ""
    }
    
    func sendMessage(messageToSend: String){
        HM10Peripheral.writeValue(messageToSend.data(using: .utf8) ?? Data(), for: HM10MessageCharacteristic, type: .withoutResponse)
    }
    
    func sendStruct(messageToSend: MessageStruct){
        let packet = withUnsafeBytes(of: messageToSend) { Data($0) }
        if HM10Peripheral != nil{
            HM10Peripheral.writeValue(packet, for: HM10MessageCharacteristic, type: .withoutResponse)
        }
    }
}
