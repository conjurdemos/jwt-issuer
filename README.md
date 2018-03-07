# jwt-issuer
Mock service for issuing JWT tokens which contain arbitrary data to be consumed by authn-jwt.
## Building
```
$ ./bin/build
```
## Endpoints
#### GET /jwt
Retrieve an [RFC 7519](https://tools.ietf.org/html/rfc7519) compliant JSON web token containing arbitrary payload properties provided by query parameters. Return values can be pasted into https://jwt.io/ for debugging and inspection.
###### Example
```
$ curl "localhost:3000/token?iss=localhost&aud=conjur&claim=admin&ip=127.0.0.1"
eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IjE4ZmU4NDA1MWNjMmZjNWU2MDZkMjc1YTFiYzhjNDkwNzY5OTUxNGMiLCJ4NXUiOiIva2V5LzE4ZmU4NDA1MWNjMmZjNWU2MDZkMjc1YTFiYzhjNDkwNzY5OTUxNGMifQ.eyJleHAiOjE1MTY2NDU3MDUsImlhdCI6MTUxNjY0NTUyNSwiaXNzIjoibG9jYWxob3N0IiwiYXVkIjoiY29uanVyIiwiY2xhaW0iOiJhZG1pbiIsImlwIjoiMTI3LjAuMC4xIn0.nPuRS3VPtDxDl5tScYC4Vt6KVY83m5DLW5LBwwkPbNTyBrb8WR_8YDC2IMotQRS9xIiPdCNkhuwmNZTQQdiDJ4EVApZS8Y0pTgnD8xdC1D15xnA0yiEARiGhsOUYs1MTfnGF8fgUXlQ6TW-MQy1zh-Cnuc43YW4wWXOxOpBgy6Q2uLgL5rIpxBF5v-_9_f6WDbDSMVQxWOYPlWLsMAmA_5gOOBQC04lrZOHXpzw02_cS8DLDuYcJXyNIazvZDyX6SVXw2Xi1mzMP1THl1Rr3FYNXmI7TIfFXG-g8COsXAJTKesRiQTMiHfq9X0uD7j5REcoyS_g11Di2dpercw5wNg
```

#### GET /jwk/:kid
Retrieve an [RFC 7517](https://tools.ietf.org/html/rfc7517) compliant JSON web key to validate the signature of a previously issued JWT. This service will create a self-signed certificate on startup, signing all JWTs with the associated private key. The `kid` URI parameter is to be populated by the value of `x5u` within an issued JWT header.
###### Example
```
$ curl "localhost:3000/jwt/18fe84051cc2fc5e606d275a1bc8c4907699514c"
{"kty":"RSA","kid":"18fe84051cc2fc5e606d275a1bc8c4907699514c","x5t":"18fe84051cc2fc5e606d275a1bc8c4907699514c","x5c":["MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA1QvwotnOvR9luZk0J86C\nbwhMxr5JhBlzW9ZU6C1fjJ0Nz3EKYQ4pRg4PZF6l39JWPTUAsXjwvhuPO8jU4TBw\nsEz5/IYqVtrQ7BM++hpVApON4bkLU3UMmwPJUm7V5nzN/ebwTcy9FfthfcOR6+er\nhxaLpJk5pTHRTT8FpXweEHKwrxqyCcfXivAIwaIaSmiTajQNaDOAE4WhyhBRf5dI\ndVpTO4UIIGBJOfBZlyyQSdCVXqnWiaxKodgyJ9c+oPVovXL2/5v4PO/1j7Bxjzow\nq01HiHMFFsdyO1p8hdMK645jQ2UhVqOQV3goboN2BLW4eiQg4obZHfbQNyluEyTi\nNwIDAQAB\n"]}
```