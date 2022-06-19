from flask import Flask, redirect, render_template, render_template_string, url_for, request
from PIL import Image, ImageFont, ImageDraw
import textwrap
import base64
import pytesseract as ps
import sys

from utils import SpreadSpectrum
from library import RSALibrary
app = Flask(__name__)



# Normal Function 
def write_text(text_to_write, image_size):
    image_text = Image.new("RGB", image_size)
    font = ImageFont.truetype('arial.ttf', 32)
    drawer = ImageDraw.Draw(image_text)

    #Text wrapping. Change parameters for different text formatting
    margin = offset = 0
    for line in textwrap.wrap(text_to_write, width=200):
        drawer.text((margin,offset), line, font=font)
        offset += 0
    return image_text

# Page Routes
@app.route("/")
def home():
    return "Hello, World!"
    
@app.route("/encode",methods=['POST'])
def encode_image():
    try:
        data = request.get_json()
        text_to_encode = data['text']
        print("TEXT: ",data['text'])
        imgbyte = data['img']
   #     print("BYTES: ",imgbyte)
        imgdata = base64.b64decode(imgbyte)
        filename1 = 'image_toencode.png'
        with open(filename1, 'wb') as f:
            f.write(imgdata)
    except:
        print("Error!")
        return "Some error occurred!"
        exit(0)
    
    SpreadSpectrum.encode_image(text_to_encode)
    

    # template_image = Image.open('encoded_image.png')

    # red_template = template_image.split()[0]
    # green_template = template_image.split()[1]
    # blue_template = template_image.split()[2]
    # # print("SIZES")
    # x_size = template_image.size[0]
    # y_size = template_image.size[1]

    # #text draw
    # image_text = write_text(text_to_encode, template_image.size)
    # bw_encode = image_text.convert('1')

    # #encode text into image
    # encoded_image = Image.new("RGB", (x_size, y_size))
    # pixels = encoded_image.load()
    # for i in range(x_size):
    #     for j in range(y_size):
    #         red_template_pix = bin(red_template.getpixel((i,j)))
    #         old_pix = red_template.getpixel((i,j))
    #         tencode_pix = bin(bw_encode.getpixel((i,j)))

    #         if tencode_pix[-1] == '1':
    #             red_template_pix = red_template_pix[:-1] + '1'
    #         else:
    #             red_template_pix = red_template_pix[:-1] + '0'
    #         pixels[i, j] = (int(red_template_pix, 2), green_template.getpixel((i,j)), blue_template.getpixel((i,j)))

    # encoded_image.save("encoded_image.png")
    with open('./encoded_image.png', 'rb') as f:
        imgbyte = base64.b64encode(f.read())
    return imgbyte,200

    # with open('/Users/ketutkusuma/Desktop/TA_ketut-main/API/encoded_image.png', 'rb') as f:
    #     imgbyte = base64.b64encode(f.read())
    # return imgbyte,200

@app.route("/decode",methods=['POST'])
def decode_image():
    try:
        data = request.get_json()
        imgbyte = data['img']
        # print("BYTES: ",imgbyte)
        imgdata = base64.b64decode(imgbyte)
        filename = 'image_todecode.png'
        with open(filename, 'wb') as f:
            f.write(imgdata)
    except:
        print("Error!")
        return "Some error occurred!"
        exit(0)

    decode_text = SpreadSpectrum.decode_image()
 
    print('decode message : ', decode_text)
    return decode_text, 200
    
@app.route("/encrypt",methods=['POST'])
def encrypt():
    key = 3
    n = 37909
    result = request.get_json()
    plaintext = result['text']
    
    encryptedmsg = RSALibrary.encrypt_text_to_text(n, key, plaintext)
    
    # cipher = [(ord(char)**key)% n for char in plaintext]
    # print(cipher)
    # encryptedmsg = ','.join(map(str,cipher))
    print(encryptedmsg)
    
    return encryptedmsg, 200

@app.route("/decrypt",methods=['POST'])
def decrypt():
    key = 25011
    n = 37909
    result = request.get_json()
    ciphertext = result['text']
    # cipherboy = int(float(ciphertext))
    # cipher = map(int, cipherboy.split(','))
    
    # plain = [chr((chr**key)%n) for chr in cipher]
    plain = RSALibrary.decrypt_text_from_text(n, key, ciphertext)
    print(plain)
    
    return plain, 200
    
if __name__ == "__main__":
    app.run(host="10.0.2.2", port=5000)