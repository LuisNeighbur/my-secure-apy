I've created a simple FastAPI application with JWT authentication and some dummy endpoints. Here's how to use it:

1. First, install the requirements:
```bash
pip install -r requirements.txt
```

2. Run the server:
```bash
uvicorn main:app --reload
```

The API includes these endpoints:

1. `/token` (POST): Get JWT token
   - Use username: "johndoe" and password: "secret"

2. `/users/me` (GET): Get current user info
   - Requires JWT token

3. `/products` (GET): Get all products
   - Requires JWT token

4. `/products/{product_id}` (GET): Get specific product
   - Requires JWT token

To test the API:

1. Get a token:
```bash
token=$(curl -X POST "http://localhost:8000/token" -H "Content-Type: application/x-www-form-urlencoded" -d "username=johndoe&password=secret" | jq -r .access_token)
```

2. Use the token to access protected endpoints:
```bash
 curl -H "Authorization: Bearer $token" http://localhost:8000/products
```
```bash
 curl -H "Authorization: Bearer $token" http://localhost:8000/products/1
```
```bash
 curl -H "Authorization: Bearer $token" http://localhost:8000/users/me
```
You can also explore the API documentation at `http://localhost:8000/docs` after starting the server.

Would you like me to explain any part of the code or add more features to the API?