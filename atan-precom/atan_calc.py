from math import atan, pow

SCALE = 1073741824.0
HEX_SCALE = 0x40000000

def calculate_atan_tab():
    tab = []
    for n in range(32):
        tab.append(int(atan(2**-n) * HEX_SCALE))
    return tab


if __name__ == "__main__":
    tab = calculate_atan_tab()
    for el in tab:
        print(hex(el), end=",\n")

