import boto3
from botocore.exceptions import ClientError
import logging


class Switcher(object):
    def indirect(self, state):
        method = getattr(self, state, lambda: None)
        return method()

    def start(self):
        return 'self.client.start_instances(InstanceIds=self.ids_list)'

    def stop(self):
        return 'self.client.stop_instances(InstanceIds=self.ids_list)'

    def reboot(self):
        return 'self.client.reboot_instances(InstanceIds=self.ids_list)'

    def terminate(self):
        return 'self.client.terminate_instances(InstanceIds=self.ids_list)'


class EC2StatusChanger:
    """
    This class is for changing statuses of ec2 instanses in regions.
    It takes parameters
    'region','current status', 'new status'
    """
    def __init__(self, region, current_status, new_status):
        self.region = region
        self.current_status = current_status
        self.new_status = new_status
        self.client = boto3.client('ec2', region_name=self.region)
        self.ids_list = []
        self.change_status()

    def get_instances_id(self):
        my_filter = [
            {
                'Name': 'instance-state-name',
                'Values': [
                    self.current_status,
                ]
            },
        ]
        try:
            response = self.client.describe_instances(Filters=my_filter)
        except ClientError as e:
            logging.error(e)
        for instance in response['Reservations']:
            for keys in instance['Instances']:
                self.ids_list.append(keys['InstanceId'])

    def change_status(self):
        self.get_instances_id()
        state_switcher = Switcher()
        command = state_switcher.indirect(self.new_status)
        if not command:
            raise ValueError('Invalid State')
        print(command)
        try:
            eval(command)
        except ClientError as e:
            logging.error(e)


if __name__ == "__main__":
    EC2StatusChanger('us-east-2', 'stopped', 'terminate')

