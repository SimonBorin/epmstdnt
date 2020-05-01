import json
from collections import OrderedDict
import requests
from bs4 import BeautifulSoup
import re
import os
import sys

PACKAGE_PARENT = '../..'
SCRIPT_DIR = os.path.dirname(os.path.realpath(os.path.join(os.getcwd(), os.path.expanduser(__file__))))
sys.path.append(os.path.normpath(os.path.join(SCRIPT_DIR, PACKAGE_PARENT)))


def parse_top_250(filename):
    headers = {
        "Accept-Language": 'en-US'
    }
    url = 'https://imdb.com/chart/top'
    response = requests.get(url, headers=headers)
    soup = BeautifulSoup(response.text, features="lxml")
    top_dict = OrderedDict()
    for tr in soup.find_all('tr'):
        tr.find_all('td', class_='ratingColumn imdbRating')
        for info in tr('td', class_='titleColumn'):
            position = int(info.text.split('\n')[1].replace('.',''))
            year = int(info.span.text.replace('(','').replace(')',''))
            director = info.a.get('title').split(',')[0].replace(' (dir.)','')
            crew = info.a.get('title').split('(dir.), ')[1]
            rate = str(tr.select(' strong ')[0])
            rate = float(re.sub('<[^>]+>', '', rate))
            top_dict[info.a.text] = {
                'Position': position,
                'Year': year,
                'Director': director,
                'Crew': crew,
                'Rating': rate
            }
    with open(filename, 'w') as json_output_file:
        json.dump(top_dict, json_output_file, indent=4)
    # return top_dict


if __name__ == "__main__":
    parse_top_250(os.path.join(SCRIPT_DIR, 'top250.json'))
