# PythonCourse

The repository contains unittest for python course.

## Usage

### Copy repository content to your Personal homework repository (do not fork).
1. Your personal repository should like like:
    
        ```
        ├── AWS
        ├── linux
        └── python
            ├── module1
            ├── module2
            ├── module3
            ├── module4
            ├── module5
        ......
        ```
2. Clone repo and copy files:
     ```commandline
     git clone https://github.com/DmitriiTitkov/PythonCourse
     cp cp -r PythonCourse/python $HOMEWORK_REPO_FOLDER
  
     ```
     
### Run tests
```commandline
python3 -m unittest python/module3/test_swap_max_and_min.py
python3 -m unittest discover python/module3/
python3 -m unittest discover python/
```