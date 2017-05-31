# Bonghwa

Bonghwa is a private SNS for small group.

## Dev setup with docker

```
docker-compose up
```

That's enough. And you could use frontend page with port `5200`, and backend with `5100`

### Initial Configuration

```bash
# Some env variables for dev
cp config/application.yml.example config/application.yml

# this will generate seed data
bin/docker-manage.sh db:migrate db:seed
```

### Sign up new user

- Fill form on `localhost:5100/users/sign_up` (Notice that you need to logout)
- Login with admin account on `localhost:5100/users/sign_in` (don't care error page)
- Access `localhost:5100/admin/users` and find user which you just added
- Click `Level up`
- Then you can use that user for frontend development.

### How to Contribute

Here is general process.

- Take issue (Optional)
- Make patch
- Open Pull Request
- Request review

PR will be merged and deployed after review approval.

## Code Status

[![Build Status](https://travis-ci.org/riseshia/Bonghwa.svg?branch=master)](https://travis-ci.org/riseshia/Bonghwa)

## Code Climate

[![Coverage Status](https://coveralls.io/repos/github/riseshia/Bonghwa/badge.svg?branch=master)](https://coveralls.io/github/riseshia/Bonghwa?branch=master)

## License
Bonghwa is released under the [MIT License](http://www.opensource.org/licenses/MIT).
