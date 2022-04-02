from page import PageScraper
import sys
import pandas as pd
from bs4 import BeautifulSoup


class TokopediaBak:
    """
    url: url produk Tokped
    """

    def __init__(self, urls: list[str] = None):
        # self.keyword = keyword.replace(' ', '%20')
        # self.sort = sort
        # self.totalPages = totalPages
        # self.stars4 = stars4
        # self.offStore = offStore
        # self.merchantPro = merchantPro
        # self.merchant = merchant
        # self.minPrice = minPrice
        # self.maxPrice = maxPrice
        self.urls = urls

    # get item's title
    def get_title(self, content):
        return content.find('h1', {'class': 'css-t9du53'}).get_text()

    # get item's price
    # return in form of int
    def get_price(self, content):
        data = content.find('div', {'class': 'price'}).get_text()
        return int(''.join(n for n in data if n.isdigit()))

    # get all searched item div's (class = css-974ipl)
    def get_items_div(self, content):
        divItem = content.find('div', {'id': 'pdp_comp-product_content'})

        return divItem

    # assign data
    def get_data(self, content):
        data = {
            'Title': self.get_title(content),
            'Price (Rp)': self.get_price(content)
        }

        return data

    # return string with filled page={pageNum} based on the page number
    def generate_page_url(self, url, Num):
        return url.format(pageNum=Num)

    # create excel format (source: https://xlsxwriter.readthedocs.io/working_with_pandas.html)
    def to_excel(self, data, f_name='data_product', sheet_name='Sheet1'):
        # Create a workbook and add a worksheet.
        df = pd.DataFrame(data)

        # Create a Pandas Excel writer using XlsxWriter as the engine.
        writer = pd.ExcelWriter(f'{f_name}.xlsx', engine='xlsxwriter')

        # Convert the dataframe to an XlsxWriter Excel object.
        df.to_excel(writer, sheet_name=sheet_name)

        # Close the Pandas Excel writer and output the Excel file.
        writer.save()

    def run(self):
        urls = self.urls
        datas = []
        i = 1

        print("PROGRAM IS RUNNING PLEASE WAIT ...\n")

        # looping for each pages
        for url in urls:
            data = []

            print("=======================================")
            print(f"ACCESSING PAGE {i} ...")

            # Generate page url
            page_url = self.generate_page_url(url=url, Num=i)

            # Scrape page url
            scraper = PageScraper(page_url)
            content = scraper.get_page_information()
            scraper.close_page()

            # use bs4 to scrape all the data within the page
            soup = BeautifulSoup(content, 'html.parser')
            divItems = self.get_items_div(soup)

            # loop for each item's content found
            for div in divItems:
                data.append(self.get_data(div))

            print(f"{len(data)} DATA FOUND\n")

            datas.extend(data)
            i += 1

        print(f"\nSCRAPING COMPLETE {len(datas)} DATA FOUND IN TOTAL")

        return datas
