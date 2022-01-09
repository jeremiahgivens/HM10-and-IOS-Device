//
//  ContentView.swift
//  BluetoothPostion
//
//  Created by Jeremiah Givens on 12/16/21.
//

import SwiftUI
import CoreBluetooth

struct ContentView: View {
    @StateObject var bleManager = BLEManager()
    @State var locationFetcher = LocationFetcher()
    
    init(){
        locationFetcher.start()
    }
    
    var body: some View {
        NavigationView{
            VStack{
                Divider()
                Spacer()
                ScrollView{
                    ForEach(Array(bleManager.foundPeripherals.keys), id: \.self){key in
                        HStack{
                            Text(bleManager.foundPeripherals[key]?.name ?? "Name not found")
                                .foregroundColor(Color(.label))
                                .font(.headline)
                            Spacer()
                            Button("Connect"){
                                bleManager.setPeripheral(peripheral: bleManager.foundPeripherals[key])
                            }
                        }
                    }
                    .padding()
                    Divider()
                }
                Text("Message: \(bleManager.message)")
                    .padding()
                Button("Send Position"){
                    let message = MessageStruct(lat: Float32(locationFetcher.lastKnownLocation?.latitude ?? 0.0), lng: Float32(locationFetcher.lastKnownLocation?.longitude ?? 0.0))
                    bleManager.sendStruct(messageToSend: message)
                    print(message.lat)
                    print(message.lng)
                }
                .padding()
                .background(Color.green)
                .foregroundColor(Color(.label))
                Spacer()
            }
            .navigationTitle("HM-10's in Area")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
