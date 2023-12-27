# Phototron

## Overview

Phototron is a modern, asynchronous local filesystem caching library tailored for SwiftUI applications. It leverages the power of Swift's async/await paradigm and the robustness of thread-safe actors to provide a seamless and efficient caching experience. With a requirement of iOS 17.0 or greater, Phototron takes full advantage of the latest Observation framework to ensure your app's data management is both reactive and reliable.

## Features

- **Asynchronous API**: Utilizes Swift's latest async/await features for non-blocking IO operations.
- **Thread Safety**: Built with actors to ensure safe access to shared data across concurrent tasks.
- **iOS 17 Observation**: Integrates with iOS 17's Observation framework for real-time updates and notifications.
- **Automatic Directory Management**: Phototron handles the creation and management of a dedicated `.phototron` directory in the filesystem.
- **Metadata Tracking**: Maintains a `metadata.json` file within the cache directory to store and retrieve caching details efficiently.

## Requirements

- iOS 17.0+
- Swift 5.9

## Installation

To install Phototron, simply add it to your project using Swift Package Manager.

### Using Swift Package Manager

1. In Xcode, open your project and navigate to `File` -> `Add Packages...`.
2. Paste the repository URL into the search bar and press Enter.
3. Select the Phototron package when it appears and choose the version you want to add.
4. Click on `Add Package` to your project.

Once the package is added to your project, you can start using Phototron by importing it into your Swift files


## Usage

Using Phototron is straightforward and integrates seamlessly with your SwiftUI views. To display and cache an image asynchronously, you can use the `PhototronImage` view, which behaves similarly to SwiftUI's `AsyncImage` but is implemented based on the standard `Image` view for a more familiar experience.

Here's a simple step-by-step guide on how to use `PhototronImage`:

1. **Import Phototron**: Ensure that you have imported the Phototron library in the file where you intend to use it.

   ```swift
   import Phototron
   ```

2. **Instantiate PhototronImage**: Create a `PhototronImage` instance in your SwiftUI view, providing the URL string of the image you wish to display and cache.

   ```swift
   PhototronImage(urlString: "https://static.cinepolis.com/img/peliculas/35167/1/1/35167.jpg")
   ```

3. **Customize**: You can further customize the `PhototronImage` view with standard `Image` modifiers to fit the design of your app.

   ```swift
   PhototronImage(urlString: "https://static.cinepolis.com/img/peliculas/35167/1/1/35167.jpg")
       .resizable()
       .aspectRatio(contentMode: .fill)
       .frame(width: 100, height: 100)
       .clipped()
   ```

4. **Handling States (TODO) **: : Phototron allows you to handle different states such as loading, success, and failure. You can provide closures to customize the behavior and appearance for each state.

   ```swift
   // TODO: Feature not implemented yet
   PhototronImage(urlString: "https://static.cinepolis.com/img/peliculas/35167/1/1/35167.jpg") { state in
       switch state {
       case .loading:
           ProgressView()
       case .success(let image):
           image
               .resizable()
               .aspectRatio(contentMode: .fill)
       case .failure:
           Image(systemName: "photo")
       }
   }
   .frame(width: 100, height: 100)
   ```

Phototron takes care of the rest. It will manage the downloading, caching, and retrieval of the image, ensuring that subsequent requests for the same image are served from the cache, reducing network load and improving user experience.

Remember to handle the permissions for accessing the network and local filesystem as required by iOS to ensure that Phototron operates without any hitches.

## Documentation

`!WIP`

## Contributing

We welcome contributions! If you would like to help improve Phototron, please feel free to fork the repository, make your changes, and submit a pull request.

