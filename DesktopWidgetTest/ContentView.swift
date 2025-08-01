//
//  ContentView.swift
//  DesktopWidgetTest
//
//  Created by 위대연 on 7/22/25.
//
import SwiftUI
import WidgetKit

struct ContentView: View {
  @State private var image: NSImage?
  
  // --- Using a computed property instead of @AppStorage for more stability ---
//  private var selectedImageBookmark: Data? {
//      get {
//          UserDefaults(suiteName: "group.desktopw.dy")?.data(forKey: "selectedImageBookmark")
//      }
//      set {
//          UserDefaults(suiteName: "group.desktopw.dy")?.set(newValue, forKey: "selectedImageBookmark")
//      }
//  }
  //  private var selectedImageBookmark: Data? {
  
  var body: some View {
    VStack {
      HStack {
        Button {
          openPanel()
        } label: {
          Text("이미지 변경")
        }
        Spacer()
      }
      
      Spacer()
      
      if let image = image {
        Image(nsImage: image)
          .resizable()
          .aspectRatio(contentMode: .fit)
          .frame(maxWidth: .infinity, maxHeight: .infinity)
      } else {
        Text("비어있는 이미지뷰")
          .frame(maxWidth: .infinity, maxHeight: .infinity)
          .background(Color.gray.opacity(0.1))
          .overlay(
            RoundedRectangle(cornerRadius: 8)
              .stroke(Color.gray, style: StrokeStyle(lineWidth: 1, dash: [5]))
          )
      }
      
      Spacer()
    }
    .padding()
    .onAppear(perform: loadImageFromUserDefaults)
  }
  
  private func openPanel() {
    let panel = NSOpenPanel()
    panel.allowedContentTypes = [.png, .jpeg, .gif, .tiff, .bmp]
    panel.allowsMultipleSelection = false
    panel.canChooseDirectories = false
    
    if panel.runModal() == .OK, let url = panel.url {
        // Start accessing the security-scoped resource.
        guard url.startAccessingSecurityScopedResource() else {
            print("Error: Could not start accessing security-scoped resource.")
            return
        }
        
        // Defer stopping access to ensure it's always called.
        defer {
            url.stopAccessingSecurityScopedResource()
            print("Stopped accessing security-scoped resource.")
        }
        
        // 1. Load the image directly for immediate display (we know this works).
        self.image = NSImage(contentsOf: url)
        
        // --- NEW: Save image data directly ---
        if let image = self.image, let imageData = image.tiffRepresentation {
            if let bitmap = NSBitmapImageRep(data: imageData),
               let pngData = bitmap.representation(using: .png, properties: [:]) {
                UserDefaults(suiteName: "group.desktopw.dy")?.set(pngData, forKey: "widgetImageData")
                print("Successfully saved image data to UserDefaults.")
            } else {
                print("Error converting image to PNG data.")
            }
        } else {
            print("Error getting image TIFF representation.")
        }
        // --- END NEW ---
        
        WidgetKit.WidgetCenter.shared.reloadAllTimelines()
    }
  }
  
  private func loadImageFromUserDefaults() {
    guard let imageData = UserDefaults(suiteName: "group.desktopw.dy")?.data(forKey: "widgetImageData") else {
        print("No image data found in UserDefaults on app start.")
        self.image = nil
        return
    }
    self.image = NSImage(data: imageData)
    print("Successfully loaded image from UserDefaults on app start.")
  }
}

#Preview {
  ContentView()
}
