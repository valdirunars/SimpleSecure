# SimpleSecure
## Using the module

Using Swift Package Manager, add git url to Package.swift's dependencies


```swift
let package = Package(
                      name: "YourProject",
                      targets: [
                        Target(name: "YourProject", dependencies: [])
                      ],
                      dependencies: [
                        .Package(url: "https://github.com/valdirunars/SimpleSecure", majorVersion: 1, minor: 0)
                      ],
                      exclude: ["Makefile", "Package-Builder"])
```

You can then use the SimpleSecure module to secure your API
```swift
import SimpleSecure

let router: Router = Router()
SimpleOAuth2.sharedInstance.publicPaths = [
  "/",
  "/static/*",
]
SimpleOAuth2.sharedInstance.restrictedPaths = [
    "/adminJSON": "admin",
    "/userJSON": "user,admin"
]

SimpleOAuth2.sharedInstance.simplySecure(router: router, with: [
    SimpleCredential(clientId: "1234", clientSecret: "4321", scope: "admin"),
    SimpleCredential(clientId: "4321", clientSecret: "1234", scope: "user")
])
```

              
