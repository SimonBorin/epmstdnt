

class Employee:
    """
    Describes Employee that have Name, Second Name, Full Name, email, salary.
    """
    def __init__(self, first_name, last_name, salary):
        self.first_name = first_name.capitalize()
        self.last_name = last_name.capitalize()
        self.salary = int(salary)

    @classmethod
    def from_str(cls, empl_str):
        first_name, last_name, salary = empl_str.split(",")
        return cls(first_name, last_name, salary)

    @property
    def email(self):
        return f"{self.first_name}_{self.last_name}@example.com".lower()

    @property
    def full_name(self):
        return f"{self.first_name}, {self.last_name}"

    @full_name.setter
    def full_name(self, full_name):
        first_name, last_name = full_name.split(", ")
        self.first_name = first_name.capitalize()
        self.last_name = last_name.capitalize()


class DevOps(Employee):
    def __init__(self, first_name, last_name, salary, skills=None):
        if not skills:
            skills = []
        super().__init__(first_name, last_name, salary)
        self.skills = [skill.capitalize() for skill in skills]

    def add_skill(self, skill):
        if skill.capitalize() not in self.skills:
            self.skills.append(skill.capitalize())

    def remove_skill(self, skill):
        try:
            self.skills.remove(skill.capitalize())
        except ValueError as e:
            return e


class Manager(Employee):
    def __init__(self, first_name, last_name, salary, subordinates=None):
        if not subordinates:
            subordinates = []
        super().__init__(first_name, last_name, salary)
        self.subordinates = subordinates

    def add_subordinate(self, subordinate):
        if subordinate not in self.subordinates:
            self.subordinates.append(subordinate)

    def remove_subordinate(self, subordinate):
        if isinstance(subordinate, str):
            for empl in self.subordinates:
                if empl.email == subordinate:
                    self.subordinates.remove(empl)
        else:
            try:
                self.subordinates.remove(subordinate)
            except ValueError as e:
                print(e)
