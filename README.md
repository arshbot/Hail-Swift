# Hail - A multicoin wallet template app for iOS

Hail exists as an app on the appstore and as a template for iOS developers to utilize as a roadmap to make it easier to develop in the cryptocurrency space. 

This repository contains a UI-less version of the production Hail (minus some niceties I have for the production version). It can create/import wallets and spend/receive transactions in two cryptocurrencies (currently bitcoin and litecoin) with support for others being worked on.

### Getting Started

This is an Xcode project written entirely in Swift 3.0. You will need [the latest version or a version that supports your needs.](https://stackoverflow.com/questions/10335747/how-to-download-xcode-dmg-or-xip-file)

[CocoaPods](https://cocoapods.org/) is the go to package manager for most iOS developers and as such is the manager I have chosen as well. All the packages are found in the `Podfile` file. To install the dependacies, go to the folder you've cloned the repository to and make sure you can see the `Podfile`. In terminal, type in 

```
$ pod install
```

You will also need a [bcoin](http://bcoin.io/) node running. You can follow the instructions for setting up a bitcoin node with bcoin [here](https://github.com/bcoin-org/bcoin). Hail uses bitcoin's REST api to broadcast transactions and listen for new transactions. Keep in mind that you should probably run a full node for production.
