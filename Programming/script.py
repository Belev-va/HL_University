#This script print prime numbers in selected range. Work with python version 2.7 or higher.

#Prime number search function
def primes(a,b):
    if a>b or a<0 or b<0:
        print("Both numbers must be upper 0 and first number must be less second number.")
    else:
        i, j, flag = 0, 0, 0
        primes = []
        for i in range(a, b + 1):
            if (i == 1) or (i == 0):
                continue
            flag = 1
            for j in range(2, i // 2 + 1):
                if (i % j == 0):
                    flag = 0
                    break
            if (flag == 1):
                primes.append(i)
        return(primes)
#Entrypoint for this script
print(primes(int(input("Enter the first number of Range: ")),int(input("Enter the second number of Range: "))))
