s = "Tribol GR 3020/1000-00 PD, Multifak EP 000, KEC, Carboflex OG 000-1500 HD, Carboflex Arctic OG 900 HD, Tribol GR 3020/1000-00 PD, GEARMASTER LI 400, Gadus S2 V220 00"
items = s.split(", ")
print(len(items))
result = ' crlf '.join(f'"{item}"' for item in items)
print(result)
