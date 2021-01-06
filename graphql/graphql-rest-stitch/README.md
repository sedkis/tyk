Import the API def in this directory, then use the following query in the playground:


```
query {
  users(id: 4) {
    id
    username
    posts {
      id
      userId
      comments {
        email
        name
      }
    }
  }
}
```