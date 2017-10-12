# Tibei

[![CI Status](http://img.shields.io/travis/Valbrand/Tibei.svg?style=flat)](https://travis-ci.org/Valbrand/Tibei)
[![Version](https://img.shields.io/cocoapods/v/Tibei.svg?style=flat)](http://cocoapods.org/pods/Tibei)
[![License](https://img.shields.io/cocoapods/l/Tibei.svg?style=flat)](http://cocoapods.org/pods/Tibei)
[![Platform](https://img.shields.io/cocoapods/p/Tibei.svg?style=flat)](http://cocoapods.org/pods/Tibei)

## Getting started

To run the sample application, you just have to clone/download this repository and run the `Tibei Example` target through xCode.

## Requirements

Tibei has no dependencies. It uses `NetService` from `Foundation` internally to discover and connect to peers.

## Installation

Tibei is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "Tibei"
```

## Usage

Now you'll find a tutorial on how to actually use Tibei in your project. I'll try to keep it as short as possible, and in case you need to see things actually working, the sample application should suffice.

### Discovering services and connecting to them

Tibei relies on the concept of having one or more devices acting as a Server, listening to connection requests and connecting to them directly in case it accepts said requests. Servers can also be clients simultaneously.

Creating a server is as simple as creating an instance of the `ServerMessenger` class and calling its `publishService` method:

```swift
self.server = ServerMessenger(serviceIdentifier: "myAppName")
self.server.publishService()
```

The `serviceIdentifier` argument serves as a means to make your app's service distinguishable from other applications and devices that may also be using Bonjour nearby.

Given a device has started a server nearby, a client can discover its existence by creating an instance of `ClientMessenger` and browsing for services:

```swift
//...
self.client = ClientMessenger()
self.client.registerResponder(self)
self.client.browseForServices(withIdentifier: "myAppName")
//...
```

This will make the client start looking for services with the given identifier. Whenever the list of available services with the identifier `"myAppName"` changes, the `ClientMessenger` instance will call the method `availableServicesChanged(availableServiceIds:)` on its responder (hence the second line in the previous sample). An example that connects to the first service the client manages to find follows below:

```swift
extension ViewController: ConnectionResponder {
  func availableServicesChanged(availableServiceIDs: [String]) {
    do {
      try self.client.connect(serviceIdentifier: availableServiceIDs.first!)
    } catch {
      print("An error occurred while trying to connect")
      print(error)
    }
  }
}
```

The `ConnectionResponder` protocol has several other lifecycle methods that can be seen in the sample application and in the [docs](http://www.dvalbrand.com/tibei).

### Sending and receiving messages

Clients can only send messages directly to the server they're connected to. Messages are encoded in JSON format before being sent, and should conform to the [`JSONConvertibleMessage`](http://www.dvalbrand.com/tibei/Protocols/JSONConvertibleMessage.html) protocol. Clients can send messages using the `sendMessage(_:)` method.

Servers can send messages to any of the clients connected to them. In order to identify them, each `Connection` is given a `ConnectionID` upon creation. It should be passed on to the `sendMessage(_:toConnectionWithID:)` method in order to have it send to the correct peer.

## Author

Daniel Oliveira, dvalbrand@gmail.com

## License

Tibei is available under the MIT license. See the LICENSE file for more info.
