import csv
from collections import defaultdict



class CsvParser:
    def __init__(self, file_name):
        self.file = file_name

    def sell_over(self, item_type: str, threshold: int):
        with open(self.file) as file:
            dict = csv.DictReader(file, delimiter=',')
            sales = defaultdict(int)
            top_sellers = []
            for line in dict:
                if line["Item Type"] == item_type:
                    sales[str(line["Country"])] += int(line["Units Sold"])
            for key in sales:
                if sales[key] > threshold:
                    print(key, sales[key])
                    top_sellers.append(key)
            print(top_sellers)
            return top_sellers

    def get_country_profit(self, country=None):
        with open(self.file) as file:
            dict = csv.DictReader(file, delimiter=',')
            profit = float()
            for line in dict:
                if line["Country"] == country:
                    profit += float(line["Total Profit"])
            return round(profit, 2)


    def save_as(self, new_file_name, delimiter):
        with open(self.file) as file:
            with open(new_file_name, mode='w', newline='') as new_file:
                reader = csv.reader(file, delimiter=',')
                writer = csv.writer(new_file, delimiter='\t', quotechar='"', quoting=csv.QUOTE_MINIMAL)
                for line in reader:
                    writer.writerow(line)


