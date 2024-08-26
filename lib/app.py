from flask import Flask, request, jsonify
import mysql.connector

app = Flask(__name__)

def get_db_connection():
    connection = mysql.connector.connect(
        host='localhost',
        user='root',
        password='12111',
        database='montag'
    )
    return connection

@app.route('/search_product', methods=['GET'])
def search_product():
    name = request.args.get('name')
    connection = get_db_connection()
    cursor = connection.cursor()
    
    cursor.execute('SELECT * FROM products WHERE name = %s', (name,))
    products = cursor.fetchall()
    
    cursor.close()
    connection.close()
    
    if products:
        product_list = [{'id': product[0], 'name': product[1], 'price': product[2], 'discount': product[3], 'description': product[4]} for product in products]
        return jsonify({'status': 'success', 'product': product_list[0]})
    else:
        return jsonify({'status': 'failed', 'message': 'Product not found'})

@app.route('/login', methods=['POST'])
def login():
    if not request.is_json:
        return jsonify({'status': 'failed', 'message': 'Content-Type must be application/json'}), 415
    
    try:
        data = request.get_json()
    except Exception as e:
        return jsonify({'status': 'failed', 'message': 'Invalid JSON data'}), 400
    
    username = data.get('username')
    password = data.get('password')
    
    # TODO: Implement secure password comparison using bcrypt or argon2
    
    connection = get_db_connection()
    cursor = connection.cursor()
    
    cursor.execute('SELECT * FROM users WHERE username = %s', (username,))
    user = cursor.fetchone()
    
    cursor.close()
    connection.close()
    
    if user:
        return jsonify({'status': 'success', 'message': 'Logged in successfully!'})
    else:
        return jsonify({'status': 'failed', 'message': 'Login failed: Invalid username or password'})

@app.route('/add_product', methods=['POST'])
def add_product():
    if not request.is_json:
        return jsonify({'status': 'failed', 'message': 'Content-Type must be application/json'}), 415
    
    try:
        data = request.get_json()
    except Exception as e:
        return jsonify({'status': 'failed', 'message': 'Invalid JSON data'}), 400
    
    product_name = data.get('name')
    price = data.get('price')
    discount = data.get('discount')
    description = data.get('description')
    
    connection = get_db_connection()
    cursor = connection.cursor()
    
    cursor.execute('''
        INSERT INTO products (name, price, discount, description)
        VALUES (%s, %s, %s, %s)
    ''', (product_name, price, discount, description))
    
    connection.commit()
    
    cursor.close()
    connection.close()
    
    return jsonify({'status': 'success', 'message': 'Product added successfully!'})

@app.route('/update_product', methods=['POST'])
def update_product():
    if not request.is_json:
        return jsonify({'status': 'failed', 'message': 'Content-Type must be application/json'}), 415
    
    try:
        data = request.get_json()
    except Exception as e:
        return jsonify({'status': 'failed', 'message': 'Invalid JSON data'}), 400
    
    product_id = data.get('id')
    name = data.get('name')
    price = data.get('price')
    discount = data.get('discount')
    description = data.get('description')
    
    connection = get_db_connection()
    cursor = connection.cursor()
    
    cursor.execute('''
        UPDATE products
        SET name = %s, price = %s, discount = %s, description = %s
        WHERE id = %s
    ''', (name, price, discount, description, product_id))
    
    connection.commit()
    
    cursor.close()
    connection.close()
    
    return jsonify({'status': 'success', 'message': 'Product updated successfully!'})

@app.route('/delete_product', methods=['POST'])
def delete_product():
    if not request.is_json:
        return jsonify({'status': 'failed', 'message': 'Content-Type must be application/json'}), 415
    
    try:
        data = request.get_json()
    except Exception as e:
        return jsonify({'status': 'failed', 'message': 'Invalid JSON data'}), 400
    
    product_id = data.get('id')
    
    connection = get_db_connection()
    cursor = connection.cursor()
    
    cursor.execute('DELETE FROM products WHERE id = %s', (product_id,))
    
    connection.commit()
    
    cursor.close()
    connection.close()
    
    return jsonify({'status': 'success', 'message': 'Product deleted successfully!'})

@app.route('/display_products', methods=['GET'])
def display_products():
    connection = get_db_connection()
    cursor = connection.cursor()
    
    cursor.execute('SELECT * FROM products')
    products = cursor.fetchall()
    
    cursor.close()
    connection.close()
    
    product_list = [{'id': product[0], 'name': product[1], 'price': product[2], 'discount': product[3], 'description': product[4]} for product in products]
    return jsonify({'products': product_list})

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
