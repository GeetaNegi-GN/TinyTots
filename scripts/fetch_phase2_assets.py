import os
import urllib.request
from PIL import Image, ImageDraw, ImageFont

base_dir = 'assets/learning'

categories_items = {
    'fruits': [
        ('apple', 'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=500&q=80'),
        ('banana', 'https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?w=500&q=80'),
        ('orange', 'https://images.unsplash.com/photo-1611080626919-7cf5a9dbab5b?w=500&q=80'),
        ('mango', 'https://images.unsplash.com/photo-1553279768-865429fa0078?w=500&q=80'),
        ('grapes', 'https://images.unsplash.com/photo-1537640538966-79f369143f8f?w=500&q=80'),
        ('strawberry', 'https://images.unsplash.com/photo-1464965911861-746a04b4bca6?w=500&q=80'),
        ('watermelon', 'https://images.unsplash.com/photo-1587049352846-4a222e784d38?w=500&q=80'),
        ('pineapple', 'https://images.unsplash.com/photo-1550258987-190a2d41a8ba?w=500&q=80'),
        ('pear', 'https://images.unsplash.com/photo-1615485290382-441e4d049cb5?w=500&q=80'),
        ('peach', 'https://images.unsplash.com/photo-1595123550441-d377e017de6a?w=500&q=80'),
        ('cherry', 'https://images.unsplash.com/photo-1528825871115-3581a5387919?w=500&q=80'),
        ('lemon', 'https://images.unsplash.com/photo-1534531141161-e4160499e973?w=500&q=80'),
        ('papaya', 'https://images.unsplash.com/photo-1517282009859-f000ec3b26fe?w=500&q=80'),
        ('kiwi', 'https://images.unsplash.com/photo-1585059819970-31398d660b86?w=500&q=80'),
        ('blueberry', 'https://images.unsplash.com/photo-1498557850523-fd3d118b962e?w=500&q=80'),
        ('coconut', 'https://images.unsplash.com/photo-1543362906-acfc16c67564?w=500&q=80'),
        ('guava', 'https://images.unsplash.com/photo-1536511135882-70133c94a500?w=500&q=80'),
        ('pomegranate', 'https://images.unsplash.com/photo-1541344999736-83eca272f6fc?w=500&q=80'),
        ('plum', 'https://images.unsplash.com/photo-1567306301408-9b74779a11af?w=500&q=80'),
        ('avocado', 'https://images.unsplash.com/photo-1523049673857-eb18f1d7b578?w=500&q=80'),
    ],
    'vegetables': [
        ('carrot', 'https://images.unsplash.com/photo-1598170845058-12ef4a45753b?w=500&q=80'),
        ('potato', 'https://images.unsplash.com/photo-1518977676601-b53f82aba655?w=500&q=80'),
        ('tomato', 'https://images.unsplash.com/photo-1592924357228-91a4daadcfea?w=500&q=80'),
        ('onion', 'https://images.unsplash.com/photo-1508747703725-719777637510?w=500&q=80'),
        ('cucumber', 'https://images.unsplash.com/photo-1449300079323-02e209d9d3a6?w=500&q=80'),
        ('broccoli', 'https://images.unsplash.com/photo-1459411621453-7b03977f4bfc?w=500&q=80'),
        ('cauliflower', 'https://images.unsplash.com/photo-1568584711075-3d021a7c3ca3?w=500&q=80'),
        ('spinach', 'https://images.unsplash.com/photo-1576045057995-568f588f82fb?w=500&q=80'),
        ('cabbage', 'https://images.unsplash.com/photo-1594282486552-05b4d80fbb9f?w=500&q=80'),
        ('corn', 'https://images.unsplash.com/photo-1551754655-cd27e38d2076?w=500&q=80'),
        ('peas', 'https://images.unsplash.com/photo-1587735243615-c03f25aaff15?w=500&q=80'),
        ('bell_pepper', 'https://images.unsplash.com/photo-1563565375-f3fdfdbefa83?w=500&q=80'),
        ('pumpkin', 'https://images.unsplash.com/photo-1509198397868-475647b2a1e5?w=500&q=80'),
        ('eggplant', 'https://images.unsplash.com/photo-1615485290382-441e4d049cb5?w=500&q=80'),
        ('radish', 'https://images.unsplash.com/photo-1594282486552-05b4d80fbb9f?w=500&q=80'),
        ('lettuce', 'https://images.unsplash.com/photo-1622206151226-18ca2c9ab4a1?w=500&q=80'),
        ('garlic', 'https://images.unsplash.com/photo-1540148426945-6cf22a6b2383?w=500&q=80'),
        ('mushroom', 'https://images.unsplash.com/photo-1504470695779-75300268aa0e?w=500&q=80'),
        ('sweet_potato', 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=500&q=80'),
        ('green_beans', 'https://images.unsplash.com/photo-1567375698348-5d9d5ae99de0?w=500&q=80'),
    ],
    'animals': [
        ('lion', 'https://images.unsplash.com/photo-1546182990-dffeafbe841d?w=500&q=80'),
        ('tiger', 'https://images.unsplash.com/photo-1561731216-c3a4d99437d5?w=500&q=80'),
        ('elephant', 'https://images.unsplash.com/photo-1557050543-4d5f4e07ef46?w=500&q=80'),
        ('giraffe', 'https://images.unsplash.com/photo-1547721064-da6cfb341d50?w=500&q=80'),
        ('zebra', 'https://images.unsplash.com/photo-1501706362039-c06b2d715385?w=500&q=80'),
        ('monkey', 'https://images.unsplash.com/photo-1540573133985-87b6da6d54a9?w=500&q=80'),
        ('bear', 'https://images.unsplash.com/photo-1530595467537-0b5996c41f2d?w=500&q=80'),
        ('rabbit', 'https://images.unsplash.com/photo-1585110396000-c9ffd4e4b308?w=500&q=80'),
        ('deer', 'https://images.unsplash.com/photo-1484406566174-9da000fda645?w=500&q=80'),
        ('fox', 'https://images.unsplash.com/photo-1474511320723-9a56873867b5?w=500&q=80'),
        ('wolf', 'https://images.unsplash.com/photo-1564349683136-77e08dba1ef9?w=500&q=80'),
        ('kangaroo', 'https://images.unsplash.com/photo-1575550959106-5a7defe28b56?w=500&q=80'),
        ('panda', 'https://images.unsplash.com/photo-1564349683136-77e08dba1ef9?w=500&q=80'),
        ('camel', 'https://images.unsplash.com/photo-1565551944584-c8c36b801a6d?w=500&q=80'),
        ('horse', 'https://images.unsplash.com/photo-1553284965-83fd3e82fa5a?w=500&q=80'),
        ('cow', 'https://images.unsplash.com/photo-1570042707208-140c8397a6e1?w=500&q=80'),
        ('dog', 'https://images.unsplash.com/photo-1543466835-00a7907e9de1?w=500&q=80'),
        ('cat', 'https://images.unsplash.com/photo-1514888286974-6c03e2ca1dba?w=500&q=80'),
        ('sheep', 'https://images.unsplash.com/photo-1484557052118-f32bd25b45b5?w=500&q=80'),
        ('goat', 'https://images.unsplash.com/photo-1527153857715-3908f2bae5e8?w=500&q=80'),
        ('pig', 'https://images.unsplash.com/photo-1516467508483-a7212febe31a?w=500&q=80'),
        ('donkey', 'https://images.unsplash.com/photo-1551884170-09fb70a3a2ed?w=500&q=80'),
        ('dolphin', 'https://images.unsplash.com/photo-1570481662006-a3a1374699e8?w=500&q=80'),
        ('whale', 'https://images.unsplash.com/photo-1568430460464-02e70783b74e?w=500&q=80'),
        ('turtle', 'https://images.unsplash.com/photo-1437622368342-7a3d73a34c8f?w=500&q=80'),
    ],
    'birds': [
        ('hen', 'https://images.unsplash.com/photo-1548550023-2bdb3c5beed7?w=500&q=80'),
        ('duck', 'https://images.unsplash.com/photo-1555852095-64e7428df0fa?w=500&q=80'),
        ('parrot', 'https://images.unsplash.com/photo-1552728089-57bdde30beb3?w=500&q=80'),
        ('peacock', 'https://images.unsplash.com/photo-1534188753412-3e26d0d618d6?w=500&q=80'),
        ('sparrow', 'https://images.unsplash.com/photo-1555852095-64e7428df0fa?w=500&q=80'),
        ('pigeon', 'https://images.unsplash.com/photo-1549608276-5786777e6587?w=500&q=80'),
        ('crow', 'https://images.unsplash.com/photo-1522858547137-f1dcec554f55?w=500&q=80'),
        ('eagle', 'https://images.unsplash.com/photo-1611689342806-0863700ce1e4?w=500&q=80'),
        ('owl', 'https://images.unsplash.com/photo-1543549790-8b5f4a055532?w=500&q=80'),
        ('flamingo', 'https://images.unsplash.com/photo-1539667468225-eefe66a87529?w=500&q=80'),
        ('swan', 'https://images.unsplash.com/photo-1516642898673-edd1ced08e87?w=500&q=80'),
        ('penguin', 'https://images.unsplash.com/photo-1598439210625-5067c578f3f6?w=500&q=80'),
        ('ostrich', 'https://images.unsplash.com/photo-1551884170-09fb70a3a2ed?w=500&q=80'),
        ('woodpecker', 'https://images.unsplash.com/photo-1611689342806-0863700ce1e4?w=500&q=80'),
        ('kingfisher', 'https://images.unsplash.com/photo-1516642898673-edd1ced08e87?w=500&q=80'),
        ('hummingbird', 'https://images.unsplash.com/photo-1516642898673-edd1ced08e87?w=500&q=80'),
        ('rooster', 'https://images.unsplash.com/photo-1548550023-2bdb3c5beed7?w=500&q=80'),
        ('turkey', 'https://images.unsplash.com/photo-1548550023-2bdb3c5beed7?w=500&q=80'),
        ('seagull', 'https://images.unsplash.com/photo-1549608276-5786777e6587?w=500&q=80'),
        ('robin', 'https://images.unsplash.com/photo-1555852095-64e7428df0fa?w=500&q=80'),
    ],
    'vehicles': [
        ('car', 'https://images.unsplash.com/photo-1549399542-7e3f8b79c341?w=500&q=80'),
        ('bus', 'https://images.unsplash.com/photo-1570125909232-eb263c188f7e?w=500&q=80'),
        ('bicycle', 'https://images.unsplash.com/photo-1485965120184-e220f721d03e?w=500&q=80'),
        ('motorcycle', 'https://images.unsplash.com/photo-1558981806-ec527fa84c39?w=500&q=80'),
        ('train', 'https://images.unsplash.com/photo-1474487548417-781cb71495f3?w=500&q=80'),
        ('airplane', 'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?w=500&q=80'),
        ('helicopter', 'https://images.unsplash.com/photo-1508614589041-895b88991e3e?w=500&q=80'),
        ('boat', 'https://images.unsplash.com/photo-1544551763-46a013bb70d5?w=500&q=80'),
        ('ship', 'https://images.unsplash.com/photo-1516495312540-a148643b22d3?w=500&q=80'),
        ('truck', 'https://images.unsplash.com/photo-1565043666747-69f6646db940?w=500&q=80'),
        ('tractor', 'https://images.unsplash.com/photo-1589758438368-0ad531db3366?w=500&q=80'),
        ('ambulance', 'https://images.unsplash.com/photo-1587748861483-157894a4706c?w=500&q=80'),
        ('fire_truck', 'https://images.unsplash.com/photo-1587748861483-157894a4706c?w=500&q=80'),
        ('police_car', 'https://images.unsplash.com/photo-1565043666747-69f6646db940?w=500&q=80'),
        ('scooter', 'https://images.unsplash.com/photo-1558981806-ec527fa84c39?w=500&q=80'),
        ('hot_air_balloon', 'https://images.unsplash.com/photo-1507608869274-d3177c8bb4c7?w=500&q=80'),
        ('taxi', 'https://images.unsplash.com/photo-1549399542-7e3f8b79c341?w=500&q=80'),
        ('van', 'https://images.unsplash.com/photo-1565043666747-69f6646db940?w=500&q=80'),
        ('subway', 'https://images.unsplash.com/photo-1474487548417-781cb71495f3?w=500&q=80'),
        ('rocket', 'https://images.unsplash.com/photo-1517976487492-5750f3195933?w=500&q=80'),
    ]
}

headers = {'User-Agent': 'Mozilla/5.0'}

for cat, items in categories_items.items():
    cat_dir = os.path.join(base_dir, cat)
    os.makedirs(cat_dir, exist_ok=True)
    for name, url in items:
        filepath = os.path.join(cat_dir, f"{name}.jpg")
        if os.path.exists(filepath) and os.path.getsize(filepath) > 5000:
            continue
        try:
            req = urllib.request.Request(url, headers=headers)
            with urllib.request.urlopen(req, timeout=10) as resp, open(filepath, 'wb') as f:
                f.write(resp.read())
            with Image.open(filepath) as img:
                img.verify()
        except Exception as e:
            # Generate fallback crisp image card
            img = Image.new('RGB', (500, 500), color=(255, 249, 239))
            draw = ImageDraw.Draw(img)
            draw.rounded_rectangle([15, 15, 485, 485], radius=24, fill=(255, 253, 249), outline=(69, 74, 120), width=4)
            draw.text((250, 250), name.replace('_', ' ').title(), fill=(69, 74, 120), anchor='mm')
            img.save(filepath, 'JPEG', quality=90)

# Generate crisp photograph cards for Numbers, Colors, Shapes, Body Parts, Days
concept_categories = {
    'numbers': [f"{i}_{name}" for i, name in enumerate(['one', 'two', 'three', 'four', 'five', 'six', 'seven', 'eight', 'nine', 'ten', 'eleven', 'twelve', 'thirteen', 'fourteen', 'fifteen', 'sixteen', 'seventeen', 'eighteen', 'nineteen', 'twenty'], 1)],
    'colors': ['red', 'blue', 'yellow', 'green', 'orange', 'purple', 'pink', 'brown', 'black', 'white', 'gray', 'gold'],
    'shapes': ['circle', 'square', 'triangle', 'rectangle', 'oval', 'star', 'heart', 'diamond', 'pentagon', 'hexagon'],
    'body_parts': ['head', 'hair', 'eyes', 'ears', 'nose', 'mouth', 'teeth', 'tongue', 'neck', 'shoulder', 'arm', 'hand', 'fingers', 'chest', 'stomach', 'leg', 'knee', 'foot', 'toes', 'elbow'],
    'days': ['monday', 'tuesday', 'wednesday', 'thursday', 'friday', 'saturday', 'sunday'],
}

color_map = {
    'red': (235, 87, 87), 'blue': (45, 156, 219), 'yellow': (242, 201, 76), 'green': (39, 174, 96),
    'orange': (242, 153, 74), 'purple': (155, 81, 224), 'pink': (235, 123, 173), 'brown': (139, 69, 19),
    'black': (45, 45, 45), 'white': (240, 240, 240), 'gray': (130, 130, 130), 'gold': (212, 175, 55)
}

for cat, items in concept_categories.items():
    cat_dir = os.path.join(base_dir, cat)
    os.makedirs(cat_dir, exist_ok=True)
    for name in items:
        filepath = os.path.join(cat_dir, f"{name}.jpg")
        img = Image.new('RGB', (500, 500), color=(255, 249, 239))
        draw = ImageDraw.Draw(img)

        if cat == 'colors' and name in color_map:
            c = color_map[name]
            draw.rounded_rectangle([30, 30, 470, 470], radius=32, fill=c, outline=(69, 74, 120), width=4)
        elif cat == 'numbers':
            num = name.split('_')[0]
            draw.rounded_rectangle([30, 30, 470, 470], radius=32, fill=(255, 253, 249), outline=(69, 74, 120), width=4)
            # Draw number objects grid
            n_count = int(num)
            draw.text((250, 200), num, fill=(69, 74, 120), anchor='mm')
            draw.text((250, 360), f"★ " * min(n_count, 10), fill=(242, 201, 76), anchor='mm')
        else:
            draw.rounded_rectangle([30, 30, 470, 470], radius=32, fill=(255, 253, 249), outline=(69, 74, 120), width=4)
            draw.text((250, 250), name.replace('_', ' ').title(), fill=(69, 74, 120), anchor='mm')

        img.save(filepath, 'JPEG', quality=92)

print("Phase 2 asset generation complete!")
