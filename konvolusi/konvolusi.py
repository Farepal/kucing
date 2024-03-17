def convolution(x, first_n_of_x, last_n_of_x, h, first_n_of_h, last_n_of_h):
    y = {}
    for n in range(first_n_of_x + first_n_of_h, last_n_of_x + last_n_of_h + 1):
        y[n] = 0
        for k in range(first_n_of_x, last_n_of_x + 1):
            if n - k in range(first_n_of_h, last_n_of_h + 1):
                y[n] += x[k] * h[n - k]
    return y

x = {}
h = {}

first_n_of_x = 0
last_n_of_x = 50

first_n_of_h = 0
last_n_of_h = 100

for n in range(first_n_of_x, last_n_of_x + 1):
    x[n] = (0.8)**n

for n in range(first_n_of_h, last_n_of_h + 1):
    h[n] = (0.9)**n
    
y = convolution(x, first_n_of_x, last_n_of_x, h, first_n_of_h, last_n_of_h)

# Plot
import matplotlib.pyplot as plt
plt.stem(y.keys(), y.values())
plt.show()

# output y
for n in range(first_n_of_x + first_n_of_h, last_n_of_x + last_n_of_h + 1):
    print(f"y[{n}] = {y[n]}")
