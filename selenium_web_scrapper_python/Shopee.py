import Shop
from page import PageScraper
from bs4 import BeautifulSoup


class Shopee:
    """
    url: url produk Tokped
    """

    def __init__(self, item: Shop = None):
        # self.keyword = keyword.replace(' ', '%20')
        # self.sort = sort
        # self.totalPages = totalPages
        # self.stars4 = stars4
        # self.offStore = offStore
        # self.merchantPro = merchantPro
        # self.merchant = merchant
        # self.minPrice = minPrice
        # self.maxPrice = maxPrice
        self.item = item

    # get item's title
    def get_title(self, content):
        return content.find('h1', {'class': '_3g8My-'}).get_text()

    # get item's price
    # return in form of int
    def get_price(self, content):
        data = content.find('div', {'class': '_2v0Hgx-'}).get_text()
        return int(''.join(n for n in data if n.isdigit()))

    # get all searched item div's (class = css-974ipl)
    def get_items_div(self, content):
        divItem = content.find('div', {'class': 'flex flex-auto _3qq4y7'})

        return divItem

    # assign data
    def get_data(self, content):
        data = {
            'id': self.item['id'],
            'name': self.get_title(content),
            'shop': self.item['shop'],
            'shop_link': self.item['shop_link'],
            'price': self.get_price(content),
        }

        return data

    def run(self):
        item = self.item

        # Scrape page url
        scraper = PageScraper(item['shop_link'])
        content = scraper.get_page_information()
        scraper.close_page()

        # use bs4 to scrape all the data within the page
        soup = BeautifulSoup(content, 'html.parser')
        div = self.get_items_div(soup)

        data = self.get_data(div)

        print("DATA FOUND\n")

        return data
