import datetime
from collections import defaultdict
import requests
import yaml
import os
import sys
import re
import json
from uuid import uuid4
import boto3
from botocore.exceptions import ClientError
from requests.exceptions import MissingSchema

PACKAGE_PARENT = '../..'
SCRIPT_DIR = os.path.dirname(os.path.realpath(os.path.join(os.getcwd(), os.path.expanduser(__file__))))
sys.path.append(os.path.normpath(os.path.join(SCRIPT_DIR, PACKAGE_PARENT)))


class TagCounter:
    """
    Tag Counter class use method count with argument url and returns dictionary which consists of:
        uuid:{
            url:
            timestamp:
            date:
            tags_total:
            tags:{
                each tag with count
            }
        }
    In params.yaml you should provide
        S3 bucket name
        max log size
        and log file name
    If you haven't got S3 bucket - put null
    After reaching max size log will be uploaded to S3 if it's provided and erased.
    """
    def __init__(self):
        with open(os.path.join(SCRIPT_DIR, r'./params.yaml')) as file:
            props = yaml.load(file, Loader=yaml.FullLoader)
            self.logs_bucket = props['bucket_name']
            self.max_log_size_mb = props['max_log_size_mb']
            self.output_file_name = props['output_file_name']
        # self.logfile = os.path.join(SCRIPT_DIR, f'./{self.output_file_name}')
        self.id = str(uuid4())
        self.dict = defaultdict()
        self.data = defaultdict()


    @property
    def logfile(self):
        return os.path.join(SCRIPT_DIR, f'./{self.output_file_name}')

    @property
    def date(self):
        return datetime.datetime.now()

    def count(self, url):
        self.load_json()
        headers = {
            "Accept-Language": 'en-US'
        }

        self.dict[self.id] = {
            'url': url,
            'timestamp': self.date.timestamp(),
            'date':str(self.date.strftime("%d.%m.%Y %H:%M:%S")),
        }
        self.dict[self.id]['tags_total'] = 0
        self.dict[self.id]['tags'] = {}
        try:
            response = requests.get(url, headers=headers)
        except (ConnectionError, TimeoutError, MissingSchema) as e:
            print(e)
        result = re.findall(r'<[a-z]+[ ,>]', response.text)
        result_set = sorted(set(result))
        # print(result_set)
        for tag in result_set:
            self.dict[self.id]['tags'][tag[1:-1]] = response.text.count(tag)
            self.dict[self.id]['tags_total'] += response.text.count(tag)
        self.data[self.id] = self.dict[self.id]
        self.write_json()
        self.upload_json()
        return self.dict

    def load_json(self):
        try:
            with open(self.logfile, 'r') as json_log_file:
                self.data = json.load(json_log_file)
                # self.data.update(self.dict)
        except FileNotFoundError as e:
            self.data = self.dict
            print(e)
            print('It would be created!')

    def write_json(self):
        try:
            with open(self.logfile, 'w') as json_output_file:
                json.dump(self.data, json_output_file, indent=4)
        except FileNotFoundError as e:
            print(e)

    def upload_json(self):
        try:
            log_size = os.path.getsize(self.logfile)/(1024*1024)
            if log_size > self.max_log_size_mb:
                if self.logs_bucket:
                    s3 = boto3.resource('s3')
                    s3.meta.client.upload_file(
                        self.logfile,
                        self.logs_bucket,
                        f'{self.date.strftime("%d.%m.%Y/%H:%M:%S")}-{self.output_file_name}'
                    )
                os.remove(self.logfile)
        except (FileNotFoundError, ClientError) as e:
            print(e)


if __name__ == "__main__":
    my_counter = TagCounter()
    if len(sys.argv) == 1:
        print('Input one url, please!')
        print(json.dumps(my_counter.count(input()), indent=4))
    else:
        sys.argv.pop(0)
        for url in sys.argv:
            print(json.dumps(my_counter.count(url), indent=4))
