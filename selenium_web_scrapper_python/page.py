import time
from selenium import webdriver
from selenium.webdriver.common.keys import Keys


class PageScraper(webdriver.Edge):
    def __init__(self, web_url=None):
        self.web_url = web_url
        self.web_element = None
        options = webdriver.EdgeOptions()
        options.add_extension('C:/Dev/WebDriver/ublock.crx')
        # options.add_argument("--headless")
        super(PageScraper, self).__init__(options=options)

    # Scroll to the botom of the page
    def __scroll(self):
        # Time wait before scrolling
        SCROLL_PAUSE_TIME = 2

        # Get scroll height
        last_height = self.execute_script("return document.body.scrollHeight")
        html = self.find_element(by='html')

        while True:
            html.send_keys(Keys.END)

            # Wait to load page
            # time.sleep(SCROLL_PAUSE_TIME)

            # Calculate new scroll height and compare with last scroll height
            new_height = self.execute_script("return window.pageYOffset + window.innerHeight")
            if new_height == last_height:
                break

            last_height = new_height

    # Close the browser
    def close_page(self):
        self.close()

    # Get page source
    def __page_source(self):
        return self.page_source

    # Load page
    def get_page_information(self):
        self.get(self.web_url)

        # wait for 3 second for the page to load
        self.implicitly_wait(3)
        # self.__scroll()

        return self.__page_source()
