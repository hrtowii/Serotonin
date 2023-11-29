//
//  ContentView.swift
//  WDBRemoveThreeAppLimit
//
//  Created by Zhuowei Zhang on 2023-01-31.
//

import SwiftUI


struct ContentView: View {
  @State private var message = ""
  var body: some View {
    VStack {
      Image(systemName: "globe")
        .imageScale(.large)
        .foregroundColor(.accentColor)
      Text(message)
        Button(action: {
            let retval = fuck();
            if (retval == 0) {
                DispatchQueue.main.async {
                  message = "Success."
                }
            } else {
                DispatchQueue.main.async {
                  message = "Failed to userspace reboot."
                }
            }
        }) {
        Text("Go")
      }.padding(16)
    }
    .padding()
  }
}

struct ContentView_Previews: PreviewProvider {
  static var previews: some View {
    ContentView()
  }
}
