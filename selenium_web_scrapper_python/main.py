from ShopScrapper import ShopScrapper
from Tokped import Tokopedia
import requests
import json
from flask import Flask

headers = {"Content-Type": "application/json; charset=utf-8", "x-hasura-admin-secret": "mythesis"}
menu_options = {
    1: 'Storage',
    2: 'Ram',
    3: 'Option 3',
    4: 'Exit',
}


def print_menu():
    for key in menu_options.keys():
        print(key, '--', menu_options[key])


def handle_request(request, data):
    print("Status Code", request.status_code)
    # print("JSON Response ", data)
    print(data)

    shop_scrapper = ShopScrapper(data)
    data2 = shop_scrapper.run()
    shop_scrapper.to_excel(data2)

    return data2


def put_ram(datas):
    for data in datas:
        print(f'Updating data {data["id"]} with price {data["price"]}')
        try:
            requests.put("https://hasura-skripsi-binus.herokuapp.com/api/rest/update-ram-price",
                         params={'id': data['id'], 'price': data['price']},
                         headers=headers)
        except requests.exceptions.RequestException as e:
            raise SystemExit(e)


def put_storage(datas):
    for data in datas:
        print(f'Updating data {data["id"]}')
        try:
            requests.put("https://hasura-skripsi-binus.herokuapp.com/api/rest/update-storage-price",
                         params={'id': data['id'], 'price': data['price']},
                         headers=headers)
        except requests.exceptions.RequestException as e:
            raise SystemExit(e)


if __name__ == '__main__':
    # {
    #   id
    #   storage_id / free key id (unused)
    #   name
    #   shop
    #   shop_link
    # }
    # }
    print_menu()
    option = int(input('Enter your choice: '))
    if option == 1:
        print('Handle option \'Option 1\'')
        try:
            req = requests.request(method='GET',
                                   url='https://hasura-skripsi-binus.herokuapp.com/api/rest/storage-prices',
                                   headers=headers)
        except requests.exceptions.RequestException as e:  # This is the correct syntax
            raise SystemExit(e)
        json_data = req.json()['storage_prices']
        result = handle_request(request=req, data=json_data)
        put_storage(result)
    elif option == 2:
        print('Handle option \'Option 2\'')
        try:
            req = requests.request(method='GET',
                                   url='https://hasura-skripsi-binus.herokuapp.com/api/rest/ram-prices',
                                   headers=headers)
        except requests.exceptions.RequestException as e:  # This is the correct syntax
            raise SystemExit(e)
        json_data = req.json()['ram_prices']
        result = handle_request(request=req, data=json_data)
        put_ram(result)
    elif option == 3:
        print('Handle option \'Option 3\'')
    elif option == 4:
        print('Thanks message before exiting')
        exit()
    else:
        print('Invalid option. Please enter a number between 1 and 4.')
