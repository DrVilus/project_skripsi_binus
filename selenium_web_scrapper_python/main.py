from ShopScrapper import ShopScrapper
from Tokped import Tokopedia
import requests
import json
from flask import Flask

headers = {"Content-Type": "application/json; charset=utf-8", "x-hasura-admin-secret": "mythesis"}
menu_options = {
    1: 'Storage',
    2: 'Ram',
    3: 'GPU',
    4: 'CPU',
    5: 'Motherboard',
    6: 'Case',
    7: 'Cooling',
    8: 'PSU',
    9: 'Exit'
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


def put_gpu(datas):
    for data in datas:
        print(f'Updating data {data["id"]}')
        try:
            requests.put("https://hasura-skripsi-binus.herokuapp.com/api/rest/update-gpu-price",
                         params={'id': data['id'], 'price': data['price']},
                         headers=headers)
        except requests.exceptions.RequestException as e:
            raise SystemExit(e)


def put_cpu(datas):
    for data in datas:
        print(f'Updating data {data["id"]}')
        try:
            requests.put("https://hasura-skripsi-binus.herokuapp.com/api/rest/update-cpu-price",
                         params={'id': data['id'], 'price': data['price']},
                         headers=headers)
        except requests.exceptions.RequestException as e:
            raise SystemExit(e)


def put_motherboard(datas):
    for data in datas:
        print(f'Updating data {data["id"]}')
        try:
            requests.put("https://hasura-skripsi-binus.herokuapp.com/api/rest/update-motherboard-price",
                         params={'id': data['id'], 'price': data['price']},
                         headers=headers)
        except requests.exceptions.RequestException as e:
            raise SystemExit(e)


def put_case(datas):
    for data in datas:
        print(f'Updating data {data["id"]}')
        try:
            requests.put("https://hasura-skripsi-binus.herokuapp.com/api/rest/update-case-price",
                         params={'id': data['id'], 'price': data['price']},
                         headers=headers)
        except requests.exceptions.RequestException as e:
            raise SystemExit(e)


def put_cooling(datas):
    for data in datas:
        print(f'Updating data {data["id"]}')
        try:
            requests.put("https://hasura-skripsi-binus.herokuapp.com/api/rest/update-cooling-price",
                         params={'id': data['id'], 'price': data['price']},
                         headers=headers)
        except requests.exceptions.RequestException as e:
            raise SystemExit(e)


def put_psu(datas):
    for data in datas:
        print(f'Updating data {data["id"]}')
        try:
            requests.put("https://hasura-skripsi-binus.herokuapp.com/api/rest/update-psu-price",
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
        print('Handle option \'Storage\'')
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
        print('Handle option \'RAM\'')
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
        print('Handle option \'GPU\'')
        try:
            req = requests.request(method='GET',
                                   url='https://hasura-skripsi-binus.herokuapp.com/api/rest/gpu-prices',
                                   headers=headers)
        except requests.exceptions.RequestException as e:  # This is the correct syntax
            raise SystemExit(e)
        json_data = req.json()['gpu_prices']
        result = handle_request(request=req, data=json_data)
        put_gpu(result)
    elif option == 4:
        print('Handle option \'CPU\'')
        try:
            req = requests.request(method='GET',
                                   url='https://hasura-skripsi-binus.herokuapp.com/api/rest/cpu-prices',
                                   headers=headers)
        except requests.exceptions.RequestException as e:  # This is the correct syntax
            raise SystemExit(e)
        json_data = req.json()['cpu_prices']
        result = handle_request(request=req, data=json_data)
        put_cpu(result)
    elif option == 5:
        print('Handle option \'Motherboard\'')
        try:
            req = requests.request(method='GET',
                                   url='https://hasura-skripsi-binus.herokuapp.com/api/rest/motherboard-prices',
                                   headers=headers)
        except requests.exceptions.RequestException as e:  # This is the correct syntax
            raise SystemExit(e)
        json_data = req.json()['motherboard_prices']
        result = handle_request(request=req, data=json_data)
        put_motherboard(result)
    elif option == 6:
        print('Handle option \'Case\'')
        try:
            req = requests.request(method='GET',
                                   url='https://hasura-skripsi-binus.herokuapp.com/api/rest/case-prices',
                                   headers=headers)
        except requests.exceptions.RequestException as e:  # This is the correct syntax
            raise SystemExit(e)
        json_data = req.json()['case_prices']
        result = handle_request(request=req, data=json_data)
        put_case(result)
    elif option == 7:
        print('Handle option \'Cooling\'')
        try:
            req = requests.request(method='GET',
                                   url='https://hasura-skripsi-binus.herokuapp.com/api/rest/cooling-prices',
                                   headers=headers)
        except requests.exceptions.RequestException as e:  # This is the correct syntax
            raise SystemExit(e)
        json_data = req.json()['cooling_prices']
        result = handle_request(request=req, data=json_data)
        put_cooling(result)
    elif option == 8:
        print('Handle option \'PSU\'')
        try:
            req = requests.request(method='GET',
                                   url='https://hasura-skripsi-binus.herokuapp.com/api/rest/psu-prices',
                                   headers=headers)
        except requests.exceptions.RequestException as e:  # This is the correct syntax
            raise SystemExit(e)
        json_data = req.json()['power_supply_prices']
        result = handle_request(request=req, data=json_data)
        put_psu(result)
    elif option == 9:
        print('Thanks message before exiting')
        exit()
    else:
        print('Invalid option. Please enter a number between 1 and 4.')
