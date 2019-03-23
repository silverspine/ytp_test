
# YTP Test api
Sample api developped in rails as a code sample for YTP

* Ruby version `2.6`
* Rails version `5.2.2.1`
* DB driver `postgres`
* DB name `ytp_test`

## Seeded admin credentials
* `{ "email":"admin@ytp.com", "password":"sekret" }`

## Links
* [Heroku app (https://afternoon-everglades-13693.herokuapp.com)](https://afternoon-everglades-13693.herokuapp.com)
* [Git Repo](https://github.com/silverspine/ytp_test)

## Routes
All the routes are in the standard RESTful resource format, where user has accounts has movements
(`/users/:user_id/accounts/:account_id/movements/:id`) exept for a few noteworthy routes.

Method | route | request | notes
--- | --- | --- | ---
`POST` | `/auth/login` | `{ "email":"admin@ytp.com", "password":"sekret" }` | authenticates a user and returns a jwt token
`POST` | `/users/:user_id/accounts/:id/transfer` | `{ "CLABE":"asdfasd","amount":300 }` | makes a transfer from `:id` account of `user_id` user to `CLABE` destination account for the `amount`

Keep in mind that all routes require the Authentication header except for `/auth/login`
