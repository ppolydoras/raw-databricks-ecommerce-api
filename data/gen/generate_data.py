import pandas as pd
from faker import Faker
import faker_commerce
import random
from datetime import datetime, timedelta

fake = Faker()
fake.add_provider(faker_commerce.Provider)
num_customers = 5000
num_products = 2000
num_categories = 100
num_suppliers = 200
num_orders = 20000
num_reviews = 3000
num_inventory_records = num_products

# Generate Customers
customers = []
for customer_id in range(1, num_customers + 1):
    customers.append({
        'customer_id': customer_id,
        'first_name': fake.first_name(),
        'last_name': fake.last_name(),
        'email': fake.email(),
        'phone': fake.phone_number(),
        'address': fake.street_address(),
        'city': fake.city(),
        'state': fake.state(),
        'zip_code': fake.zipcode(),
        'registration_date': fake.date_between(start_date='-2y', end_date='today')
    })
customers_df = pd.DataFrame(customers)

# Generate Categories
categories = []
for category_id in range(1, num_categories + 1):
    categories.append({
        'category_id': category_id,
        'category_name': fake.ecommerce_category(),
        'description': fake.sentence(nb_words=10)
    })
categories_df = pd.DataFrame(categories)

# Generate Suppliers
suppliers = []
for supplier_id in range(1, num_suppliers + 1):
    suppliers.append({
        'supplier_id': supplier_id,
        'supplier_name': fake.company(),
        'contact_name': fake.name(),
        'contact_email': fake.company_email(),
        'phone': fake.phone_number(),
        'address': fake.address()
    })
suppliers_df = pd.DataFrame(suppliers)

# Generate Products
products = []
for product_id in range(1, num_products + 1):
    products.append({
        'product_id': product_id,
        'product_name': fake.ecommerce_category(),
        'category_id': random.randint(1, num_categories),
        'supplier_id': random.randint(1, num_suppliers),
        'price': round(random.uniform(5.0, 500.0), 2),
        'description': fake.sentence(nb_words=15)
    })
products_df = pd.DataFrame(products)

# Generate Inventory
inventory = []
for product in products:
    inventory.append({
        'inventory_id': product['product_id'],
        'product_id': product['product_id'],
        'quantity_in_stock': random.randint(0, 1000),
        'last_updated': fake.date_between(start_date='-1y', end_date='today')
    })
inventory_df = pd.DataFrame(inventory)

# Generate Orders
orders = []
order_items = []
order_item_id = 1
for order_id in range(1, num_orders + 1):
    customer_id = random.randint(1, num_customers)
    order_date = fake.date_between(start_date='-1y', end_date='today')
    status = random.choice(['Processing', 'Shipped', 'Delivered', 'Cancelled'])
    num_items = random.randint(1, 5)
    total_amount = 0.0
    for _ in range(num_items):
        product = random.choice(products)
        quantity = random.randint(1, 10)
        unit_price = product['price']
        total_amount += unit_price * quantity
        order_items.append({
            'order_item_id': order_item_id,
            'order_id': order_id,
            'product_id': product['product_id'],
            'quantity': quantity,
            'unit_price': unit_price
        })
        order_item_id += 1
    orders.append({
        'order_id': order_id,
        'customer_id': customer_id,
        'order_date': order_date,
        'status': status,
        'total_amount': round(total_amount, 2)
    })
orders_df = pd.DataFrame(orders)
order_items_df = pd.DataFrame(order_items)

# Generate Reviews
reviews = []
for review_id in range(1, num_reviews + 1):
    reviews.append({
        'review_id': review_id,
        'product_id': random.randint(1, num_products),
        'customer_id': random.randint(1, num_customers),
        'rating': random.randint(1, 5),
        'review_text': fake.sentence(nb_words=20),
        'review_date': fake.date_between(start_date='-1y', end_date='today')
    })
reviews_df = pd.DataFrame(reviews)

# Save DataFrames to CSV
customers_df.to_csv('customers.csv', index=False)
categories_df.to_csv('categories.csv', index=False)
suppliers_df.to_csv('suppliers.csv', index=False)
products_df.to_csv('products.csv', index=False)
inventory_df.to_csv('inventory.csv', index=False)
orders_df.to_csv('orders.csv', index=False)
order_items_df.to_csv('order_items.csv', index=False)
reviews_df.to_csv('reviews.csv', index=False)
