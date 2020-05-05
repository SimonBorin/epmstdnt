import boto3
from botocore.exceptions import ClientError
import logging


class Copy_S3:
    """
    This class is all about to copy files from list of s3 buckets to another bucket.
    If destination bucket not exists it will be created
    """
    def __init__(self, source, dest, region=None):
        self.source_name_list = source
        self.dest_name = dest
        self.region = region
        self.s3 = boto3.resource('s3')
        self.copy()

    def create_bucket(self, bucket_name, region=None):
        """Create an S3 bucket in a specified region

        If a region is not specified, the bucket is created in the S3 default
        region (us-east-1).

        :param bucket_name: Bucket to create
        :param region: String region to create bucket in, e.g., 'us-west-2'
        :return: True if bucket created, else False
        """

        # Create bucket
        try:
            if region is None:
                s3_client = boto3.client('s3')
                s3_client.create_bucket(Bucket=bucket_name)
            else:
                s3_client = boto3.client('s3', region_name=region)
                location = {'LocationConstraint': region}
                s3_client.create_bucket(Bucket=bucket_name,
                                        CreateBucketConfiguration=location)
        except ClientError as e:
            logging.error(e)
            return False
        return True

    def copy(self, ):
        """Copy all files from sourse buckets list to dest bucket string.
        Creates dest bucket if it's necessarily
        """
        for source_name in self.source_name_list:
            sours = self.s3.Bucket(source_name)
            dest = self.s3.Bucket(self.dest_name)
            if dest not in self.s3.buckets.all():
                self.create_bucket(self.dest_name, self.region)
            try:
                for obj in sours.objects.filter():
                    files = obj.key
                    copy_source = {
                        'Bucket': source_name,
                        'Key': files
                    }
                    self.s3.meta.client.copy(copy_source, self.dest_name, files)
                    print(files)
            except ClientError as e:
                logging.error(e)
                logging.error(source_name)




if __name__ == "__main__":
    my_bucket_name = 'aws-hw-bucket-64c26dba-73f6-11ea-bc55-0242ac130003'
    dest_name = 'dest-test-ea35fa6d-54ed-42d8-9420-352061817d65'
    copy_those_s3 = Copy_S3
    copy_those_s3([my_bucket_name, 'trege'],'2dest-test-ea35fa6d-54ed-42d8-9420-352061817d65')

