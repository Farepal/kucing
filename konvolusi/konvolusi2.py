####### NO 2 #######

def convolution(x, first_n_of_x, last_n_of_x, h, first_n_of_h, last_n_of_h):
    y = {}
    for n in range(first_n_of_x + first_n_of_h, last_n_of_x + last_n_of_h + 1):
        y[n] = 0
        for k in range(first_n_of_x, last_n_of_x + 1):
            if n - k in range(first_n_of_h, last_n_of_h + 1):
                y[n] += x[k] * h[n - k]
    return y

first_n_of_x = 2
last_n_of_x = 4

first_n_of_h = 0
last_n_of_h = 5

x = {}
h = {}

x[2] = 1
x[3] = 0
x[4] = 1

h[0] = 1
h[1] = 1
h[2] = 1
h[3] = 1
h[4] = -1
h[5] = -1

y = convolution(x, first_n_of_x, last_n_of_x, h, first_n_of_h, last_n_of_h)

# Plot
import matplotlib.pyplot as plt
plt.stem(y.keys(), y.values())
plt.show()

# output y
for n in range(first_n_of_x + first_n_of_h, last_n_of_x + last_n_of_h + 1):
    print(f"y[{n}] = {y[n]}")
