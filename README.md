# APIs Documentation

This documentation describes the various API endpoints available in the collection, including their methods, inputs, and parameters.

All resource accessing endpoints require a Bearer Token in the Authorization header

## Authentication Endpoints

### 1. Login
- **Method**: `POST`
- **URL**: `http://localhost:3000/login`
- **Description**: Logs in a user with email and password.
- **Body (raw)**:
    ```json
    {
      "user": {
        "email": "test@test.com",
        "password": "password"
      }
    }
    ```

### 2. Signup
- **Method**: `POST`
- **URL**: `http://localhost:3000/signup`
- **Description**: Registers a new user with name, email, password, and image.
- **Body (form-data)**:
    - `user[name]`: (type: `text`) Example: `"IMAGE USER"`
    - `user[email]`: (type: `text`) Example: `"test11@test.com"`
    - `user[password]`: (type: `text`) Example: `"password"`
    - `user[image]`: (type: `file`) Example: `picture.png`

### 3. Logout
- **Method**: `DELETE`
- **URL**: `http://localhost:3000/logout`
- **Description**: Logs out the user.
- **Authentication**: Bearer Token

---

## Post Endpoints

### 1. List Posts
- **Method**: `GET`
- **URL**: `http://localhost:3000/posts`
- **Description**: Retrieves a list of posts.

### 2. Create Post
- **Method**: `POST`
- **URL**: `http://localhost:3000/posts`
- **Description**: Creates a new post.
- **Body (raw)**:
    ```json
    {
      "post": {
        "title": "test",
        "body": "body",
        "tags": ["Test", "Technology"]
      }
    }
    ```

### 3. Update Post
- **Method**: `PATCH`
- **URL**: `http://localhost:3000/posts/18`
- **Description**: Updates the body and tags of an existing post.
- **Body (raw)**:
    ```json
    {
      "post": {
        "body": "updated body for post 18",
        "tags": ["Ruby on Rails", "Web Development"]
      }
    }
    ```

### 4. Delete Post
- **Method**: `DELETE`
- **URL**: `http://localhost:3000/posts/1`
- **Description**: Deletes a post by ID.

---

## Comment Endpoints

### 1. List Comments for a Post
- **Method**: `GET`
- **URL**: `http://localhost:3000/posts/1/comments`
- **Description**: Retrieves comments for a specific post.

### 2. Create Comment
- **Method**: `POST`
- **URL**: `http://localhost:3000/posts/1232/comments`
- **Description**: Creates a new comment for a specific post.
- **Body (raw)**:
    ```json
    {
      "comment": {
        "body": "this is a new comment"
      }
    }
    ```

### 3. Update Comment
- **Method**: `PATCH`
- **URL**: `http://localhost:3000/comments/12342`
- **Description**: Updates the body of an existing comment.
- **Body (raw)**:
    ```json
    {
      "comment": {
        "body": "updated body"
      }
    }
    ```

### 4. Delete Comment
- **Method**: `DELETE`
- **URL**: `http://localhost:3000/comments/1`
- **Description**: Deletes a comment by ID.
