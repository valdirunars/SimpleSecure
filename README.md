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
    "/adminJSON": $someScope,
    "/userJSON": "$someScope,$someOtherScope
]

SimpleOAuth2.sharedInstance.simplySecure(router: router, with: [
    SimpleCredential(clientId: $someClient, clientSecret: $someSecret, scope: $someScope),
    SimpleCredential(clientId: $someOtherClient, clientSecret: $someOtherSecret, scope: $someOtherScope)
])
```

Send as simple HTTP POST request to the /oauth2/authorize with the following body

```JSON
{
  	"grant_type":"client_credentials",
  	"client_id": $secret,
  	"client_secret": $secret,
  	"scope": $scope
}
```
You will receive a token response similar to the one below:

```JSON
{
    "token_type": "Bearer",
    "access_token": "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiIxMjM0IiwiaWF0IjoxNDgzMzEyOTE5LjEwMDQyOSwiZXhwIjoxNDgzMzE0NzE5LjEwMDQ0Miwic2NvcGUiOiJhZG1pbiJ9.a8u-xUr8dui1hj-ri3eoe0qxPm2gVIHz6j8dIGgV2cLA7Y17s3zoGdu3C0R0BlZ_2pvv8cuEq5ULtMPt644WRw",
    "expires_in": "1800.0"
}
```             
              
