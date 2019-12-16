## awk & sed
To check first part of awk exercise run in this folder 
```
awk '
BEGIN { for (i=1;i<200;i++)
print int (101*rand())
}' | awk -f histogram
```
To check second part run 
```
awk '
BEGIN { for (i=1;i<200;i++)
print int (101*rand())
}' | awk -f percentage
```