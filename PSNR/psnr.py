"""
	Peak signal-to-noise ratio - PSNR - https://en.wikipedia.org/wiki/Peak_signal-to-noise_ratio
    Soruce: https://tutorials.techonical.com/how-to-calculate-psnr-value-of-two-images-using-python/
"""

import math
import os

import cv2
import numpy as np

def psnr(original, contrast):
    mse = np.mean((original - contrast) ** 2)
    print(mse)
    if mse == 0:
        return 100
    PIXEL_MAX = 255.0
    PSNR = 20 * math.log10(PIXEL_MAX / math.sqrt(mse))
    return PSNR


def main():
    dir_path = os.path.dirname(os.path.realpath(__file__))
    # Loading images (original image and compressed image)
    original = cv2.imread(os.path.join(dir_path, '../Image/dog.png'))
    contrast = cv2.imread(os.path.join(dir_path, '../Image/stego_dog.png'), 1)
    extraction = cv2.imread(os.path.join(dir_path, '../Image/ekstrasi_dog.png'), 1)

    original2 = cv2.imread(os.path.join(dir_path, '../Image/horse.png'))
    contrast2 = cv2.imread(os.path.join(dir_path, '../Image/stego_horse.png'), 1)

    original3 = cv2.imread(os.path.join(dir_path, '../Image/didik.png'))
    contrast3 = cv2.imread(os.path.join(dir_path, '../Image/stego_didik.png'), 1)

    original4 = cv2.imread(os.path.join(dir_path, '../Image/ketut.png'))
    contrast4 = cv2.imread(os.path.join(dir_path, '../Image/stego_ketut.png'), 1)

    original5 = cv2.imread(os.path.join(dir_path, '../Image/townhall.png'))
    contrast5 = cv2.imread(os.path.join(dir_path, '../Image/stego_townhall.png'), 1)

    original6 = cv2.imread(os.path.join(dir_path, '../Image/dog.png'))
    contrast6 = cv2.imread(os.path.join(dir_path, '../Image/stego_dog.png'), 1)
    
    original7 = cv2.imread(os.path.join(dir_path, '../Image/speed.png'))
    contrast7 = cv2.imread(os.path.join(dir_path, '../Image/stego_speed.png'), 1)

    original8 = cv2.imread(os.path.join(dir_path, '../Image/museum.png'))
    contrast8 = cv2.imread(os.path.join(dir_path, '../Image/stego_museum.png'), 1)

    # Value expected: 29.73dB
    print("-- First Test --")
    print(f"PSNR = {psnr(original, contrast)} dB")
    print(f"PSNR kedua = {psnr(original, extraction)} dB")

    # # Value expected: 31.53dB (Wikipedia Example)
    print("\n-- Second Test --")
    print(f"PSNR = {psnr(original2, contrast2)} dB")

    print("\n-- Third Test --")
    print(f"PSNR = {psnr(original3, contrast3)} dB")

    print("\n-- Fourth Test --")
    print(f"PSNR = {psnr(original4, contrast4)} dB")

    print("\n-- Fifth Test --")
    print(f"PSNR = {psnr(original5, contrast5)} dB")

    print("\n-- 6 --")
    print(f"PSNR = {psnr(original6, contrast6)} dB")

    print("\n-- 7 --")
    print(f"PSNR = {psnr(original7, contrast7)} dB")

    print("\n-- 8 --")
    print(f"PSNR = {psnr(original8, contrast8)} dB")



if __name__ == '__main__':
    main()
