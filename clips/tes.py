tradename = ['Philips Cool Daylight', 'Philips Warm Daylight', 'Philips Cool Daylight', 'Osram Daylight', 'Osram Warm White', 'Osram Daylight', 'Osram Warm White', 'Toshiba Cool White', 'Bright cool White', 'Cash Warm White', 'Evenzo Cool White', 'Philips Genic', 'Osram Duluxstar']
typeoflamp = ['LED', 'LED', 'LED', 'LED', 'LED', 'LED', 'LED', 'LED', 'LED', 'LED', 'LED', 'CFL', 'CFL']
nominal_power = [4.0, 5.0, 7.0, 4.0, 4.5, 6.0, 8.0, 5.5, 5.0, 7.0, 3.0, 5.0, 5.0]
power_factor = [0.69, 0.71, 0.72, 0.48, 0.47, 0.50, 0.79, 0.58, 0.46, 0.48, 0.47, 0.56, 0.59]
life_span = [25, 25, 25, 25, 25, 25, 25, 30, 6, 20, 18, 4, 3]

# print(len(tradename))
# print(len(typeoflamp))
# print(len(nominal_power))
# print(len(power_factor))
# print(len(life_span))

for i in range(13):
    print(f"(defrule p{i}")
    print(f"\t(type-of-lamp {typeoflamp[i]})")
    print(f"\t(nomial-power {nominal_power[i]})")
    print(f"\t(power-factor {power_factor[i]})")
    print(f"\t(life-span {life_span[i]})")
    print('=>')
    print(f'(printout t crlf "Trade name: {tradename[i]}" crlf))')
    print()