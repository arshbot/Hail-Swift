# Hail - A multicoin wallet template app for iOS

Hail will exist as an app on the appstore and as a template for iOS developers to utilize as a roadmap to make it easier to develop in the cryptocurrency space. 

This repository contains a UI-less version of the production Hail (minus some niceties I have for the production version). It can create/import wallets and spend/receive transactions in two cryptocurrencies (currently bitcoin and litecoin) with support for others being worked on.

## Project Status

### Accomplished

• Basic bitcoin functionality has been added.

• Basic Litecoin functionality has been added.

• Documentation standards have been heightened -- Every public method in NodeManager and DataManager must have some documentation explaining the parameters, returned variable, and the purpose of the method.

### Next Update
• Problems with bcoin's scanning methods and a lack of a websocket for new tx notifications prevent sending and receiving balances serverside although clientside functionality exists. Fixes will be in node.js for the backend.

• Etherium functionality will be researched


## Getting Started

This is an Xcode project written entirely in Swift 3.0. You will need [the latest version or a version that supports your needs.](https://stackoverflow.com/questions/10335747/how-to-download-xcode-dmg-or-xip-file)

[CocoaPods](https://cocoapods.org/) is the go to package manager for most iOS developers and as such is the manager I have chosen as well. All the packages are found in the `Podfile` file. To install the dependacies, go to the folder you've cloned the repository to and make sure you can see the `Podfile`. In terminal, type in 

```
$ pod install
```

This will install the [realm ORM](https://realm.io/docs/swift/latest/) which the project is based on. At some point this may be deprecated, but for quick deploying purposes this is here.

### Setting up serverside Crypto Nodes 

You will need a [bcoin](http://bcoin.io/) as well as [lcoin](https://github.com/bcoin-org/lcoin) node running. You can follow the instructions for setting up a bitcoin node with bcoin [here](https://github.com/bcoin-org/bcoin) and since lcoin is a direct fork of bcoin, the setup instructions and command flags will be the same. Hail uses bitcoin's REST api to broadcast transactions and listen for new transactions. Keep in mind that you should probably run a full node for production.

NOTE: I have found bcoin and lcoin to be inconsistent among their own api's as well as compared to each others. I have documented these differences in the codebase and once the project is finished, will create a github wiki to better show their differences. One important difference to note across lcoin and bcoin is while bcoin does not require authentication for most of the api calls, lcoin does.

**Aliases to add to your bashrc if you would like**

```
alias bcoin_regtest="bcoin --network regtest --prefix=/Users/$USER/.bcoin/regtest" 
alias bcoin_testnet="bcoin --network testnet --prefix=/Users/$USER/.bcoin/testnet" --api-key=iamsatoshi
alias bcoin_mainnet="bcoin --network main --prefix=/Users/$USER/.bcoin/mainnet" --api-key=iamsatoshi

alias lcoin_regtest="lcoin --network regtest --prefix=/Users/$USER/.lcoin/regtest" 
alias lcoin_testnet="lcoin --network testnet --prefix=/Users/$USER/.lcoin/testnet" --api-key=iamsatoshi
alias lcoin_mainnet="lcoin --network main --prefix=/Users/$USER/.lcoin/mainnet" --api-key=iamsatoshi
```

Be sure to create `~/.lcoin` and `~/.bcoin` with 3 subfolders for each network per coin
