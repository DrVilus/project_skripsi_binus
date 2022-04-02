import pandas as pd
import Shop
from Shopee import Shopee
from Tokped import Tokopedia


class ShopScrapper:
    id

    #   storage_id
    #   name
    #   shop
    #   shop_link
    def __init__(self, item_list: list[Shop]):
        self.item_list = item_list

    def to_excel(self, data, f_name='data_product', sheet_name='Sheet1'):
        # Create a workbook and add a worksheet.
        df = pd.DataFrame(data=data, columns=['id', 'name', 'shop', 'shop_link', 'price'])

        # Create a Pandas Excel writer using XlsxWriter as the engine.
        writer = pd.ExcelWriter(f'{f_name}.xlsx', engine='xlsxwriter')

        # Convert the dataframe to an XlsxWriter Excel object.
        df.to_excel(writer, sheet_name=sheet_name)

        # Close the Pandas Excel writer and output the Excel file.
        writer.save()

    def run(self):
        item_list = self.item_list
        datas = []
        i = 1

        print("PROGRAM IS RUNNING PLEASE WAIT ...\n")

        # looping for each pages
        for item in item_list:
            data = []

            print("=======================================")
            print(f"ACCESSING PAGE {i} ...")
            print(item)

            if item['shop'] == "Tokopedia":
                tp = Tokopedia(item)
                tp_result = tp.run()
                data.append(tp_result)
            elif item['shop'] == "Shopee":
                sp = Shopee(item)
                sp_result = sp.run()
                data.append(sp_result)
                print("sssss")

            datas.extend(data)
            i += 1

        print(f"\nSCRAPING COMPLETE {len(datas)} DATA FOUND IN TOTAL")

        return datas
