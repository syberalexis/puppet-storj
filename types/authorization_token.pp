# @summary Storj authorization token. See https://documentation.storj.io/before-you-begin/auth-token
type Storj::Authorization_token = Pattern[/[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}:[A-Za-z0-9]+/]
